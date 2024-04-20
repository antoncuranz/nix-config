{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot
    ./virtualization
    ./kubernetes
    ./email
    ./samba
    ./impermanence

    ./users.nix
    ./firewall.nix
    ./packages.nix

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

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
