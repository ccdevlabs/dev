# Login shell environment.

# Homebrew (M-series — /opt/homebrew)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Personal scripts on PATH
export PATH="$HOME/.local/bin:$HOME/.local/scripts:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
