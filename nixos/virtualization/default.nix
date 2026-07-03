{ lib,inputs, ... }:

{
  imports = [
    ./libvirt.nix
  ];

  virtualization.enable = lib.mkDefault false;
}
