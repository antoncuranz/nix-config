{ lib,inputs, ... }:

{
  imports = [
    ./samba.nix
    ./cert-sync.nix
    ./avahi.nix
  ];

  samba.enable = lib.mkDefault false;
}
