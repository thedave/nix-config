# Nix Darwin Configuration

Declarative macOS system configuration using nix-darwin + home-manager.

## Architecture

- `flake.nix` — Entry point. Defines `darwinConfigurations.macbox` for aarch64-darwin.
- `modules/core.nix` — System-level settings: system packages, launchd agents, dock layout, macOS defaults, activation scripts.
- `modules/home.nix` — User-level config via home-manager: dev packages, git, zsh, fzf, zoxide, direnv.
- `modules/homebrew.nix` — Homebrew casks, brews, and Mac App Store apps (managed declaratively, `zap` removes unlisted).

## Key Details

- **User**: `david`, home at `/Users/david`
- **Hostname**: `macbox`
- **Nix flavor**: Determinate Systems installer, flakes enabled
- **Formatter**: `alejandra` (installed via Homebrew)
- **Rebuild command**: `rebuild` alias runs `sudo darwin-rebuild switch --flake ~/.config/nix#$(scutil --get LocalHostName)`
- **Update command**: `update` alias runs flake update then rebuild

## Development Workflow

```sh
# Format nix files before committing
alejandra .

# Rebuild after changes
rebuild

# Update flake inputs and rebuild
update
```

## Conventions

- Nix files use the standard nixpkgs formatting style (alejandra-compatible)
- Homebrew is only for GUI casks and tools not available in nixpkgs — prefer nixpkgs for CLI tools
- The `user` variable is defined once in `flake.nix` and threaded through via `extraSpecialArgs`
- Activation scripts in `core.nix` handle imperative setup (dock layout, accessibility settings)
