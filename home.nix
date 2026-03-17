{ config, pkgs, zen-browser, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "aryan";
  home.homeDirectory = "/home/aryan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You can update home.stateVersion dynamically by running the appropriate Home
  # Manager command.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The programs you want to install and manage with Home Manager.
  programs.home-manager.enable = true;

  # Enable nil (Nix LSP)
  home.packages = 
  (with pkgs; [
    # Packages
    nil
    git
    htop
    btop
    zip
    wl-clipboard
    helix
    nerd-fonts.jetbrains-mono
    gnomeExtensions.caffeine
    gnomeExtensions.alphabetical-app-grid
  ]) ++
  (with zen-browser.packages.x86_64-linux; [
    zen-browser
  ]);

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "alphabetical-app-grid@stuarthayhurst.shell-extension"
      ];
      favorite-apps = [
        "vivaldi-stable.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
      ];
    };
    "org/gnome/shell/extensions/caffeine" = {
      show-notifications = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.max" = 512000;
        "browser.sessionstore.interval" = 300000;
        "browser.sessionstore.max_tabs_undo" = 0;
        "toolkit.storage.database.eagerVacuum" = false;
      };
    };
  };

  programs.vivaldi = {
    enable = true;
    commandLineArgs = [
      "--disk-cache-size=0"
      "--disk-cache-size=0"
      "--media-cache-size=1048576"
    ];
  };

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/aryan/nixos-config#nixos";
    hm = "home-manager switch --flake /home/aryan/nixos-config#aryan";
  };

  # Other programs and settings can go here.
  # For example, to enable a simple bashrc:
  # programs.bash.enable = true;
  # programs.bash.initExtra = "echo 'Hello from Home Manager!'";
}
