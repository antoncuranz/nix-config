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
    ./auto-upgrade

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
  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/home/ant0n/nix-config'";
  };
  users.defaultUserShell = pkgs.zsh;

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
