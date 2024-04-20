{ config, lib, pkgs, ... }:

let
  cfg = config.impermanence;
in
{
  options.impermanence = {
    enable = lib.mkEnableOption "enable impermanence";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      zfs rollback -r zroot/root@blank
    '';

    fileSystems."/persist".neededForBoot = true;
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
