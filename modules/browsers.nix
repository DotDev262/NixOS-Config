{ config, pkgs, zen-browser, system, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.max" = 512000;
        "browser.sessionstore.interval" = 300000;
        "browser.sessionstore.max_tabs_undo" = 0;
        "toolkit.storage.database.eagerVacuum" = false;
      };
      extensions = {
        force = true;
      };
    };
  };

  programs.vivaldi = {
    enable = true;
    commandLineArgs = [
      "--disk-cache-size=0"
      "--media-cache-size=1048576"
    ];
  };

  home.packages = [
    zen-browser.packages.${system}.default
    pkgs.vivaldi-ffmpeg-codecs
  ];
}
