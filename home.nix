{ config, lib, pkgs, zen-browser, username, homeDirectory, ... }:

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

  targets.genericLinux.enable = true;

  xdg.enable = true;

  home.sessionVariables = {
    ANI_CLI_PLAYER = "mpv";
    ANI_CLI_SKIP_INTRO = "1";
    XDG_DATA_DIRS = lib.mkForce (lib.concatStringsSep ":" [
      "${homeDirectory}/.local/share"
      "${homeDirectory}/.local/state/home-manager/profiles/1/share"
      "${homeDirectory}/.nix-profile/share"
      "/usr/local/share"
      "/usr/share"
    ]);
  };

  programs.home-manager.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];

  # Ensure Hyprland/End-4 picks up Home Manager applications
  home.file.".config/hypr/custom/env.conf".text = ''
    env = PATH,"${homeDirectory}/.nix-profile/bin:${homeDirectory}/.local/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
    env = XDG_DATA_DIRS,"${homeDirectory}/.local/share:${homeDirectory}/.local/state/home-manager/profiles/1/share:${homeDirectory}/.nix-profile/share:$XDG_DATA_DIRS"
  '';

  programs.fish = {
    enable = true;
    shellAliases = {
      hms = "cd /home/aryan/nixos-config && $HOME/.nix-profile/bin/home-manager switch --flake .#aryan -b backup";
      yay = "env -i HOME=$HOME TERM=$TERM /usr/bin/yay $argv";
      paru = "env -i HOME=$HOME TERM=$TERM /usr/bin/paru $argv";
    };
    functions = {
      sudopath = "sudo env \"PATH=$PATH\" $argv";
    };
    interactiveShellInit = ''
      set -g fish_greeting
      if test -f /run/user/(id -u)/agenix/gh-token
        set -gx GH_TOKEN (cat /run/user/(id -u)/agenix/gh-token)
      end
    '';
  };

  programs.bash.shellAliases = {
    hms = "home-manager switch -b backup";
    yay = "env -i HOME=$HOME TERM=$TERM /usr/bin/yay \"$@\"";
    paru = "env -i HOME=$HOME TERM=$TERM /usr/bin/paru \"$@\"";
  };

  fonts.fontconfig.enable = true;
}
