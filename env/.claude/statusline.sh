#!/bin/bash
set -f

input=$(cat)
[ -z "$input" ] && exit 0

# Color definitions (unified gray tones)
fg='\033[38;2;160;160;160m'
bright='\033[38;2;200;200;200m'
dim='\033[2m'
reset='\033[0m'
sep=" ${dim}│${reset} "

# Progress bar
build_bar() {
    local pct=$1 width=$2
    [ "$pct" -lt 0 ] 2>/dev/null && pct=0
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local f="" e=""
    for ((i=0; i<filled; i++)); do f+="━"; done
    for ((i=0; i<empty;  i++)); do e+="─"; done
    printf "${bright}${f}${dim}${e}${reset}"
}

# ISO timestamp to countdown string
iso_countdown() {
    local iso="$1"
    [ -z "$iso" ] || [ "$iso" = "null" ] && return
    local stripped="${iso%%.*}"
    stripped="${stripped%%Z}"
    stripped="${stripped%%+*}"
    local epoch
    # macOS
    epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    # Linux fallback
    [ -z "$epoch" ] && epoch=$(date -d "$iso" +%s 2>/dev/null)
    [ -z "$epoch" ] && return
    local diff=$(( epoch - $(date +%s) ))
    [ "$diff" -le 0 ] && { printf "now"; return; }
    if [ "$diff" -ge 86400 ]; then
        printf "%dd%dh%02dm" $(( diff / 86400 )) $(( (diff % 86400) / 3600 )) $(( (diff % 3600) / 60 ))
    elif [ "$diff" -ge 3600 ]; then
        printf "%dh%02dm" $(( diff / 3600 )) $(( (diff % 3600) / 60 ))
    else
        printf "%dm" $(( diff / 60 ))
    fi
}

# Parse stdin
model=$(echo "$input" | jq -r '.model.display_name // "Claude"' | awk '{print $1}')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Retrieve OAuth token
get_token() {
    [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ] && { echo "$CLAUDE_CODE_OAUTH_TOKEN"; return; }
    if command -v security >/dev/null 2>&1; then
        local t
        t=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null \
            | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
        [ -n "$t" ] && [ "$t" != "null" ] && { echo "$t"; return; }
    fi
    local f="$HOME/.claude/.credentials.json"
    [ -f "$f" ] && { jq -r '.claudeAiOauth.accessToken // empty' "$f" 2>/dev/null; return; }
}

# Fetch usage with 5-minute cache and 429 back-off
cache_dir="/tmp/claude"
cache="$cache_dir/statusline-usage-cache.json"
backoff="$cache_dir/statusline-backoff"
mkdir -p "$cache_dir"
usage=""
refresh=true

if [ -f "$cache" ]; then
    age=$(( $(date +%s) - $(stat -f %m "$cache" 2>/dev/null \
        || stat -c %Y "$cache" 2>/dev/null || echo 0) ))
    [ "$age" -lt 300 ] && { refresh=false; usage=$(cat "$cache"); }
fi

if $refresh && [ -f "$backoff" ]; then
    backoff_age=$(( $(date +%s) - $(stat -f %m "$backoff" 2>/dev/null \
        || stat -c %Y "$backoff" 2>/dev/null || echo 0) ))
    [ "$backoff_age" -lt 600 ] && refresh=false
fi

if $refresh; then
    tok=$(get_token)
    if [ -n "$tok" ]; then
        http_code=$(curl -s -o "$cache_dir/resp.tmp" -w "%{http_code}" --max-time 5 \
            -H "Accept: application/json" \
            -H "Authorization: Bearer $tok" \
            -H "anthropic-beta: oauth-2025-04-20" \
            -H "User-Agent: claude-code/2.1.76" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if [ "$http_code" = "200" ] && jq -e '.five_hour' "$cache_dir/resp.tmp" >/dev/null 2>&1; then
            cp "$cache_dir/resp.tmp" "$cache"
            rm -f "$backoff"
            usage=$(cat "$cache")
        elif [ "$http_code" = "429" ]; then
            touch "$backoff"
        fi
        rm -f "$cache_dir/resp.tmp"
    fi
    [ -z "$usage" ] && [ -f "$cache" ] && usage=$(cat "$cache")
fi

# Build output
out="${bright}${model}${reset}"
out+="${sep}${fg}Context ${bright}${ctx_pct}%${reset}"

if [ -n "$usage" ] && echo "$usage" | jq -e '.five_hour' >/dev/null 2>&1; then
    h5_pct=$(echo "$usage" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
    h5_reset=$(iso_countdown "$(echo "$usage" | jq -r '.five_hour.resets_at // empty')")
    out+="${sep}${fg}5h${reset} $(build_bar "$h5_pct" 8) ${bright}${h5_pct}%${reset}"
    [ -n "$h5_reset" ] && out+=" ${dim}${h5_reset}${reset}"

    d7_pct=$(echo "$usage" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
    d7_reset=$(iso_countdown "$(echo "$usage" | jq -r '.seven_day.resets_at // empty')")
    out+="${sep}${fg}7d${reset} $(build_bar "$d7_pct" 8) ${bright}${d7_pct}%${reset}"
    [ -n "$d7_reset" ] && out+=" ${dim}${d7_reset}${reset}"
fi

printf "%b" "$out"
exit 0
