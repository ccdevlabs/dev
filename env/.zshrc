# Powerlevel10k instant prompt — must be first, before any output.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Interactive shell config.

# Make sure brew + PATH are set even in non-login shells (e.g. ghostty default)
[ -f "$HOME/.zprofile" ] && source "$HOME/.zprofile"

# ── Prompt ────────────────────────────────────────────────────────────────
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ── Plugins ───────────────────────────────────────────────────────────────
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── History ───────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Add aliases, prompt, completion, history config here.
# When this grows past ~50 lines, split into ~/.config/zsh/*.zsh and source them:
#   for f in "$HOME/.config/zsh/"*.zsh; do source "$f"; done
