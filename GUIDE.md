# Extending this dev env

Conventions for adding tools, dotfiles, and macOS tweaks without breaking the bootstrap. Adapted from [ThePrimeagen/dev](https://github.com/ThePrimeagen/dev), kept deliberately small.

## Philosophy

1. **Bash + filesystem are the orchestrator.** No ansible, no Make, no YAML. Adding a tool means dropping a file in a directory.
2. **Drop-in extensibility.** A new executable in `runs/` joins the chain automatically. No registry, no config file, no manifest.
3. **No dependency graph.** Scripts run in alphabetical order and are expected to be independent. If two scripts genuinely depend on each other, that's a signal to fold them into one.
4. **Declarative where possible, imperative where necessary.** `Brewfile` for packages (one declarative source of truth). `runs/*` for things brew can't own (vendor installers, `defaults write`, post-install hooks).
5. **Symlinks, not copies.** Dotfiles in `env/` symlink into `$HOME`, so live edits flow back to the repo. No drift between "what's installed" and "what's tracked".
6. **Idempotent.** Every script must be safe to re-run. `brew bundle` and `defaults write` are naturally idempotent; vendor installers should check before installing.
7. **Dry-run is a first-class mode.** The dispatcher supports `--dry`. Don't write scripts that ignore this.

## Where does a new thing go? (the four buckets)

| If the thing is… | Put it in | Notes |
|---|---|---|
| A Homebrew formula / cask / mas / vscode / go / uv install | `Brewfile` | Single declarative file. `runs/brew` applies it. |
| A tool with an official `curl \| bash` installer (not in brew) | `runs/<name>` | One executable per tool. Example: `runs/claude-code`. |
| A macOS system preference | `runs/macos-defaults` | Group with other `defaults write` calls. |
| A config file that lives in `$HOME` | `env/.<file>` or `env/.config/<tool>/…` | `runs/symlink-dotfiles` symlinks it on each run. |
| A config dir that deserves its own repo (e.g. nvim) | git submodule under `env/` | `init` runs `git submodule init/update`. |

## Decision tree — adding a new tool

```
Is the tool installable via Homebrew?
├── Yes → add a line to Brewfile (under the matching section)
│         Done. The next `./mac-update-dotfiles` picks it up.
│
└── No, but it has an official install script (curl|bash, install.sh, etc.)
    │
    ├── Create runs/<name>:
    │     #!/usr/bin/env bash
    │     set -euo pipefail
    │     command -v <bin> &>/dev/null && exit 0     # idempotency guard
    │     curl -fsSL <official-url> | bash
    │
    ├── chmod +x runs/<name>
    │
    └── Verify: DEV_ENV=$(pwd) ./run --dry <name>
```

If the tool *also* has a config file: see the dotfile tree below.

## Decision tree — adding / moving a dotfile

```
Where does the live config live on disk?
│
├── $HOME/.<file>                  →  env/.<file>           (e.g. env/.zshrc)
├── $XDG_CONFIG_HOME/<tool>/…      →  env/.config/<tool>/…  (e.g. env/.config/ghostty/config)
├── $HOME/.local/<thing>/…         →  env/.local/<thing>/…
└── Anywhere else                  →  consider a runs/<name> that does the copy/link explicitly
```

After moving it: `./mac-update-dotfiles` re-runs the symlinker. If a real file (not a symlink) exists at the destination, `runs/symlink-dotfiles` backs it up to `*.backup` before linking.

## Script conventions

Every file in `runs/`:

- Starts with `#!/usr/bin/env bash` and `set -euo pipefail`.
- Is `chmod +x` (the dispatcher uses `find -perm -u=x`).
- Is idempotent — check before installing, prefer tools whose own behaviour is idempotent (`brew bundle`, `defaults write`, `ln -sfn`).
- Uses `$DEV_ENV` for repo-relative paths (the dispatcher sets it). Never hardcode `~/personal/dev`.
- Doesn't require sudo unless absolutely necessary. If it does, fail loud — don't silently prompt mid-bootstrap.
- Doesn't depend on another `runs/*` script having run first. If you genuinely need ordering, see below.

## Ordering

Scripts run in alphabetical order. Current order:

```
brew → claude-code → macos-defaults → symlink-dotfiles
```

If you need to force an order, prefix with two-digit numbers (`00-brew`, `50-claude-code`, `99-symlink-dotfiles`). Don't rely on lexical order from kebab-case names accidentally aligning.

## Worked examples

### Adding `lazydocker` (it's in Homebrew)

```ruby
# In Brewfile, under "Cloud / infra":
brew "lazydocker"
```
That's it. `./mac-update-dotfiles` picks it up.

### Adding `rustup` (not in Homebrew, has install script)

```bash
# runs/rustup
#!/usr/bin/env bash
set -euo pipefail
command -v rustup &>/dev/null && exit 0
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
```
Then `chmod +x runs/rustup` and commit.

### Adding ghostty config

1. Copy live config: `cp -r ~/.config/ghostty env/.config/ghostty`
2. Run `./mac-update-dotfiles` — the symlinker replaces `~/.config/ghostty` with a symlink to the repo copy (live file backed up to `~/.config/ghostty.backup` once).
3. From now on, editing `~/.config/ghostty/config` *is* editing the repo. Commit when ready.

### Adding a macOS tweak

Add a `defaults write` line in `runs/macos-defaults` under the matching section. Run `runs/macos-defaults` directly to apply it to the current machine. Commit when verified.

## Anti-patterns to avoid

- **Adding transitive dependencies to `Brewfile`.** If `imagemagick` pulls `jpeg-turbo` and `webp`, don't list them separately. `brew bundle dump` includes them by default — strip on review.
- **Duplicates across mechanisms.** `brew "sqlc"` *and* `go "...sqlc..."` install the same tool twice. Pick one (prefer the `go` line for tools you want versioned per-project).
- **Copying instead of symlinking dotfiles.** `runs/symlink-dotfiles` is the only mechanism. Don't add ad-hoc `cp -r` in other scripts.
- **Introducing an orchestrator.** No Makefile, no `pyinvoke`, no shell DSL. Bash + a `for` loop is the contract. If you need more, you've probably outgrown this repo.
- **Scripts that aren't idempotent.** A bootstrap that fails halfway through should be safe to re-run from scratch. No `git clone` without an "exists?" guard, no `brew install` without `--needed`, etc.
- **Silent sudo prompts mid-script.** If a step needs sudo, make it loud and skippable. Better: surface it as a manual one-off in this guide.
- **Cross-script dependencies.** If `runs/B` only works after `runs/A` did something, fold them or add the dependency check inside `B`.

## When in doubt

- Read `runs/claude-code` — it's the minimal correct shape of a vendor-installer script.
- Read `runs/symlink-dotfiles` — the canonical example of repo-edits-flow-back-to-disk.
- Read `runs/macos-defaults` — the canonical example of grouped, commented imperative configuration.
- The whole repo is meant to stay readable in one sitting. If a change makes that no longer true, reconsider the change.
