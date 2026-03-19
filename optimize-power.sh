#!/usr/bin/env bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo bash optimize-power.sh)"
  exit 1
fi

echo "--- 1. Switching from PPD to TLP (Avoid Conflicts) ---"
systemctl stop power-profiles-daemon 2>/dev/null
systemctl mask power-profiles-daemon 2>/dev/null
pacman -S --needed --noconfirm tlp tlp-rdw powertop brightnessctl
systemctl enable --now tlp

echo "--- 2. Configuring TLP for AMD Zen 4 (ThinkPad E14 Gen 5) ---"
# Back up existing config if it hasn't been backed up yet
[ ! -f /etc/tlp.conf.bak ] && cp /etc/tlp.conf /etc/tlp.conf.bak

# Write aggressive AMD P-State and Power settings
cat <<EOF > /etc/tlp.conf
# TLP Optimization for ThinkPad E14 Gen 5 AMD
TLP_ENABLE=1

# CPU Scaling (amd_pstate_epp)
AMD_ENERGY_PERF_PREF_ON_AC=balance_performance
AMD_ENERGY_PERF_PREF_ON_BAT=power
# Fallback key for some TLP versions
CPU_ENERGY_PERF_POLICY_ON_BAT=power
CPU_HWP_DYN_POWER_MANAGEMENT_ON_BAT=power

# Disable Boost on Battery
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0

# Allow CPU to downclock to absolute minimum
CPU_SCALING_MIN_FREQ_ON_BAT=410959

# Platform Profile (ThinkPad Specific)
PLATFORM_PROFILE_ON_AC=performance
PLATFORM_PROFILE_ON_BAT=low-power

# Battery Charge Thresholds (Save Battery Health)
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80

# Connectivity & Audio Power Savings
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=off
BLUETOOTH_PWR_ON_BAT=off
SOUND_QUERY_CHIPS=1
USB_AUTOSUSPEND=1
USB_AUTOSUSPEND_ALLOW_TYPES="usb:uhci,usb:ohci"

# Disk Power Savings
DISK_DEVICES="nvme0n1"
DISK_APM_LEVEL_ON_AC="254 254"
DISK_APM_LEVEL_ON_BAT="128 128"
EOF

echo "--- 3. Creating and Enabling Powertop Auto-Tune Service ---"
if [ ! -f /etc/systemd/system/powertop.service ]; then
cat <<EOF > /etc/systemd/system/powertop.service
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
fi
systemctl enable --now powertop.service

echo "--- 3b. Enabling TLP Compatibility Service (tlp-pd) ---"
systemctl enable --now tlp-pd.service

echo "--- 4. Applying Kernel Parameter (Lazy RCU) ---"
if [ -f /etc/default/grub ]; then
    if ! grep -q "pcie_aspm=" /etc/default/grub; then
        sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="pcie_aspm=default snd_hda_intel.power_save=1 amdgpu.acpi_cst=1 amdgpu.dcfeaturemask=0x8fffefff rcutree.enable_rcu_lazy=1 /' /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg
        echo "Added power-saving kernel params to GRUB. Reboot to apply."
    fi
fi

echo "--- 5. Configuring AMD GPU Power Saving ---"
if [ ! -f /etc/systemd/system/amdgpu-power.service ]; then
cat <<EOF > /etc/systemd/system/amdgpu-power.service
[Unit]
Description=AMD GPU Power Saving
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo "auto" > /sys/class/drm/card0/device/power_dpm_force_performance_level 2>/dev/null || true'

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now amdgpu-power.service
fi

if [ ! -f /etc/systemd/system/pci-power-save.service ]; then
cat <<'EOF' > /etc/systemd/system/pci-power-save.service
[Unit]
Description=Enable PCI Runtime PM
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'for dev in /sys/bus/pci/devices/*/power/control; do echo auto > "$dev" 2>/dev/null; done'

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now pci-power-save.service
fi

echo "--- 6. Enabling PCI Runtime PM for All Devices ---"
for dev in /sys/bus/pci/devices/*/power/control; do
    echo auto > "$dev" 2>/dev/null || true
done

echo "--- 7. Enabling NVMe Power Savings ---"
echo "auto" > /sys/class/nvme/nvme*/power/control 2>/dev/null || true
echo "0" > /sys/module/nvme/parameters/autosuspend 2>/dev/null || true

echo "--- 8. Enabling Sound Card Power Savings ---"
for card in /sys/class/sound/card*/power/control; do
    echo auto > "$card" 2>/dev/null || true
done

echo "--- 9. Fixing WiFi Power Saving (RTL8852BE) ---"
WIFI_DEV=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^wlan' | head -1)
if [ -n "$WIFI_DEV" ]; then
    echo "enabled" > /proc/acpi/wakeup 2>/dev/null || true
    iw dev "$WIFI_DEV" set power_save on 2>/dev/null || true
fi

echo "--- 10. Finalizing ---"
systemctl enable --now tlp.service

echo "DONE! Your ThinkPad E14 is now configured for Maximum Power Saving on battery."
echo "TIP: Use 'tlp-stat -s' to verify TLP status and 'powertop' to see power consumers."
