{ config, lib, pkgs, ... }:

{
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
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

