# Login shell environment.

# Homebrew (M-series — /opt/homebrew)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Personal scripts on PATH
export PATH="$HOME/.local/bin:$HOME/.local/scripts:$PATH"
