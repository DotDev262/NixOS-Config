{ config, lib, pkgs, catppuccin, ... }:

{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    helix.enable = true;
    vscode.profiles.default.enable = false;
  };
}
