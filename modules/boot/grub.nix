{ config, lib, secrets, ... }:

{
  # TODO: move this
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  boot = {
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
