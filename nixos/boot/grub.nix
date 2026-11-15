{ config, lib, ... }:

{
  boot = {
    kernelParams = [ "memtest=1" ];
    loader.grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      mirroredBoots = [
        { devices = [ "nodev" ]; path = "/boot"; }
      ];
    };
  };
}
