{ config, lib, pkgs, system, zen-browser, nixGLIntel, username, homeDirectory, ... }:

{
  imports = [
    ./modules/gnome.nix
    ./modules/browsers.nix
    ./modules/dev.nix
    ./modules/services.nix
    ./modules/theming.nix
    ./modules/packages.nix
  ];

  home.packages = [
    nixGLIntel.packages.${system}.nixGLIntel
  ];

  nixpkgs.config = {
    allowUnfree = true;
    vivaldi = {
      proprietaryCodecs = true;
      enableWideVine = true;
    };
  };

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  targets.genericLinux.enable = true;

  xdg.enable = true;

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

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3 --keep-since 7d";
    flake = "${homeDirectory}/nixos-config";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  # Ensure Hyprland/End-4 picks up Home Manager applications
  home.file.".config/hypr/custom/env.conf".text = ''
    env = PATH,${homeDirectory}/.nix-profile/bin:${homeDirectory}/.local/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH
    env = XDG_DATA_DIRS,${homeDirectory}/.local/share:${homeDirectory}/.local/state/home-manager/profiles/1/share:${homeDirectory}/.nix-profile/share:$XDG_DATA_DIRS
    env = TERMINAL,kitty
  '';

  programs.fish = {
    enable = true;
    shellAliases = {
      hms = "cd /home/aryan/nixos-config && $HOME/.nix-profile/bin/home-manager switch --flake .#aryan -b backup";
      zen = "nixGLIntel zen";
      vivaldi = "nixGLIntel vivaldi";
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
    zen = "nixGLIntel zen";
    vivaldi = "nixGLIntel vivaldi";
  };

  fonts.fontconfig.enable = true;

  # Symlink desktop files and Vivaldi codecs to ~/.local/share/
  home.activation = {
    linkDesktopFilesAndCodecs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p ${homeDirectory}/.local/share/applications
      $DRY_RUN_CMD mkdir -p ${homeDirectory}/.local/lib/vivaldi/media-codecs-120726
      
      # For each nix desktop file, create a wrapped version in ~/.local/share/applications
      for f in ${homeDirectory}/.nix-profile/share/applications/*.desktop; do
        if [ -f "$f" ]; then
          base=$(basename "$f")
          if [ -z "$DRY_RUN_CMD" ]; then
            # Normal run: wrap with nixGLIntel
            # Remove existing file/symlink first to avoid "Permission denied" on read-only symlinks
            rm -f ${homeDirectory}/.local/share/applications/"$base"
            sed "s|^Exec=|Exec=nixGLIntel |g" "$f" > ${homeDirectory}/.local/share/applications/"$base"
            # Wrap all other Exec lines (like in Desktop Actions)
            sed -i "s|^Exec=\([^n]\)|Exec=nixGLIntel \1|g" ${homeDirectory}/.local/share/applications/"$base"
            chmod +w ${homeDirectory}/.local/share/applications/"$base"
          else
            # Dry run
            echo "Dry run: would wrap $base with nixGLIntel"
          fi
        fi
      done
      
      $DRY_RUN_CMD ln -sf ${homeDirectory}/.nix-profile/lib/libffmpeg.so ${homeDirectory}/.local/lib/vivaldi/media-codecs-120726/libffmpeg.so
    '';
  };
}
