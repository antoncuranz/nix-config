{ lib,inputs, ... }:

{
  imports = [
    ./k3s.nix
  ];

  kubernetes.enable = lib.mkDefault true;
}
