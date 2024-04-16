{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.hostId = "7bdc28b5";

  networking.useDHCP = lib.mkDefault true;

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

  networking.nameservers = [ "192.168.1.1" ];
  networking.defaultGateway = { address = "192.168.1.1"; interface = "br0"; };
}
