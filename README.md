# Solar System

---

## Directory Structure

### 🔹 NixOS Configuration (`nixos/`)

- **`flake.nix`** – Core Nix flake definition.
- **`hosts/`** – Per-device configurations:
  - `desktop/` & `laptop/` each contain:
    - `configuration.nix` – System-wide configuration.
    - `hardware-configuration.nix` – Auto-generated hardware setup.
- **`modules/`** – Modular system configuration:
  - `desktop/` & `laptop/` – Device-specific tweaks.
  - `shared/` – Common modules for both.

### 🔹 Home Manager (`home-manager/`)

- **`desktop/` & `laptop/`** – Device-specific user configurations.
- **`shared/`** – Unified settings for:
  - **Neovim** (`nvim/`): Plugins, LSP, DAP, UI, and more.
  - **Terminal** (`alacritty.nix`, `ghostty.nix`, `zsh.nix`).
  - **Utilities** (`dunst.nix`, `waybar.nix`, `fuzzel.nix`).

---

## Installation

To set up the system:

```bash
nixos-rebuild switch --flake .#<hostname>
```

For Home Manager:

```bash
home-manager switch --flake .#<username>@<hostname>
```

---
