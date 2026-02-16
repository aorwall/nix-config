# nix-config

Declarative macOS system configuration using nix-darwin, home-manager, and nix-homebrew.

## Architecture

- **flake.nix** — Entry point. Wires together nixpkgs-unstable, nix-darwin, home-manager, and nix-homebrew. Single `darwinConfigurations."albert-mbp"` output for aarch64-darwin.
- **system.nix** — Nix daemon settings (Determinate manages the daemon, so `nix.enable = false`), user declaration, `system.primaryUser`, zsh, stateVersion.
- **macos.nix** — macOS defaults: keyboard (caps→escape, fast repeat, no press-and-hold), dock (autohide, no mru-spaces), finder (show all, path in title, sort folders first), Touch ID for sudo.
- **homebrew.nix** — Declarative Homebrew via nix-darwin. Taps, brews (packages without nix equivalents or broken in nixpkgs), and casks (GUI apps). `cleanup = "none"` during migration, switch to `"zap"` once stable.
- **home.nix** — home-manager config. CLI tools as nix packages, plus program modules with shell integration (direnv, starship, neovim, gh, git).

## Package strategy

- **Nix packages (home.nix):** CLI tools that have working nixpkgs builds on aarch64-darwin.
- **Brew formulae (homebrew.nix):** Packages not in nixpkgs (claude-squad, nchat), packages with licensing/tap issues (terraform), or packages broken in nixpkgs (argocd).
- **Brew casks (homebrew.nix):** All GUI apps (alt-tab, blackhole-2ch, claude-code, codex, ghostty).
- When adding a new CLI tool, prefer nix (`home.packages`) over brew. Use brew only when the nix package doesn't exist or is broken on macOS.
- When a program has a dedicated home-manager module (check `programs.*`), use that instead of a raw package — it handles shell integration and config generation.

## Key commands

```bash
# Apply configuration changes (requires sudo)
sudo darwin-rebuild switch --flake ~/.config/nix-config#albert-mbp

# Update all flake inputs
nix flake update --flake ~/.config/nix-config

# Update a specific input
nix flake update home-manager --flake ~/.config/nix-config
```

## Important details

- Nix daemon is managed by **Determinate Systems installer**, not nix-darwin (`nix.enable = false`). Do not add `nix.settings` options — they will be ignored.
- `home-manager.backupFileExtension = "backup"` — existing dotfiles get `.backup` suffix when home-manager takes over.
- `nix-homebrew.autoMigrate = true` — was needed for initial migration from existing Homebrew install. Can be removed after first successful build.
- `nix-homebrew.mutableTaps = true` — allows normal `brew tap` usage. Set to `false` and pin taps as flake inputs for full reproducibility later.
- `system.stateVersion = 5` — do not change this after initial setup.
- `home.stateVersion = "24.11"` — do not change this after initial setup.
- All files must be tracked by git (`git add`) before `darwin-rebuild switch` will see changes.
