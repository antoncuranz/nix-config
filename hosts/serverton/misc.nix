{ inputs, config, lib, pkgs, ... }:

{
  boot.zfs.extraPools = [ "nvme" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
      "--commit-lock-file"
    ];
    dates = "06:00";
    randomizedDelaySec = "45min";
  };

  networking.hostName = "serverton";
  networking.hostId = "7bdc28b5";

  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/home/ant0n/nix-config#default'";
  };

}
