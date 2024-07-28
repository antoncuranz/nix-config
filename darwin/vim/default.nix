{ lib,inputs, ... }:

{
  imports = [
    ./vim.nix
  ];

  vim.enable = lib.mkDefault false;
}
