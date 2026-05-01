{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./packages.nix
  ];

  # modules
  vim.enable = true;
  karabiner.enable = true;
  ghostty.enable = true;
  dops.enable = true;

  system.primaryUser = "ant0n";

  # User configuration - this will set the default shell
  # Required for shell changes to take effect on macOS
  # See: https://github.com/nix-darwin/nix-darwin/issues/1237
  users.knownUsers = [ "ant0n" ];
  users.users."ant0n" = {
    home = "/Users/ant0n";
    uid = 501;
    shell = pkgs.fish;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs secrets; };
  home-manager.users.ant0n = import ./home.nix;
  home-manager.backupFileExtension = "backup";
  home-manager.sharedModules = [
    inputs.mac-app-util.homeManagerModules.default
    inputs.opencode-config.homeManagerModules.default
  ];

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
