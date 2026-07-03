{ lib, ... }:

let
  network = {
    address = "192.168.1.2";
    prefixLength = 24;
    gateway = "192.168.1.1";
    nameserver = "192.168.1.1";
    interface = "eno1";
  };

  bridge = {
    enable = true;
    name = "br0";
  };

  activeInterface = if bridge.enable then bridge.name else network.interface;
in
{
  boot.remote-unlock.staticIPv4 = network;

  networking.useDHCP = lib.mkForce false;
  networking.dhcpcd.enable = false;
  networking.interfaces.${network.interface}.useDHCP = lib.mkForce false;
  networking.interfaces.${activeInterface} = {
    useDHCP = lib.mkForce false;
    ipv4.addresses = [{
      inherit (network) address prefixLength;
    }];
  };
  networking.defaultGateway = if bridge.enable then {
    address = network.gateway;
    interface = bridge.name;
  } else network.gateway;
  networking.nameservers = [ network.nameserver ];
  networking.bridges = lib.mkIf bridge.enable {
    "${bridge.name}" = {
      interfaces = [ network.interface ];
    };
  };
}
