{ ... }:

let
  lanNetworkd.networks."10-eno1" = {
    matchConfig.Name = "eno1";
    networkConfig = {
      DHCP = "no";
      LinkLocalAddressing = "ipv6";
      IPv6AcceptRA = true;
    };
    address = [ "192.168.1.2/24" ];
    dns = [ "192.168.1.1" ];
    gateway = [ "192.168.1.1" ];
  };

  isolatedNetwork = {
    DHCP = "no";
    LinkLocalAddressing = "no";
    IPv6AcceptRA = false;
  };
in
{
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "20-vlan-lan" = {
        netdevConfig = { Name = "vlan-lan"; Kind = "vlan"; };
        vlanConfig.Id = 10;
      };
      "20-vlan-dmz" = {
        netdevConfig = { Name = "vlan-dmz"; Kind = "vlan"; };
        vlanConfig.Id = 50;
      };
      "30-br-infra".netdevConfig = { Name = "br-infra"; Kind = "bridge"; };
      "30-br-dmz".netdevConfig = { Name = "br-dmz"; Kind = "bridge"; };
    };
    networks = lanNetworkd.networks // {
      "10-enp6s0" = {
        matchConfig.Name = "enp6s0";
        networkConfig = isolatedNetwork;
        vlan = [ "vlan-lan" "vlan-dmz" ];
      };
      "20-vlan-lan" = {
        matchConfig.Name = "vlan-lan";
        networkConfig = isolatedNetwork;
        bridge = [ "br-infra" ];
      };
      "20-vlan-dmz" = {
        matchConfig.Name = "vlan-dmz";
        networkConfig = isolatedNetwork;
        bridge = [ "br-dmz" ];
      };
      "30-br-infra" = {
        matchConfig.Name = "br-infra";
        networkConfig = isolatedNetwork;
      };
      "30-br-dmz" = {
        matchConfig.Name = "br-dmz";
        networkConfig = isolatedNetwork;
      };
    };
    wait-online.ignoredInterfaces = [ "enp6s0" "vlan-lan" "vlan-dmz" "br-infra" "br-dmz" ];
  };

  boot.initrd.systemd.network = lanNetworkd;
}
