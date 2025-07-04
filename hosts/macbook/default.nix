{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
  ];

  # modules
  vim.enable = true;
  karabiner.enable = true;
  firefox.enable = true;

  # playground
  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
    inputs.nur.overlays.default
  ];

  system.primaryUser = "ant0n";
  users.users.ant0n.home = "/Users/ant0n";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ant0n = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
