{ config, lib, pkgs, ... }:

{
  # Open ports in the firewall.
  services.cockpit.openFirewall = true;
  services.samba.openFirewall = true;
  services.avahi.openFirewall = true;

  networking.firewall.allowedTCPPorts = [
    6443 # k3s API server
    51017 # Homebridge
    39645 # Shelly
    44500 # Tuya
  ];

  networking.firewall.allowedUDPPorts = [
    5683 # Shelly CoIoT
  ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

