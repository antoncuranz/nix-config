{ lib, inputs, ... }:

{
  imports = [
    ./kubernetes.nix
    ./iscsi.nix
  ];

  kubernetes.enable = lib.mkDefault false;
  kubernetes.iscsi.enable = lib.mkDefault false
}
