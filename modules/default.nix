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
    ./power

    ./users.nix
    ./packages.nix

    ./ssh.nix
    ./zsh.nix
    ./zfs.nix
    ./git.nix
  ];

  # general stuff
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  networking.useDHCP = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.sessionVariables = {
    EDITOR = "vim";
  };
  networking.nftables.enable = true;

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
