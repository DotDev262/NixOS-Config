{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/login-screen" = {
      enable-fingerprint-authentication = true;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 1080;
      night-light-schedule-to = 360;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 0;
    };
    "org/gnome/desktop/privacy" = {
      purge-trash = true;
      purge-temp = true;
      old-files-age = 30;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "alphabetical-app-grid@stuarthayhurst.shell-extension"
        "pano@alperen.elhan"
      ];
      favorite-apps = [
        "zen.desktop"
        "vivaldi-stable.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/shell/extensions/caffeine" = {
      show-notifications = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "Open Terminal";
    };
  };

  # Portability: Manually link extensions so they work on non-NixOS distros
  home.file = {
    ".local/share/gnome-shell/extensions/caffeine@patapon.info".source = 
      "${pkgs.gnomeExtensions.caffeine}/share/gnome-shell/extensions/caffeine@patapon.info";
    ".local/share/gnome-shell/extensions/alphabetical-app-grid@stuarthayhurst.shell-extension".source = 
      "${pkgs.gnomeExtensions.alphabetical-app-grid}/share/gnome-shell/extensions/alphabetical-app-grid@stuarthayhurst.shell-extension";
    ".local/share/gnome-shell/extensions/pano@alperen.elhan".source = 
      "${pkgs.gnomeExtensions.pano}/share/gnome-shell/extensions/pano@alperen.elhan";
  };

  home.packages = with pkgs; [
    gnomeExtensions.caffeine
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.pano
    libgda5
    gsound
  ];
}
