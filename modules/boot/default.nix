{ lib,inputs, ... }:

{
  imports = [
    ./grub.nix
    ./remote-unlock.nix
  ];

  boot.remote-unlock.enable = lib.mkDefault true;
}
