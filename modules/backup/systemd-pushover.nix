{ config, lib, secrets, ... }:

let
  cfg = config.backup.systemd-pushover;
in
{
  # https://pascal-wittmann.de/entry/systemd-failure-notification

  options = {
    backup.systemd-pushover = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.backup.enable;
      };
    };
    systemd.services = lib.mkOption {
      type = with lib.types; attrsOf (
        submodule {
          config.onFailure = lib.mkIf cfg.enable [ "pushover@%n.service" ];
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."pushover@" = {
      description = "Sends a pushover notification on service failures.";
      onFailure = lib.mkForce [ ];
      script = ''
        /run/current-system/sw/bin/curl -s \
          --form-string "token=${secrets.pushover.token}" \
	  --form-string "user=${secrets.pushover.user}" \
	  --form-string "title=Service $1 failed" \
	  --form-string "message=$(/run/current-system/sw/bin/systemctl status --full "$1")" \
	  https://api.pushover.net/1/messages.json
      '';
      scriptArgs = "%i";
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
