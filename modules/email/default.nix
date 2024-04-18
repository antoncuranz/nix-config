{ lib,inputs, ... }:

{
  imports = [
    ./msmtp.nix
  ];

  email.enable = lib.mkDefault true;
}
