{ config, lib, pkgs, inputs, secrets, ... }:

{
  boot.zfs.extraPools = [ "nvme" ];

  environment.systemPackages = with pkgs; [
    intel-media-driver
    intel-gpu-tools
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
      "--commit-lock-file"
    ];
    dates = "06:00";
    randomizedDelaySec = "45min";
  };

  networking.hostName = "serverton";
  networking.hostId = "7bdc28b5";

  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "ant0n"
      "wheel"
      "libvirtd"
      "serverton_users"
    ];
    hashedPassword = "${secrets.hashedPassword}";
  };

  users.users.faye = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "faye"
      "serverton_users"
    ];
  };

  users.groups.ant0n.gid = 1000;
  users.groups.faye.gid = 1001;
  users.groups.serverton_users.gid = 1010;

  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/home/ant0n/nix-config#default'";
    k9s = "k9s --kubeconfig /etc/rancher/k3s/k3s.yaml";
  };

  # modules
  kubernetes.enable = true;
  kubernetes.nodeIp = "192.168.1.2";

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
