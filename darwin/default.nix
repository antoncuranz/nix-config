{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./vim
    ./firefox
    ./karabiner
    ./zsh.nix
    ./system-defaults.nix
  ];

  nixpkgs.overlays = [ 
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.system;
      };
    })
  ];

  programs.zsh.enable = true;  # default shell on catalina
  nixpkgs.config.allowUnfree = true;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  # system.activationScripts.postUserActivation.text = ''
  #   # Following line should allow us to avoid a logout/login cycle
  #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  #   launchctl stop com.apple.Dock.agent
  #   launchctl start com.apple.Dock.agent
  # '';
}
