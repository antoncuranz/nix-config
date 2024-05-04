{ lib, inputs, ... }:

{
  imports = [
    ./restic.nix
    ./sanoid.nix
    ./syncoid.nix
  ];

  backup.enable = lib.mkDefault false;
}
