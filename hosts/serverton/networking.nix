{ ... }:

let
  address = "192.168.1.2/24";
  gateway = "192.168.1.1";
  nameserver = "192.168.1.1";
  trunkInterface = "eno1";
  lan = {
    id = 10;
    interface = "vlan-lan";
    bridge = "br-lan";
  };
  dmz = {
    id = 50;
    interface = "vlan-dmz";
    bridge = "br-dmz";
  };

  lanNetwork = {
    DHCP = "no";
    LinkLocalAddressing = "ipv6";
    IPv6AcceptRA = true;
  };
  isolatedNetwork = {
    DHCP = "no";
    LinkLocalAddressing = "no";
    IPv6AcceptRA = false;
  };

  networkd = {
    netdevs = {
      "20-${lan.interface}" = {
        netdevConfig = {
          Name = lan.interface;
          Kind = "vlan";
        };
        vlanConfig.Id = lan.id;
      };
      "20-${dmz.interface}" = {
        netdevConfig = {
          Name = dmz.interface;
          Kind = "vlan";
        };
        vlanConfig.Id = dmz.id;
      };
      "30-${lan.bridge}".netdevConfig = {
        Name = lan.bridge;
        Kind = "bridge";
      };
      "30-${dmz.bridge}".netdevConfig = {
        Name = dmz.bridge;
        Kind = "bridge";
      };
    };

    networks = {
      "10-${trunkInterface}" = {
        matchConfig.Name = trunkInterface;
        networkConfig = isolatedNetwork;
        vlan = [ lan.interface dmz.interface ];
      };
      "20-${lan.interface}" = {
        matchConfig.Name = lan.interface;
        networkConfig = isolatedNetwork;
        bridge = [ lan.bridge ];
      };
      "20-${dmz.interface}" = {
        matchConfig.Name = dmz.interface;
        networkConfig = isolatedNetwork;
        bridge = [ dmz.bridge ];
      };
      "30-${lan.bridge}" = {
        matchConfig.Name = lan.bridge;
        networkConfig = lanNetwork;
        address = [ address ];
        dns = [ nameserver ];
        gateway = [ gateway ];
      };
      "30-${dmz.bridge}" = {
        matchConfig.Name = dmz.bridge;
        networkConfig = isolatedNetwork;
      };
    };
  };
in
{
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network = networkd // {
    enable = true;
    wait-online.ignoredInterfaces = [ dmz.bridge ];
  };

  boot.initrd.systemd.network = networkd;
}
