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

        "/root/.config/rclone"
        "/root/.cache/restic"
      ];
      files = [
        "/etc/machine-id"
        "/etc/adjtime"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/root/.ssh/id_ed25519"
        "/root/.ssh/id_ed25519.pub"
      ];
    };
  };
}
