{ config, pkgs, zen-browser, username, homeDirectory, ... }:

{
  imports = [
    ./modules/gnome.nix
    ./modules/browsers.nix
    ./modules/dev.nix
    ./modules/services.nix
    ./modules/theming.nix
    ./modules/packages.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  home.sessionVariables = {
    ANI_CLI_PLAYER = "mpv";
    ANI_CLI_SKIP_INTRO = "1";
  };

  programs.home-manager.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/aryan/.config/sops/age/keys.txt";
    secrets.gpg_key = { 
      path = "/home/aryan/.config/git/signing_key";
    };
  };

  fonts.fontconfig.enable = true;
}
