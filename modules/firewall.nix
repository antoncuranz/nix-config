{ config, lib, pkgs, ... }:

{
  # Open ports in the firewall.
  services.cockpit.openFirewall = true;
  services.samba.openFirewall = true;

  networking.firewall.allowedTCPPorts = [
    6443 # k3s API server
  ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

