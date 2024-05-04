{ lib, inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./impermanence.nix
  ];

  impermanence.enable = lib.mkDefault false;
}
