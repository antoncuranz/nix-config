{ config, lib, pkgs, inputs, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
    ];
    initialPassword = "ant0n";
  };

  # boot.zfs.extraPools = [ "nvme" ];

  networking.hostName = "nixvm";
  networking.hostId = "e0f98c6d";
  system.stateVersion = "23.11";

  # hardware
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
  boot.kernelModules = [ "kvm-intel" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # modules
  kubernetes.enable = false;
  virtualization.enable = false;
  virtualization.network-bridge.enable = false;
  email.enable = false;
  samba.enable = false;
  boot.remote-unlock.enable = false;
}
