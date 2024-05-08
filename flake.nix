{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # until https://github.com/NixOS/nixpkgs/pull/259275
    nixpkgs-caddy.url = "github:jpds/nixpkgs/caddy-external-plugins";

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
      url = "github:LnL7/nix-darwin/master";
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

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, disko, home-manager, nixvim, ... }@inputs:
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

    nixosConfigurations.cloudton = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/cloudton
        ./disko/cloudton.nix
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
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/macbook
        ./modules/zsh.nix

        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
      ];
    };
  };
}
