{ config, lib, pkgs, catppuccin, ... }:

{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    helix.enable = true;
    vscode.profiles = {
      default = {
        enable = true;
        icons.enable = true;
      };
      python.enable = true;
      java.enable = true;
      c-lex.enable = true;
      typst.enable = true;
      typescript.enable = true;
    };
  };
}
