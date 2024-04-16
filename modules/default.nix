{ config, lib, pkgs, ... }:

{
  imports = [
    ./zfs.nix
    ./networking.nix
    ./ssh.nix
    ./zsh.nix
    ./sanoid.nix
    ./users.nix
    ./firewall.nix
    ./packages.nix
    ./samba.nix
    ./libvirt
    ./k3s.nix
    ./msmtp.nix
    ./cockpit.nix
    ./git.nix
  ];
}
