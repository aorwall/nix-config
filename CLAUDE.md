# nix-config

Declarative macOS system configuration using nix-darwin, home-manager, nix-homebrew, and sops-nix.

## Architecture

- **flake.nix** — Entry point. Wires together nixpkgs-unstable, nix-darwin, home-manager, nix-homebrew, and sops-nix. Single `darwinConfigurations."albert-mbp"` output for aarch64-darwin. Also declares `formatter.aarch64-darwin` for `nix fmt`.
- **system.nix** — Nix daemon settings (Determinate manages the daemon, so `nix.enable = false`), user declaration, `system.primaryUser`, zsh, stateVersion.
- **macos.nix** — macOS defaults: keyboard (caps→escape, fast repeat, no press-and-hold), dock (autohide, no mru-spaces), finder (show all, path in title, sort folders first), Touch ID for sudo.
- **homebrew.nix** — Declarative Homebrew via nix-darwin. Taps, brews (packages without nix equivalents or broken in nixpkgs), and casks (GUI apps). `cleanup = "none"` during migration, switch to `"zap"` once stable.
- **home/** — Modular home-manager config, split into focused files:
  - **home/default.nix** — Hub. Imports all sub-modules, declares `stateVersion` and `home.packages`.
  - **home/shell.nix** — Zsh config: aliases (git, k8s, navigation, ls via eza), history, functions (`take`, `sternpp`), initContent (SDKMAN, NVM, Poetry, GCloud, Bun).
  - **home/git.nix** — `programs.git`, `programs.delta` (side-by-side diffs), `programs.gh`.
  - **home/programs.nix** — `programs.direnv` + nix-direnv, `programs.starship`, `programs.neovim`, `programs.zoxide`, `programs.eza`, `programs.bat`, `programs.nix-index`.
  - **home/secrets.nix** — sops-nix home-manager config. Points to age keyfile and `secrets/secrets.yaml`.
- **secrets/** — sops-encrypted secret files (committed as ciphertext, safe for git).
- **.sops.yaml** — sops creation rules mapping age public keys to secret file paths.

## Package strategy

- **Nix packages (home/default.nix):** CLI tools that have working nixpkgs builds on aarch64-darwin.
- **Brew formulae (homebrew.nix):** Packages not in nixpkgs (claude-squad, nchat), packages with licensing/tap issues (terraform), or packages broken in nixpkgs (argocd).
- **Brew casks (homebrew.nix):** All GUI apps (alt-tab, blackhole-2ch, claude-code, codex, ghostty).
- When adding a new CLI tool, prefer nix (`home.packages`) over brew. Use brew only when the nix package doesn't exist or is broken on macOS.
- When a program has a dedicated home-manager module (check `programs.*`), use that instead of a raw package — it handles shell integration and config generation.

## Secrets management

Secrets are managed via **sops-nix** with **age** encryption:

- Age private key lives at `~/.config/sops/age/keys.txt` (never committed).
- `.sops.yaml` at repo root defines which age public keys can decrypt which files.
- `secrets/secrets.yaml` contains encrypted secrets (safe to commit — ciphertext only).
- `home/secrets.nix` wires sops-nix into home-manager and declares individual secrets.
- To edit secrets: `sops secrets/secrets.yaml` (decrypts in-place, re-encrypts on save).
- To add a new secret: declare it in `home/secrets.nix` under `sops.secrets."name" = {};`, then add the value via `sops secrets/secrets.yaml`.

## Key commands

```bash
# Apply configuration changes (requires sudo)
sudo darwin-rebuild switch --flake ~/.config/nix-config#albert-mbp

# Update all flake inputs
nix flake update --flake ~/.config/nix-config

# Update a specific input
nix flake update home-manager --flake ~/.config/nix-config

# Format all nix files
nix fmt
```

## Important details

- Nix daemon is managed by **Determinate Systems installer**, not nix-darwin (`nix.enable = false`). Do not add `nix.settings` options — they will be ignored.
- `home-manager.backupFileExtension = "backup"` — existing dotfiles get `.backup` suffix when home-manager takes over.
- `nix-homebrew.autoMigrate = true` — was needed for initial migration from existing Homebrew install. Can be removed after first successful build.
- `nix-homebrew.mutableTaps = false` — taps are pinned as flake inputs for full reproducibility.
- `system.stateVersion = 5` — do not change this after initial setup.
- `home.stateVersion = "24.11"` — do not change this after initial setup.
- All files must be tracked by git (`git add`) before `darwin-rebuild switch` will see changes.
