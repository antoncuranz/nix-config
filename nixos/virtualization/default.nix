{ lib,inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./network-bridge.nix
  ];

  virtualization.enable = lib.mkDefault false;
  virtualization.network-bridge.enable = lib.mkDefault false;
}
