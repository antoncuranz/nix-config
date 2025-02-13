{ config, lib, pkgs, secrets, ... }:

let
  cfg = config.backup.hdd-replication;
in
{
  options.backup.hdd-replication = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sanoid
    ];

    systemd.timers."hdd-replication" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Fri *-*-* 00:00:0";
        Persistent = true;
      };
    };
    systemd.services."hdd-replication" = {
      script = ''
        function handle_error() {
          ${pkgs.curl}/bin/curl -s "${secrets.healthchecks.hdd-replication}/fail" > /dev/null
          ${pkgs.zfs}/bin/zpool export HDD1 || true
          ${pkgs.zfs}/bin/zpool export HDD2 || true
          exit 1
        }
        trap handle_error ERR

        ${pkgs.zfs}/bin/zpool import HDD1
        ${pkgs.zfs}/bin/zpool import HDD2
        # ${pkgs.zfs}/bin/zfs load-key -a
        sleep 3


        # zroot -> HDD2
        ${pkgs.sanoid}/bin/syncoid --sendoptions="w" --recvoptions="u" --compress=none -r --no-sync-snap --skip-parent --exclude=zroot/bitcoin --exclude=zroot/root --exclude=zroot/nix zroot HDD2/zroot
        # --exclude will be deprecated in favor of --exclude-datasets
        # Use --delete-target-snapshots if space requires it

        # nvme/Samba -> HDD1
        ${pkgs.sanoid}/bin/syncoid --sendoptions="w" --recvoptions="u" --compress=none -r --no-sync-snap nvme/Samba HDD1/Samba

        # nvme/Backup -> HDD1
        ${pkgs.sanoid}/bin/syncoid --sendoptions="w" --recvoptions="u" --compress=none -r --no-sync-snap nvme/Backup HDD1/Backup

        # nvme/cloudton -> HDD1
        ${pkgs.sanoid}/bin/syncoid --sendoptions="w" --recvoptions="u" --compress=none -r --no-sync-snap nvme/cloudton HDD1/cloudton


        sleep 3
        ${pkgs.zfs}/bin/zpool export HDD1
        ${pkgs.zfs}/bin/zpool export HDD2

        # Ping healthcheck
        ${pkgs.curl}/bin/curl -s "${secrets.healthchecks.hdd-replication}" > /dev/null
      '';
      serviceConfig = {
        Type = "simple";
      };
    };
  };
}
