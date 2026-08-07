{ config, lib, secrets, pkgs, ... }:

let
  cfg = config.kubernetes.iscsi;
in
{
  options.kubernetes.iscsi.enable = lib.mkEnableOption "enable iscsi";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      targetcli
    ];

    users.groups.democratic-csi = {};
    users.users.democratic-csi = {
      isSystemUser = true;
      group = "democratic-csi";
      home = "/var/lib/democratic-csi";
      createHome = true;
      shell = pkgs.bashInteractive;

      openssh.authorizedKeys.keys = [
        "${secrets.sshKeys.dcsi}"
      ];
    };

    security.sudo.extraRules = [
      {
        users = [ "democratic-csi" ];

        commands = [
          {
            command = "${pkgs.targetcli}/bin/targetcli";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
