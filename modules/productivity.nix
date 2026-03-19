{ config, pkgs, ... }:

{
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      appearance = {
        theme = "obsidian"; # Dark mode
        cssTheme = "Anuppuccin";
        interfaceFontFamily = "Overpass";
        textFontFamily = "Rubik";
        monospaceFontFamily = "JetBrainsMono Nerd Font";
        baseFontSize = 16;
      };
      app = {
        readableLineLength = true;
        showLineNumber = true;
        spellcheck = true;
        tabSize = 4;
        useTab = false;
        alwaysUpdateLinks = true;
      };
    };
  };
}
