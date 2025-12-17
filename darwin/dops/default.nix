{ lib,inputs, ... }:

{
  imports = [
    ./dops.nix
  ];

  dops.enable = lib.mkDefault false;
}
