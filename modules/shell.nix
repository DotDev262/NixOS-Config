{ config, pkgs, lib, username, homeDirectory, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      hm = "cd /home/aryan/nixos-config && $HOME/.nix-profile/bin/home-manager switch --flake .#aryan -b backup";
    hms = "cd /home/aryan/nixos-config && nh home switch --backup-extension backup";
      hmn = "home-manager news --flake /home/aryan/nixos-config#aryan";
      zen = "nixGLIntel zen";
      vivaldi = "nixGLIntel vivaldi";
    };
    functions = {
      sudopath = "sudo env \"PATH=$PATH\" $argv";
      arch-shell = "/usr/bin/env -i HOME=\"$HOME\" TERM=\"$TERM\" PATH=\"/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin\" /usr/bin/bash --norc --noprofile -c 'unset NIX_PROFILES NIX_PATH NIX_SSL_CERT_FILE __ETC_PROFILE_NIX_SOURCED LG_CONFIG_FILE GLAMOUR_STYLE XCURSOR_PATH LOCALE_ARCHIVE_2_27 NH_FLAKE NIXOS_OZONE_WL DBUS_SESSION_BUS_ADDRESS XDG_DATA_DIRS TERMINFO_DIRS GPG_TTY; exec /usr/bin/fish --no-config'";
    };
    interactiveShellInit = ''
      set -g fish_greeting
      if test -f /run/user/(id -u)/agenix/gh-token
        set -gx GH_TOKEN (cat /run/user/(id -u)/agenix/gh-token)
      end
    '';
  };

  programs.bash.shellAliases = {
    hm = "cd /home/aryan/nixos-config && home-manager switch --flake .#aryan -b backup";
    hms = "cd /home/aryan/nixos-config && nh home switch --backup-extension backup";
    hmn = "home-manager news --flake /home/aryan/nixos-config#aryan";
    zen = "nixGLIntel zen";
    vivaldi = "nixGLIntel vivaldi";
    arch-shell = "env -i HOME=\"$HOME\" TERM=\"$TERM\" PATH=\"/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin\" /usr/bin/bash --norc --noprofile";
  };
}
