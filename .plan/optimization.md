# Plan: Nix Configuration Optimization & Cleanup

## Objective
Optimize the NixOS and Home Manager configurations by resolving performance service overlaps, eliminating redundant package declarations, and improving portability for non-NixOS environments.

## Background & Context
The user has a hybrid setup:
- **ThinkPad E14 (AMD)**: Running NixOS.
- **Other machines**: Running non-NixOS distros with Home Manager.

## Key Changes

### 1. Performance Tuning (NixOS)
- **Remove `ananicy-cpp`**: Since `scx_rustland` (Sched-ext) is active, `ananicy-cpp` is largely redundant and adds unnecessary background processing.
- **Files**: `configuration.nix`

### 2. GNOME Extension Portability (Home Manager)
- **Move Pano Dependencies**: Move `libgda5`, `gsound`, and `gnomeExtensions.pano` from `configuration.nix` to `modules/gnome.nix`. This ensures the Pano clipboard manager works on both NixOS and non-NixOS GNOME environments.
- **Files**: `configuration.nix`, `modules/gnome.nix`

### 3. Cleanup Redundancies
- **Remove `fprintd` from `environment.systemPackages`**: It's already managed by `services.fprintd` and the custom module.
- **Files**: `configuration.nix`

### 4. GPU Portability (Non-NixOS)
- **Swap `nixGLIntel` for `nixGLDefault`**: The current config uses `nixGLIntel` even though the main system is AMD. Using `nixGLDefault` (or similar) in shell aliases ensures better compatibility across different hardware on non-NixOS distros.
- **Files**: `home.nix`, `modules/shell.nix`, `flake.nix`

### 5. Config Consolidation
- Use `lib.mkIf` or conditional logic where appropriate to keep `home.nix` clean when integrated into NixOS, while retaining settings for standalone use.

## Implementation Steps

### Step 1: Modify `configuration.nix`
- Remove `services.ananicy`.
- Remove `libgda5`, `gsound`, and `gnomeExtensions.pano` from `environment.systemPackages`.
- Remove `fprintd` from `environment.systemPackages`.

### Step 2: Modify `modules/gnome.nix`
- Ensure `libgda5` and `gsound` are in `home.packages`.
- Ensure `gnomeExtensions.pano` is in `home.packages` (it already is).

### Step 3: Modify `flake.nix` & `home.nix` for nixGL
- Update `nixGLIntel` to a more generic or multi-GPU variant if possible, or adjust aliases in `modules/shell.nix`.

## Verification
- Run `nix flake check` to ensure syntax is correct.
- Test `home-manager switch` on the local machine.
- Verify `scx_rustland` is still running via `systemctl status scx`.
- Verify Pano still works in GNOME.
