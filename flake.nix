{
  description = "A basic NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, catppuccin, nix-vscode-extensions, agenix, nixGL, ... }: 
  let
    system = "x86_64-linux";
    username = "aryan";
    homeDirectory = "/home/aryan";
    pkgs = import nixpkgs {
      localSystem = system;
      config = {
        allowUnfree = true;
        vivaldi = { proprietaryCodecs = true; enableWideVine = true; };
      };
      overlays = [ nix-vscode-extensions.overlays.default ];
    };
  in {
    nixosConfigurations = {
      thinkpad-E14 = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = {
          inherit self;
          inherit username homeDirectory;
        };
        modules = [
          ./configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit self;
          inherit system;
          inherit zen-browser;
          inherit nixGL;
          inherit username homeDirectory;
          inherit agenix;
        };
        modules = [ 
          ./home.nix 
          catppuccin.homeModules.catppuccin
          agenix.homeManagerModules.default
          ./secrets.nix
        ];
      };
    };

    templates.microvm = {
      path = ./templates/microvm;
      description = "A lightweight NixOS MicroVM template";
    };
  };
}
