{ lib,inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./network-bridge.nix
  ];

  virtualization.enable = lib.mkDefault true;
  virtualization.network-bridge.enable = lib.mkDefault true;
}
