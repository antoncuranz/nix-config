{ config, secrets, lib, pkgs, inputs, ... }:

{
  imports = [
    ./containers.nix
    ./caddy.nix
  ];
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "ant0n"
      "wheel"
    ];
    hashedPassword = "${secrets.hashedPassword}";
    openssh.authorizedKeys.keys = [
      "${secrets.sshKeys.a}"
      "${secrets.sshKeys.b}"
    ];
  };

  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/home/ant0n/nix-config#cloudton'";
  };

  boot.zfs.devNodes = "/dev/disk/by-path";

  networking = {
    interfaces.ens3 = {
      ipv4.addresses = [{
        address = "${secrets.cloudton.networking.ip}";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "${secrets.cloudton.networking.ip6}";
        prefixLength = 64;
      }];
    };
    defaultGateway.address = "${secrets.cloudton.networking.gateway}";
    defaultGateway6 = {
      address = "${secrets.cloudton.networking.gateway6}";
      interface = "ens3";
    };
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  # modules
  impermanence.enable = true;

  networking.hostName = "cloudton";
  networking.hostId = "af1cdddd";
  system.stateVersion = "23.11";

  # hardware (including qemu-guest.nix)
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sr_mod" "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
  boot.kernelModules = [ "kvm-amd" ];

  boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable)
    ''
      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
      hwclock -s
    '';

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}