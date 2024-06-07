{ lib, inputs, ... }:

{
  imports = [
    ./restic.nix
    ./sanoid.nix
    ./syncoid.nix
    ./cloudton-backup.nix
    ./systemd-pushover.nix
  ];

  backup.enable = lib.mkDefault false;
}
