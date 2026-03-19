{ config, pkgs, lib, homeDirectory, ... }:

{
  # Ensure Hyprland/End-4 picks up Home Manager applications
  home.file.".config/hypr/custom/env.conf".text = ''
    env = PATH,${homeDirectory}/.nix-profile/bin:${homeDirectory}/.local/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH
    env = XDG_DATA_DIRS,${homeDirectory}/.local/share:${homeDirectory}/.local/state/home-manager/profiles/1/share:${homeDirectory}/.nix-profile/share:$XDG_DATA_DIRS
    env = TERMINAL,kitty
  '';

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
      
      # Symlink Arch system fonts so Nix apps can discover them
      $DRY_RUN_CMD mkdir -p ${homeDirectory}/.local/share/fonts
      $DRY_RUN_CMD ln -sfn /usr/share/fonts ${homeDirectory}/.local/share/fonts/arch-fonts
    '';
  };
}
