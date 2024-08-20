{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
  ];

  # modules
  vim.enable = true;
  karabiner = {
    enable = true;
    user = "anton.curanz";
  };

  # playground
  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
    inputs.nur.overlay
  ];

  users.users."anton.curanz".home = "/Users/anton.curanz";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."anton.curanz" = import ./home.nix;

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
