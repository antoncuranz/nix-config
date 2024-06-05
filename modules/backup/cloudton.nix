{ config, lib, pkgs, ... }:

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
        /run/current-system/sw/bin/syncoid syncoid@5.255.126.130:zroot/home nvme/cloudton/home
        /run/current-system/sw/bin/syncoid syncoid@5.255.126.130:zroot/persist nvme/cloudton/persist
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
