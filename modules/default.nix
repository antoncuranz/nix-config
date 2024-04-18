{ config, lib, pkgs, ... }:

{
  imports = [
    ./virtualization
    ./kubernetes.nix
    ./email.nix
    ./samba.nix

    ./users.nix
    ./firewall.nix
    ./packages.nix

    ./zfs.nix
    ./sanoid.nix

    ./ssh.nix
    ./zsh.nix
    ./git.nix
  ];

  # modules
  kubernetes.enable = lib.mkDefault true;
  virtualization.enable = lib.mkDefault true;
  email.enable = lib.mkDefault true;
  samba.enable = lib.mkDefault true;


  # general stuff
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  networking.useDHCP = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
