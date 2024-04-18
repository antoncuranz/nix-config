{ config, lib, secrets, ... }:

let
  cfg = config.email;
in
{
  options.email = {
    enable = lib.mkEnableOption "enable email";
  };

  config = lib.mkIf cfg.enable {
    programs.msmtp = {
      enable = true;
      accounts = {
        default = {
          auth = true;
          tls = true;
          from = "${secrets.msmtp.email}";
          host = "${secrets.msmtp.host}";
          user = "${secrets.msmtp.email}";
          password = "${secrets.msmtp.password}";
        };
      };
    };
  };
}
