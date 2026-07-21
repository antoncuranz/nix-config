{ ... }:

let
  address = "192.168.1.2/24";
  gateway = "192.168.1.1";
  nameserver = "192.168.1.1";
  lan = {
    interface = "eno1";
    bridge = "br-lan";
  };
  dmz = {
    interface = "enp5s0";
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

  lanNetworkd = {
    netdevs."30-${lan.bridge}".netdevConfig = {
      Name = lan.bridge;
      Kind = "bridge";
    };

    networks = {
      "10-${lan.interface}" = {
        matchConfig.Name = lan.interface;
        networkConfig = isolatedNetwork;
        bridge = [ lan.bridge ];
      };
      "30-${lan.bridge}" = {
        matchConfig.Name = lan.bridge;
        networkConfig = lanNetwork;
        address = [ address ];
        dns = [ nameserver ];
        gateway = [ gateway ];
      };
    };
  };

  dmzNetworkd = {
    netdevs."30-${dmz.bridge}".netdevConfig = {
      Name = dmz.bridge;
      Kind = "bridge";
    };

    networks = {
      "10-${dmz.interface}" = {
        matchConfig.Name = dmz.interface;
        networkConfig = isolatedNetwork;
        bridge = [ dmz.bridge ];
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

  systemd.network = {
    netdevs = lanNetworkd.netdevs // dmzNetworkd.netdevs;
    networks = lanNetworkd.networks // dmzNetworkd.networks;
    enable = true;
    wait-online.ignoredInterfaces = [ dmz.bridge ];
  };

  boot.initrd.systemd.network = lanNetworkd;
}
