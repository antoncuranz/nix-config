{ config, lib, pkgs, ... }:

{
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
