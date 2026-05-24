{ config, pkgs, lib, username, homeDirectory, ... }:

{
  targets.genericLinux.enable = true;

  home.sessionVariables = {
    ANI_CLI_PLAYER = "mpv";
    ANI_CLI_SKIP_INTRO = "1";
    NIXOS_OZONE_WL = "1";
    XDG_DATA_DIRS = lib.mkForce (lib.concatStringsSep ":" [
      "${homeDirectory}/.local/share"
      "${homeDirectory}/.local/state/home-manager/profiles/1/share"
      "/usr/local/share"
      "/usr/share"
    ]);
  };

  home.sessionPath = [ "${homeDirectory}/.local/bin" "${homeDirectory}/.opencode/bin" ];

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3 --keep-since 7d";
    flake = "${homeDirectory}/nixos-config";
  };
}
