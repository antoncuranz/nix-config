{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot
    ./virtualization
    ./kubernetes
    ./email
    ./samba
    ./impermanence
    ./backup

    ./users.nix
    ./firewall.nix
    ./packages.nix

    ./ssh.nix
    ./zsh.nix
    ./git.nix
    ./power.nix
  ];

  # general stuff
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  networking.useDHCP = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
