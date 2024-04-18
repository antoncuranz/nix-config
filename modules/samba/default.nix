{ lib,inputs, ... }:

{
  imports = [
    ./samba.nix
  ];

  samba.enable = lib.mkDefault true;
}
