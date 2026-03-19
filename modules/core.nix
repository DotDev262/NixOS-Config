{ config, pkgs, lib, username, homeDirectory, ... }:

{
  targets.genericLinux.enable = true;

  xdg.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "application/pdf" = "org.gnome.Papers.desktop";
    };
  };

  home.sessionVariables = {
    ANI_CLI_PLAYER = "mpv";
    ANI_CLI_SKIP_INTRO = "1";
    NIXOS_OZONE_WL = "1";
    XDG_DATA_DIRS = lib.mkForce (lib.concatStringsSep ":" [
      "${homeDirectory}/.local/share"
      "${homeDirectory}/.local/state/home-manager/profiles/1/share"
      "${homeDirectory}/.nix-profile/share"
      "/usr/local/share"
      "/usr/share"
    ]);
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3 --keep-since 7d";
    flake = "${homeDirectory}/nixos-config";
  };
}
