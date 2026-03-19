{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core Utilities
    gemini-cli-bin
    asciinema
    zip
    p7zip
    wl-clipboard
    nerd-fonts.jetbrains-mono
    overpass
    rubik
    ente-auth
    jq
    yq
    tree
    ncdu
    netcat-gnu
    httpie

    # Academic & Productivity
    zotero
    onlyoffice-desktopeditors
    papers
    pandoc
    marksman
    glow

    # Media & Entertainment
    mpv
    playerctl
    yt-dlp
    ani-cli
    ani-skip
    gapless

    # System Monitoring & Management
    fastfetch
    btop
    bottom
    fzf
    distrobox
    yaak
    libnotify
    nvd
    util-linux
  ];
}
