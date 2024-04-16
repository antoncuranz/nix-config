{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=2a4bcf18e656cceedd40a01c38fccaf8aff75239"; # https://github.com/NixOS/nixpkgs/issues/304511
    # nixpkgs.url = "github:nixos/nixpkgs/release-23.11";

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:wegank/nix-darwin/mddoc-remove"; # TODO
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, nix-darwin, ... }@inputs:
  let
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/serverton
        ./modules
        # inputs.home-manager.nixosModules.default
      ];
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      # specialArgs = { }
      modules = [
        ./hosts/macbook
        # inputs.home-manager.nixosModules.default
      ];
    };
  };
}
