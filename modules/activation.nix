{
  config,
  pkgs,
  lib,
  homeDirectory,
  ...
}: {
  # Ensure Hyprland/End-4 picks up Home Manager applications
  home.file.".config/hypr/custom/env.conf".text = ''
    env = PATH,${homeDirectory}/.nix-profile/bin:${homeDirectory}/.local/bin:${homeDirectory}/.opencode/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH
    env = XDG_DATA_DIRS,${homeDirectory}/.nix-profile/share:/usr/local/share:/usr/share
    env = TERMINAL,kitty
  '';

  # Link Vivaldi codecs and fonts
  home.activation = {
    linkDesktopFilesAndCodecs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ${homeDirectory}/.local/lib/vivaldi/media-codecs-120726
      $DRY_RUN_CMD mkdir -p ${homeDirectory}/.local/share/fonts

      $DRY_RUN_CMD ln -sf ${homeDirectory}/.nix-profile/lib/libffmpeg.so ${homeDirectory}/.local/lib/vivaldi/media-codecs-120726/libffmpeg.so
      $DRY_RUN_CMD ln -sfn /usr/share/fonts ${homeDirectory}/.local/share/fonts/arch-fonts
    '';

    setupGhToken = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -f "/run/user/$(id -u)/agenix/gh-token" ]; then
        unset GH_TOKEN
        $DRY_RUN_CMD ${pkgs.gh}/bin/gh auth login --with-token < "/run/user/$(id -u)/agenix/gh-token"
        $DRY_RUN_CMD ${pkgs.gh}/bin/gh config set git_protocol ssh
      fi
    '';
  };
}
