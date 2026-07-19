{ lib, ... }:

let
  network = {
    address = "192.168.1.2";
    prefixLength = 24;
    gateway = "192.168.1.1";
    nameserver = "192.168.1.1";
    interface = "eno1";
  };
in
{
  boot.remote-unlock.staticIPv4 = network;

  networking.useDHCP = lib.mkForce false;
  networking.dhcpcd.enable = false;
  networking.interfaces.${network.interface} = {
    useDHCP = lib.mkForce false;
    ipv4.addresses = [{
      inherit (network) address prefixLength;
    }];
  };
  networking.defaultGateway = network.gateway;
  networking.nameservers = [ network.nameserver ];
}
