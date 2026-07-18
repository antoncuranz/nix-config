{ config, lib, secrets, pkgs, ... }:

let
  cfg = config.boot.remote-unlock;
in
{
  options.boot.remote-unlock.enable = lib.mkEnableOption "enable remote-unlock";

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      kernelModules = [ "e1000e" ];
      systemd = {
        enable = true;
        initrdBin = [
          pkgs.psmisc
          pkgs.curl
        ];
        network.enable = true;
      };
      network.ssh = {
        enable = true;
        port = 2222;
        hostKeys = [
          /persist/secrets/initrd/ssh_host_rsa_key
          /persist/secrets/initrd/ssh_host_ed25519_key
        ];
        authorizedKeys = [
          "${secrets.sshKeys.am}"
          "${secrets.sshKeys.at}"
        ];
      };
      systemd.services.pushover-remote-unlock = {
        description = "Pushover remote unlock notification";
        wantedBy = [ "initrd.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
        };
        script = ''
          log() {
            printf '[remote-unlock] %s\n' "$1" > /dev/console
          }

          while true; do
            log "sending pushover notification"
            if ${pkgs.curl}/bin/curl -k -fsS --connect-timeout 10 --max-time 30 \
              --form-string "token=${secrets.pushover.token}" \
              --form-string "user=${secrets.pushover.user}" \
              --form-string 'message=System is booting: Please unlock zroot.' \
              --form-string 'device=iphone' \
              https://api.pushover.net/1/messages.json; then
              log "pushover notification sent"
              exit 0
            fi

            log "pushover failed, retrying in 60s"
            ${pkgs.coreutils}/bin/sleep 60
          done
        '';
      };
    };
  };
}
