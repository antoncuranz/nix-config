{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
  ];

  # modules
  vim.enable = true;
  ghostty.enable = true;
  dops.enable = true;
  karabiner.enable = true;

  # playground
  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
    inputs.nur.overlays.default
  ];

  system.primaryUser = "anton.curanz";
  users.users."anton.curanz".home = "/Users/anton.curanz";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."anton.curanz" = import ./home.nix;
  home-manager.sharedModules = [
    inputs.mac-app-util.homeManagerModules.default
  ];

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
