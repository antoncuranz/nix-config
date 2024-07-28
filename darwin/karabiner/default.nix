{ lib,inputs, ... }:

{
  imports = [
    ./karabiner.nix
  ];

  karabiner.enable = lib.mkDefault false;
}
