{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    libfprint-10a5 = {
      url = "github:furcom/libfprint-10a5-9800";
      flake = false;
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nix-vscode-extensions, libfprint-10a5, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true; 
      overlays = [ nix-vscode-extensions.overlays.default ];
    };

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      specialArgs = {
        inherit pkgs-unstable inputs;
      };

      modules = [
        ./configuration.nix
        nix-flatpak.nixosModules.nix-flatpak
        "${libfprint-10a5}/fprintd.nix"

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
    inherit inputs pkgs-unstable;
  };

home-manager.users.aryan = {
  imports = [ ./home.nix ];
};


          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    formatter.${system} = pkgs.nixpkgs-fmt;
  };
}

