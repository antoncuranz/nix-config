{ config, lib, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  # virtualisation.tpm.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    swtpm
    quickemu
    quickgui
    #nur.repos.dukzcry.cockpit-machines
    #nur.repos.dukzcry.libvirt-dbus
  ];
}


