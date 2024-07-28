{ config, lib, pkgs, ... }:

{
  imports = [
    ./vim
    ./karabiner
    ./zsh.nix
    ./dock.nix
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
