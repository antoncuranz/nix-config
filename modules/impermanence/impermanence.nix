{ config, lib, pkgs, ... }:

let
  cfg = config.impermanence;
in
{
  options.boot.impermanence = {
    enable = lib.mkEnableOption "enable impermanence";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      zfs rollback -r zpool/root@blank
    '';

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"

        "/var/lib/rancher/k3s"
        "/var/lib/samba"
        "/var/cache/samba"
        "/var/lib/libvirt"
      ];
      files = [
        "/etc/machine-id"
        "/etc/adjtime"
      ];
    };
  };
}
