# dev

Personal dev-environment bootstrap for M-series Macs. Adapted from [ThePrimeagen/dev](https://github.com/ThePrimeagen/dev).

## Goal

One bash one-liner from a fresh Mac to a fully configured machine. No ansible.

## Fresh machine

```
curl -fsSL https://raw.githubusercontent.com/ccdevlabs/dev/main/setup | bash
```

The `setup` script installs Xcode CLT + Homebrew, clones this repo to `~/personal/dev`, then runs `./run`.

## Anatomy

| Path | Role |
|---|---|
| `setup` | Bootstrap. The `curl \| bash` target. |
| `run` | Dispatcher. Walks `runs/`, executes each file. `./run <name>` filters by substring. `--dry` previews. |
| `runs/*` | One executable per concern. Drop a file in, it runs. |
| `Brewfile` | Declarative package list. Applied by `runs/brew`. |
| `env/` | Dotfiles mirrored to `$HOME` layout. Top-level files become symlinks at `~`; `env/.config/<tool>` becomes a symlink at `~/.config/<tool>`. |
| `init` | `git submodule init/update`. |
| `mac-update-dotfiles` | Re-sync after edits (symlinks + brew bundle). |

## Extending

See **[GUIDE.md](GUIDE.md)** for the full philosophy, decision trees, and worked examples.

Quick reference:

| To add… | Put it in |
|---|---|
| A Homebrew package | `Brewfile` |
| A tool with a `curl \| bash` installer | `runs/<name>` |
| A macOS system preference | `runs/macos-defaults` |
| A dotfile that lives in `$HOME` | `env/.<file>` or `env/.config/<tool>/…` |

## Conventions

- Scripts get the repo root via `$DEV_ENV` (set by the dispatcher).
- `--dry` works for any script invoked via `./run`.
- M-series only — Homebrew is hardcoded at `/opt/homebrew`.
- Symlinks, not copies — edit live in `~`, changes flow back to the repo.
