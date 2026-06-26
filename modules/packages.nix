{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core Utilities
    asciinema
    zip
    p7zip
    wl-clipboard
    nerd-fonts.jetbrains-mono
    overpass
    rubik
    # ente-auth
    jq
    yq
    tree
    ncdu
    netcat-gnu
    httpie
    # ventoy-full
    ventoy

    # Academic & Productivity
    #zotero
    #onlyoffice-desktopeditors
    #papers
    pandoc
    marksman
    glow
    # ltex-ls-plus

    # Media & Entertainment
    #mpv
    playerctl
    # yt-dlp
#    ani-cli
#    ani-skip
    #gapless

    # System Monitoring & Management
    # (fastfetch.override { enlightenmentSupport = false; })
    rtk
#    btop
    #distrobox
    #yaak
#    libnotify
    nvd
  ];
}
