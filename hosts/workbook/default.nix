{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
  ];

  # modules
  vim.enable = true;

  # playground
  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
    inputs.nur.overlay
  ];

  users.users."anton.curanz".home = "/Users/anton.curanz";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ant0n = import ./home.nix;

  # system.activationScripts.postUserActivation.text = ''
  #   # Following line should allow us to avoid a logout/login cycle
  #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  #   launchctl stop com.apple.Dock.agent
  #   launchctl start com.apple.Dock.agent
  # '';

  system.defaults = {
    dock = {
      orientation = "left";
      show-recents = false;
      tilesize = 42;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  nixpkgs.config.allowUnfree = true;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
