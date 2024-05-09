{ inputs, config, lib, pkgs, ... }:

{
  boot.zfs.extraPools = [ "nvme" ];

  networking.hostName = "serverton";
  networking.hostId = "7bdc28b5";
}
