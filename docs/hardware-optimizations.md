# Hardware Optimizations for ThinkPad E14

Your NixOS configuration includes specialized optimizations for your Lenovo ThinkPad E14 (AMD Gen 5), improving performance, stability, and power management.

## **AMD Optimizations**
- **`hardware.cpu.amd.updateMicrocode`**: Ensures your AMD CPU receives the latest microcode updates for stability and performance.
- **Power Management**: 
    - **TLP**: Custom settings for aggressive power-saving on battery, including:
        - Disabled CPU boost on battery.
        - `low-power` platform profile on battery.
        - PCIe ASPM set to `powersave`.
        - `auto` runtime power management.
        - WiFi and Bluetooth power saving enabled.
    - **Powertop**: Automatic tuning enabled for low-level optimizations.
    - **Thermald**: Configured for cooling management.
    - **Microphone LED**: Specialized `udev` fix for the ThinkPad microphone LED.

---

## **SSD Optimization**
- **`services.fstrim.enable`**: Enables automatic SSD trimming to maintain performance and extend the life of your drive.

## **Pipewire for Audio**
- **Pipewire**: Configured as the modern audio backend with ALSA and PulseAudio compatibility, providing high-fidelity and low-latency sound.

---

## **Docker Infrastructure**
- **Docker**: Configured for rootless execution, providing a secure and isolated environment for containerized applications.

## **Boot & Bootloader**
- **GRUB (EFI)**: Configured as the EFI bootloader with OS prober enabled for easy multi-boot management.

---

## **Key Design Principles**
- **Safe Tweaks**: Only universally good and tested optimizations are applied, avoiding any risky hardware-specific workarounds.
- **Declarative**: All hardware settings are explicitly defined in `configuration.nix` and `hardware-configuration.nix`.
- **NixOS-Standardized**: Optimizations follow established NixOS patterns for better compatibility and maintenance.
