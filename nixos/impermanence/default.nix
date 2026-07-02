{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.impermanence.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable impermanence";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.postResumeCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (lib.mkAfter ''
      echo "[impermanence] rolling back zroot@blank"
      zfs rollback -r zroot/root@blank
    '');

    boot.initrd.systemd.services.impermanence-rollback = lib.mkIf config.boot.initrd.systemd.enable {
      description = "Rollback root dataset";
      wantedBy = [ "initrd.target" ];
      after = [ "zfs.target" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      script = ''
        echo "[impermanence] rolling back zroot@blank"
        ${pkgs.zfs}/bin/zfs rollback -r zroot/root@blank
      '';
    };

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/samba"
        "/var/lib/libvirt"
        "/root/.config/rclone"
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

    fileSystems."/cache".neededForBoot = true;
    environment.persistence."/cache" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/rancher/k3s"
        "/var/cache/samba"
        "/root/.cache/restic"
      ];
    };
  };
}
