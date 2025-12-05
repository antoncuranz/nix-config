{ config, lib, secrets, pkgs, ... }:

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
          echo "[remote-unlock] sending pushover notification"
          ${pkgs.curl}/bin/curl -k --retry 3 --retry-all-errors \
            --form-string "token=${secrets.pushover.token}" \
            --form-string "user=${secrets.pushover.user}" \
            --form-string "message=System is booting: Please unlock zroot." \
            --form-string "device=iphone" \
            https://api.pushover.net/1/messages.json
        '';
      };
    };
  };
}
