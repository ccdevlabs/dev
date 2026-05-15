# ============================================================================
# Brewfile — applied by runs/brew via `brew bundle`.
#
# To refresh from the current machine:
#   brew bundle dump --file=Brewfile --describe --force
#
# Triaged 2026-05-15 from live + stale machine merge.
# Workflow: terminal-first, AI via claude-code (runs/claude-code) + opencode + claude desktop.
# ============================================================================

# ── Taps ────────────────────────────────────────────────────────────────────
tap "dopplerhq/cli"
tap "localsend/localsend"
tap "oven-sh/bun"
tap "sst/tap"

# ── Shell core ──────────────────────────────────────────────────────────────
brew "bash"                       # newer than system /bin/bash (3.2)
brew "tmux"
brew "fzf"
brew "zoxide"                     # smart cd
brew "bat"                        # cat + syntax highlighting
brew "eza"                        # modern ls (covers tree via --tree)
brew "fd"                         # modern find
brew "ripgrep"
brew "jq"
brew "tlrc"                       # tldr client

# ── Zsh ─────────────────────────────────────────────────────────────────────
brew "powerlevel10k"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# ── Git ─────────────────────────────────────────────────────────────────────
brew "git"
brew "gh"
brew "git-delta"                  # nicer diff renderer
brew "lazygit"

# ── Editor ──────────────────────────────────────────────────────────────────
brew "neovim"

# ── Node / JS ───────────────────────────────────────────────────────────────
brew "fnm"                        # node version manager
brew "pnpm"
brew "oven-sh/bun/bun"

# ── Other languages ─────────────────────────────────────────────────────────
brew "go"                         # required for the `go install` lines below
brew "zig"
# Rust:   install via `curl https://sh.rustup.rs -sSf | sh` when needed
# Python: managed via `uv` (install with `curl -LsSf https://astral.sh/uv/install.sh | sh`)
# JVM:    install ad-hoc per project, not pinned here

# ── Cloud / infra ───────────────────────────────────────────────────────────
brew "awscli"
brew "dopplerhq/cli/doppler"      # secrets manager
brew "sst/tap/sst"                # SST infra
brew "protobuf"
brew "protoc-gen-go"
# Postgres: run per-project in orbstack containers, not on the host

# ── AI CLIs ─────────────────────────────────────────────────────────────────
# Claude Code installs via runs/claude-code (official install script, not brew)
brew "sst/tap/opencode"
brew "rtk"                        # LLM token-saving proxy

# ── Media ───────────────────────────────────────────────────────────────────
brew "ffmpeg"
brew "imagemagick"                # pulls jpeg-turbo, webp, libavif, etc. as deps

# ── Misc ────────────────────────────────────────────────────────────────────
brew "gnupg"
brew "mas"                        # Mac App Store CLI

# ── Casks: Browsers ─────────────────────────────────────────────────────────
cask "arc"
cask "firefox"

# ── Casks: Communication ────────────────────────────────────────────────────
cask "slack"
cask "discord"
cask "signal"
cask "telegram"
cask "zoom"

# ── Casks: Terminal & Dev ───────────────────────────────────────────────────
cask "ghostty"
cask "zed"                        # lightweight GUI editor (complement to neovim)
cask "claude"                     # Anthropic desktop
cask "fork"                       # git GUI for the visual reviews
cask "orbstack"                   # Docker Desktop replacement
cask "beekeeper-studio"           # DB GUI
cask "ngrok"                      # tunneling

# ── Casks: Input & Window management ────────────────────────────────────────
cask "karabiner-elements"
cask "loop"
cask "maccy"                      # clipboard manager
cask "mos"                        # mouse smooth-scroll

# ── Casks: Utilities ────────────────────────────────────────────────────────
cask "raycast"
cask "shottr"                     # screenshots
cask "kap"                        # screen recorder
cask "betterdisplay"
cask "keka"                       # archives
cask "imageoptim"
cask "bitwarden"
cask "localsend/localsend/localsend"
cask "obsidian"

# ── Casks: Media ────────────────────────────────────────────────────────────
cask "iina"
cask "spotify"
cask "baidunetdisk"

# ── Casks: Design ───────────────────────────────────────────────────────────
cask "figma"
cask "miro"

# ── Fonts ───────────────────────────────────────────────────────────────────
cask "font-maple-mono-nf-cn"      # primary mono w/ CJK
cask "font-symbols-only-nerd-font"

# ── Mac App Store ───────────────────────────────────────────────────────────
mas "LINE", id: 539883307
mas "Tailscale", id: 1475387142
mas "Xcode", id: 497799835

# ── Go tools (via `go install`) ─────────────────────────────────────────────
go "github.com/air-verse/air"
go "github.com/go-delve/delve/cmd/dlv"
go "github.com/incu6us/goimports-reviser/v3"
go "github.com/golangci/golangci-lint/cmd/golangci-lint"
go "github.com/segmentio/golines"
go "github.com/pressly/goose/v3/cmd/goose"
go "golang.org/x/tools/gopls"
go "github.com/sqlc-dev/sqlc/cmd/sqlc"
go "honnef.co/go/tools/cmd/staticcheck"
go "github.com/a-h/templ/cmd/templ"
