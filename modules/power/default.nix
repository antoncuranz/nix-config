{ lib,inputs, ... }:

{
  imports = [
    ./power.nix
  ];

  power.enable = lib.mkDefault false;
}
