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

  system.primaryUser = "anton.curanz";

  # User configuration - this will set the default shell
  # Required for shell changes to take effect on macOS
  # See: https://github.com/nix-darwin/nix-darwin/issues/1237
  users.knownUsers = [ "anton.curanz" ];
  users.users."anton.curanz" = {
    home = "/Users/anton.curanz";
    uid = 501;
    shell = pkgs.fish;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."anton.curanz" = import ./home.nix;
  home-manager.sharedModules = [
    inputs.mac-app-util.homeManagerModules.default
    inputs.opencode-config.homeManagerModules.default
  ];

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
