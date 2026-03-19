{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core Utilities
    gemini-cli-bin
    zip
    p7zip
    wl-clipboard
    nerd-fonts.jetbrains-mono
    ente-auth
    jq
    yq
    tree
    ncdu
    netcat-gnu
    httpie

    # Academic & Productivity
    zotero
    obsidian
    onlyoffice-desktopeditors
    gnome.papers
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
  ];
}
