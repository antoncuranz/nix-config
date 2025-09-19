{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:antoncuranz/nixpkgs/release-25.05";

    impermanence.url = "github:nix-community/impermanence";
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    nur.url = "github:nix-community/nur";
    mac-app-util.url = "github:hraban/mac-app-util";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, disko, home-manager, nixvim, arkenfox, mac-app-util, ... }@inputs:
  let
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
  in {
    nixosConfigurations.serverton = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/serverton
        ./disko/zroot.nix
        ./nixos

        disko.nixosModules.disko
      ];
    };

    nixosConfigurations.cloudton = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/cloudton
        ./disko/cloudton.nix
        ./nixos

        disko.nixosModules.disko
      ];
    };

    nixosConfigurations.testvm = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/testvm
        ./disko/zroot.nix
        ./nixos

        disko.nixosModules.disko
      ];
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/macbook
        ./darwin

        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
        mac-app-util.darwinModules.default
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
