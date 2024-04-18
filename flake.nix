{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=2a4bcf18e656cceedd40a01c38fccaf8aff75239"; # https://github.com/NixOS/nixpkgs/issues/304511
    # nixpkgs.url = "github:nixos/nixpkgs/release-23.11";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/nur";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:wegank/nix-darwin/mddoc-remove"; # TODO
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, disko, impermanence, home-manager, ... }@inputs:
  let
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/serverton
        ./disko/zroot.nix
        ./modules

        disko.nixosModules.disko
      ];
    };

    nixosConfigurations.testvm = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/testvm
        ./disko/zroot.nix
        ./modules

        disko.nixosModules.disko
      ];
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/macbook
        ./modules/zsh.nix

        home-manager.darwinModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.nixpkgs-firefox-darwin.overlay
            inputs.nur.overlay
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ant0n = import ./hosts/macbook/home.nix;
        }
      ];
    };
  };
}
