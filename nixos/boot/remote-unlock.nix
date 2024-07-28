{ config, lib, secrets, ... }:

let
  cfg = config.boot.remote-unlock;
in
{
  options.boot.remote-unlock = {
    enable = lib.mkEnableOption "enable remote-unlock";
  };

  config = lib.mkIf cfg.enable {
    # https://nixos.wiki/wiki/ZFS
    boot = {
      initrd.kernelModules = [ "e1000e" ];
      initrd.network = {
        enable = true;
        ssh = {
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
        postCommands = ''
          wget -qO- \
            --post-data "token=${secrets.pushover.token}&user=${secrets.pushover.user}&message=System is booting: Please unlock zroot." \
            https://api.pushover.net/1/messages.json
        '';
      };
    };
  };
}
