{ lib, inputs, ... }:

{
  imports = [
    ./restic.nix
    ./sanoid.nix
    ./hdd-replication.nix
    ./cloudton-backup.nix
    ./systemd-pushover.nix
  ];

  backup.enable = lib.mkDefault false;
}
