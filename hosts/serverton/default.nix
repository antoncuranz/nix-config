{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./users.nix
    ./firewall.nix
    ./packages.nix
    ./misc.nix
  ];

  # modules
  kubernetes.enable = true;
  kubernetes.nodeIp = "192.168.1.2";
  power.enable = true;

  backup = {
    enable = true;
    sanoid.datasets = [
      "zroot/home"
      "zroot/persist"
      "zroot/mediarr"
      "zroot/k8s"
      "nvme/Backup"
      "nvme/Samba"
    ];
    hdd-replication.enable = true;
    cloudton-backup.enable = true;
    restic.enable = true;
  };

  boot.remote-unlock.enable = true;
  samba.enable = true;
  email.enable = true;
  impermanence.enable = true;
  virtualization.enable = true;
  virtualization.network-bridge.enable = true;
  auto-upgrade.enable = true;

  # hardware
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
