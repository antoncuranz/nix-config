#!/bin/sh

# format disk
curl https://raw.githubusercontent.com/ant0ncuranz/nix-config/main/disko/zroot.nix -o /tmp/disko.nix
vim /tmp/disko.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix

# create snapshot for impermanence
zfs snapshot zroot/root@blank

mkdir -p /mnt/etc/nixos /mnt/persist/secrets/initrd /mnt/persist/var/lib/libvirt/images

# install git
nix-env -f '<nixpkgs>' -iA git

# clone configuration
git clone https://github.com/ant0ncuranz/nix-config.git /mnt/etc/nixos

cp /tmp/disko.nix /mnt/etc/nixos/disko/zroot.nix

ssh-keygen -t ed25519 -N "" -f /mnt/persist/secrets/initrd/ssh_host_ed25519_key
ssh-keygen -t rsa -N "" -f /mnt/persist/secrets/initrd/ssh_host_rsa_key

echo "Restore Serverton's persistent SSH host key and provision initrd notification"
echo "credentials as described in README.md before running nixos-install."
echo 'Then run: nixos-install --flake /mnt/etc/nixos#serverton'
