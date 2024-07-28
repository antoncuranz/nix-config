{ lib, inputs, ... }:

{
  imports = [
    ./grub.nix
    ./remote-unlock.nix
    ./sysctl.nix
  ];

  boot.remote-unlock.enable = lib.mkDefault false;
}
