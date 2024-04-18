#!/bin/sh

curl https://raw.githubusercontent.com/ant0ncuranz/nix-config/main/disko/zroot.nix -o /tmp/disko.nix
vim /tmp/disko.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix

mkdir -p /mnt/etc/nixos
nix-env -f '<nixpkgs>' -iA git
git clone https://github.com/ant0ncuranz/nix-config.git /mnt/etc/nixos
cp /tmp/disko.nix /mnt/etc/nixos/disko/zroot.nix

nixos-install --flake "/mnt/etc/nixos#testvm"
