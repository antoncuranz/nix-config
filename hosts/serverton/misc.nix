{ inputs, config, lib, pkgs, ... }:

{
  boot.zfs.extraPools = [ "nvme" ];

  networking.hostName = "serverton";
  networking.hostId = "7bdc28b5";
  
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="2838", SYMLINK+="rtlsdr"
  '';
}
