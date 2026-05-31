{ config, lib, pkgs, system, nixGL, username, homeDirectory, ... }:

{
  imports = [
    ./modules/core.nix
    # ./modules/default-apps.nix
    ./modules/activation.nix
    ./modules/shell.nix
    # ./modules/productivity.nix
    # ./modules/gnome.nix
    # ./modules/browsers.nix
    ./modules/dev.nix
    ./modules/services.nix
    ./modules/theming.nix
    ./modules/packages.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";

  home.packages = [
    nixGL.packages.${system}.nixGLIntel
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.extraAllowUnfreePackages = [ "ventoy-full" ];
  nixpkgs.config.permittedInsecurePackages = [ "ventoy-1.1.12" "ventoy-gtk3-1.1.12" ];
  nixpkgs.config.vivaldi = {
    proprietaryCodecs = true;
    enableWideVine = true;
  };

  # Ensure services are started/restarted on activation
  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;
}
