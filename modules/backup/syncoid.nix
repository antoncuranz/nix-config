{ config, lib, pkgs, ... }:

let
  cfg = config.backup.syncoid;
in
{
  options.backup.syncoid = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.backup.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sanoid
    ];

    #services.syncoid = {
    #  enable = true;
    #  interval = "Mon *-*-* 00:00:00";
    #  commonArgs = [
    #    "-r" "--skip-parent" "--no-sync-snap"
    #  ];
#
#      commands = {
#        "zroot" = {
#          target = "HDD2/zroot";
#          extraArgs = [
#            "--exclude=zroot/bitcoin" "--exclude=zroot/root" "--exclude=zroot/nix"
#          ];
#        };
#        "nvme/Samba".target = "HDD1/Samba";
#        "nvme/Backup".target = "HDD1/Backup";
#      };
#    };



    systemd.timers."hdd-replication" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Fri *-*-* 00:00:0";
        Persistent = true;
      };
    };
    systemd.services."hdd-replication" = {
      script = ''
        HEALTHCHECK_URL="https://hc-ping.com/3eaef667-a266-4452-8907-c1776c7ecf7e"

        function check() {
        	exitCode=$?
        	if [ $exitCode -ne 0 ]; then
        		/run/current-system/sw/bin/curl -s "$HEALTHCHECK_URL/fail" > /dev/null
        	fi
        }

        # Ping healthcheck
        /run/current-system/sw/bin/curl -s "$HEALTHCHECK_URL" > /dev/null

        /run/current-system/sw/bin/zpool import HDD1
        /run/current-system/sw/bin/zpool import HDD2
        /run/current-system/sw/bin/zfs load-key -a
        sleep 3


        # zroot -> HDD2
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap --exclude=zroot/bitcoin --exclude=zroot/root --exclude=zroot/nix zroot HDD2/zroot
        # --exclude will be deprecated in favor of --exclude-datasets
        check

        # nvme/Samba -> HDD1
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap nvme/Samba HDD1/Samba
        check

        # nvme/Backup -> HDD1
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap nvme/Backup HDD1/Backup
        check

        # nvme/cloudton -> HDD1
        /run/current-system/sw/bin/syncoid -r --skip-parent --no-sync-snap nvme/cloudton HDD1/cloudton
        check


        sleep 3
        /run/current-system/sw/bin/zpool export HDD1
        /run/current-system/sw/bin/zpool export HDD2
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
