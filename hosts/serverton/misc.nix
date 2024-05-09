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
    flake = "/home/ant0n/nix-config";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
      "--commit-lock-file"
    ];
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  networking.hostName = "serverton";
  networking.hostId = "7bdc28b5";
}
