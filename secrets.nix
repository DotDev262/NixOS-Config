{ config, lib, pkgs, username, agenix, ... }:

{
  home.packages = [ agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

  age.secrets = {
    gpg-key.file = ./secrets/gpg-key.age;
    gh-token.file = ./secrets/gh-token.age;
  };

  home.sessionVariables = {
    GH_TOKEN_FILE = "${config.home.homeDirectory}/.config/gh-token";
  };
}
