# Interactive shell config.

# Make sure brew + PATH are set even in non-login shells (e.g. ghostty default)
[ -f "$HOME/.zprofile" ] && source "$HOME/.zprofile"

# Add aliases, prompt, completion, history config here.
# When this grows past ~50 lines, split into ~/.config/zsh/*.zsh and source them:
#   for f in "$HOME/.config/zsh/"*.zsh; do source "$f"; done
