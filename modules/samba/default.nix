{ lib,inputs, ... }:

{
  imports = [
    ./samba.nix
    ./avahi.nix
  ];

  samba.enable = lib.mkDefault false;
}
