{ config, lib, pkgs, ... }:

{
  #nixpkgs.config.packageOverrides = pkgs: {
  #  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #    inherit pkgs;
  #  };
  #};

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lshw
    git
    powertop
    cockpit
    lm_sensors
    htop
    k9s
    kubernetes-helm
    unzip
    gnumake
    tree
  ];
}
