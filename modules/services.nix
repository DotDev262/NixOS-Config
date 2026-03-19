{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    settings = {
      gui = { address = "127.0.0.1:8384"; };
    };
  };

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-7 days";
  };

  systemd.user.services.nix-update-check = {
    Unit = {
      Description = "Check for Nix flake updates";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = let
        script = pkgs.writeShellScript "nix-update-check" ''
          CONFIG_DIR="/home/aryan/nixos-config"
          TMP_LOCK="/tmp/flake.lock.check"
          
          # Check for network connectivity first
          if ! ${pkgs.iputils}/bin/ping -c 1 8.8.8.8 > /dev/null 2>&1; then
            exit 0
          fi

          cd "$CONFIG_DIR" || exit 1
          cp flake.lock "$TMP_LOCK"

          # Attempt to update the temporary lock file
          if ${pkgs.nix}/bin/nix flake update --lock-file "$TMP_LOCK" --quiet; then
            # Compare the original flake.lock with the updated one
            if ! diff flake.lock "$TMP_LOCK" > /dev/null; then
              ${pkgs.libnotify}/bin/notify-send "Nix Updates Available" \
                "New updates found for your system configuration. Run 'nix flake update' to apply them." \
                -i software-update-available
            fi
          fi

          rm "$TMP_LOCK"
        '';
      in "${script}";
    };
  };

  systemd.user.timers.nix-update-check = {
    Unit = {
      Description = "Check for Nix flake updates every 12 hours";
    };
    Timer = {
      OnBootSec = "10m";
      OnUnitActiveSec = "12h";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services.disable-bluetooth-on-boot = {
    Unit = {
      Description = "Disable Bluetooth on login";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill block bluetooth";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
