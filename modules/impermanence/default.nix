{ lib,inputs, ... }:

{
  imports = [
    impermanence.nixosModules.impermanence
    ./impermanence.nix
  ];

  boot.impermanence.enable = lib.mkDefault true;
}
