{ config, lib, pkgs, secrets, ... }:

let
  cfg = config.backup.syncoid;
in
{
  options.backup.syncoid = {
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
          /run/current-system/sw/bin/curl -s "${secrets.healthchecks.hdd-replication}/fail" > /dev/null
          /run/current-system/sw/bin/zpool export HDD1 || true
          /run/current-system/sw/bin/zpool export HDD2 || true
          exit 1
        }
        trap handle_error ERR

        /run/current-system/sw/bin/zpool import HDD1
        /run/current-system/sw/bin/zpool import HDD2
        /run/current-system/sw/bin/zfs load-key -a
        sleep 3


        # zroot -> HDD2
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap --exclude=zroot/bitcoin --exclude=zroot/root --exclude=zroot/nix zroot HDD2/zroot
        # --exclude will be deprecated in favor of --exclude-datasets

        # nvme/Samba -> HDD1
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap nvme/Samba HDD1/Samba

        # nvme/Backup -> HDD1
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap nvme/Backup HDD1/Backup

        # nvme/cloudton -> HDD1
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap nvme/cloudton HDD1/cloudton


        sleep 3
        /run/current-system/sw/bin/zpool export HDD1
        /run/current-system/sw/bin/zpool export HDD2

        # Ping healthcheck
        /run/current-system/sw/bin/curl -s "${secrets.healthchecks.hdd-replication}" > /dev/null
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
