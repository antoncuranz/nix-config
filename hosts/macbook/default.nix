{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
  ];

  # modules
  vim.enable = true;
  karabiner.enable = true;
  aerospace.enable = true;
  ghostty.enable = true;
  dops.enable = true;

  system.primaryUser = "ant0n";
  sops.defaultSopsFile = ../../secrets/secrets.enc.json;
  sops.defaultSopsFormat = "json";
  sops.age.keyFile = "/Users/ant0n/.config/sops/age/keys.txt";
  sops.secrets.opAccount.owner = "ant0n";

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
  home-manager.extraSpecialArgs = { inherit inputs; opAccountPath = config.sops.secrets.opAccount.path; };
  home-manager.users.ant0n = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
