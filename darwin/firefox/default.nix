{ lib,inputs, ... }:

{
  imports = [
    ./firefox.nix
  ];

  firefox.enable = lib.mkDefault false;
}
