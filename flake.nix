{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, disko, home-manager, nixvim, arkenfox, ... }@inputs:
  let
    sshKeys = import ./public-keys.nix;
  in {
    nixosConfigurations.serverton = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs sshKeys; };
      modules = [
        ./hosts/serverton
        ./disko/zroot.nix
        ./nixos

        disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
      ];
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/macbook
        ./darwin

        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
        inputs.sops-nix.darwinModules.sops
      ];
    };

    darwinConfigurations.workbook = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/workbook
        ./darwin

        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
      ];
    };
  };
}
