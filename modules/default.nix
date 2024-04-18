{ config, lib, pkgs, ... }:

{
  imports = [
    ./virtualization
    ./kubernetes
    ./email
    ./samba

    ./users.nix
    ./firewall.nix
    ./packages.nix

    ./zfs.nix
    ./sanoid.nix

    ./ssh.nix
    ./zsh.nix
    ./git.nix
  ];

  # general stuff
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  networking.useDHCP = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
