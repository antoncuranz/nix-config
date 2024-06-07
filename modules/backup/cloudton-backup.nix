{ pkgs, config, lib, secrets, ... }:

let
  cfg = config.backup.cloudton-backup;
in
{
  options.backup.cloudton-backup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
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
          ${pkgs.curl}/bin/curl -s "${secrets.healthchecks.cloudton}/fail" > /dev/null
          exit 1
        }
        trap handle_error ERR

        ${pkgs.sanoid}/bin/syncoid -r --skip-parent --exclude=zroot/root --exclude=zroot/nix syncoid@${secrets.cloudton.networking.ip}:zroot nvme/cloudton

        # Ping healthcheck
        ${pkgs.curl}/bin/curl -s "${secrets.healthchecks.cloudton}" > /dev/null
      '';
      serviceConfig = {
        Type = "simple";
      };
    };
  };
}
