{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./vim
    ./ghostty
    ./dops
    ./aerospace
    ./karabiner
    ./system-defaults.nix
    ./packages.nix
  ];

  nixpkgs.overlays = [ 
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
      # Not in nixpkgs yet; drop this once it is.
      lighter = final.callPackage ./lighter/package.nix { };
      # My fork of Orca; drop this once its changes are in an Orca release.
      orca = final.callPackage ./orca/package.nix { };
    })
  ];

  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  # system.activationScripts.postUserActivation.text = ''
  #   # Following line should allow us to avoid a logout/login cycle
  #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  #   launchctl stop com.apple.Dock.agent
  #   launchctl start com.apple.Dock.agent
  # '';
}
