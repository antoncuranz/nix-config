{ config, lib, secrets, ... }:

{
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
}
