{ config, lib, pkgs, ... }:

{
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  services.avahi.allowInterfaces = [ "eno1" ];
}
