{ lib, inputs, ... }:

{
  imports = [
    ./restic.nix
    ./sanoid.nix
    ./hdd-replication.nix
    ./cloudton-backup.nix
    ./systemd-pushover.nix
  ];

  options.backup.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };
}
