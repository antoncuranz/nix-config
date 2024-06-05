{ lib, inputs, ... }:

{
  imports = [
    ./restic.nix
    ./sanoid.nix
    ./syncoid.nix
    ./cloudton.nix
  ];

  backup.enable = lib.mkDefault false;
}
