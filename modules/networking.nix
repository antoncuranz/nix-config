{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.hostId = "7bdc28b5";

  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.br0.useDHCP = false;
  networking.bridges = {
    "br0" = {
      interfaces = [ "eno1" ];
    };
  };
  networking.interfaces.br0.ipv4.addresses = [{
      address = "192.168.1.4";
      prefixLength = 24;
  }];
}
