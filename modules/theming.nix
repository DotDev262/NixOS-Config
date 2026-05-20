{ config, lib, pkgs, catppuccin, ... }:

let
  fixedPnpmDeps = pkgs.fetchPnpmDeps {
    pname = "catppuccin-vscode";
    version = "3.19.0";
    src = catppuccin.packages.x86_64-linux.vscode.src;
    pnpmWorkspaces = [ "catppuccin-vsc" ];
    fetcherVersion = 3;
    pnpm = pkgs.pnpm_10;
    hash = "sha256-DE0mHkBlV0RkrEmtIXnzKaiXOK8vgcCx3z7b49zzBhc=";
  };
in
{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    helix.enable = true;
    vscode.profiles = {
      default.enable = true;
      python.enable = true;
      java.enable = true;
      c-lex.enable = true;
      typst.enable = true;
    };
  };

  catppuccin.sources = lib.mkForce (
    catppuccin.packages.x86_64-linux
    // {
      vscode = catppuccin.packages.x86_64-linux.vscode.overrideAttrs (old: {
        pnpmDeps = fixedPnpmDeps;
      });
    }
  );
}
