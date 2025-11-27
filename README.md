# NixOS Configuration

This repository contains my personal NixOS configuration.

## Structure

- `flake.nix`: Defines the Nix flake for this configuration.
- `flake.lock`: Locks the versions of the flake inputs.
- `configuration.nix`: The main NixOS system configuration.
- `home.nix`: Home Manager configuration for user-specific settings.
- `hardware-configuration.nix`: Automatically generated hardware-specific configuration.

## Usage

To use this configuration, you'll need NixOS with flakes enabled.

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/nixos-config.git
   cd nixos-config
   ```

2. Rebuild your system:
   ```bash
   sudo nixos-rebuild switch --flake .#your-hostname
   ```
   (Replace `your-hostname` with the actual hostname defined in your `flake.nix`.)

3. Apply Home Manager configuration:
   ```bash
   home-manager switch --flake .#your-username@your-hostname
   ```
   (Replace `your-username` and `your-hostname` accordingly.)
