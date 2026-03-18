{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gemini-cli-bin
    zip
    wl-clipboard
    nerd-fonts.jetbrains-mono
    ente-auth
    zotero
    obsidian
    fastfetch
    gapless
    mpv
    ani-cli
    ani-skip
    fzf
    marksman
    yaak
    yt-dlp
    onlyoffice-desktopeditors
    glow
    jq
    netcat-gnu
    p7zip
    httpie
    bottom
    yq
    tree
    ncdu
    playerctl
  ];
}
