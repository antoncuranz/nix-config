{ config, secrets, lib, pkgs, inputs, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ];
    initialPassword = "ant0n";
  };

  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/home/ant0n/nix-config#vps'";
  };

  # Configure network IP and DNS
  systemd.network.networks.ens3 = {
    address = ["${secrets.vps.networking.ip}"];
    gateway = ["${secrets.vps.networking.gateway}"];
  };
  networking.nameservers = [
    "${secrets.vps.networking.dns}"
  ];

  # modules
  impermanence.enable = true;

  networking.hostName = "cloudton";
  networking.hostId = "af1cdddd";
  system.stateVersion = "23.11";

  # hardware
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
  boot.kernelModules = [ "kvm-intel" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
