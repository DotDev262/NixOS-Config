{ config, lib, pkgs, system, nixGL, username, homeDirectory, ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/activation.nix
    ./modules/shell.nix
    ./modules/productivity.nix
    # ./modules/gnome.nix
    ./modules/browsers.nix
    ./modules/dev.nix
    ./modules/services.nix
    ./modules/theming.nix
    ./modules/packages.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  home.packages = [
    nixGL.packages.${system}.nixGLIntel
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.vivaldi = {
    proprietaryCodecs = true;
    enableWideVine = true;
  };

  # Ensure services are started/restarted on activation
  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;
}
