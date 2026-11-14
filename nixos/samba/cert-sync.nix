{ config, lib, pkgs, ... }:

lib.mkIf config.samba.enable {
  systemd.services.samba-cert-sync = {
    description = "Synchronize Samba TLS certificate from Kubernetes";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.coreutils pkgs.diffutils pkgs.jq pkgs.kubectl pkgs.openssl config.services.samba.package ];
    environment.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      Type = "oneshot";
      UMask = "0077";
      Restart = "on-failure";
      RestartSec = "15min";
    };
    script = builtins.readFile ./sync-certs.sh;
  };

  systemd.timers.samba-cert-sync = {
    description = "Check for renewed Samba TLS certificates daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      OnBootSec = "5min";
      Persistent = true;
    };
  };
}
