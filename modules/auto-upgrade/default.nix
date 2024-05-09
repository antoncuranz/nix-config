{ lib,inputs, ... }:

{
  imports = [
    ./autoUpgrade.nix
  ];

  auto-upgrade.enable = lib.mkDefault false;
}
