{ lib, inputs, ... }:

{
  imports = [
    ./restic.nix
    ./sanoid.nix
    ./syncoid.nix
    ./cloudton.nix
    ./systemd-pushover.nix
  ];

  backup.enable = lib.mkDefault false;
}
