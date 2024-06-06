{ config, lib, secrets, ... }:

let
  cfg = config.backup.cloudton;
in
{
  options.backup.cloudton = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.backup.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.timers."cloudton-backup" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
    systemd.services."cloudton-backup" = {
      script = ''
        function handle_error() {
          /run/current-system/sw/bin/curl -s "${secrets.healthchecks.cloudton}/fail" > /dev/null
          exit 1
        }
        trap handle_error ERR

        /run/current-system/sw/bin/syncoid syncoid@${secrets.cloudton.networking.ip}:zroot/home nvme/cloudton/home
        /run/current-system/sw/bin/syncoid syncoid@${secrets.cloudton.networking.ip}:zroot/persist nvme/cloudton/persist

        # Ping healthcheck
        /run/current-system/sw/bin/curl -s "${secrets.healthchecks.cloudton}" > /dev/null
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
