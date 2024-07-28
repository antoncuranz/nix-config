{ config, lib, secrets, ... }:

{
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
}
