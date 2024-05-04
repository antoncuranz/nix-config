{ config, lib, pkgs, inputs, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ];
    initialPassword = "ant0n";
  };

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/home/ant0n/nix-config#testvm'";
    k9s = "k9s --kubeconfig /etc/rancher/k3s/k3s.yaml";
  };

  networking.hostName = "nixvm";
  networking.hostId = "e0f98c6d";
  system.stateVersion = "23.11";

  # hardware
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
  boot.kernelModules = [ "kvm-intel" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # modules
  kubernetes.enable = true;
  kubernetes.nodeIp = "192.168.1.3";
}
