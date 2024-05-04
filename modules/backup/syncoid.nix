{ config, lib, pkgs, ... }:

let
  cfg = config.backup.syncoid;
in
{
  options.backup.syncoid = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.backup.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sanoid
    ];

    services.syncoid = {
      enable = true;
      interval = "Mon *-*-* 00:00:00";
      commonArgs = [
        "-r" "--skip-parent" "--no-sync-snap"
      ];

      commands = {
        "zroot" = {
          target = "HDD2/zroot";
          extraArgs = [
            "--exclude=zroot/bitcoin" "--exclude=zroot/root" "--exclude=zroot/nix"
          ];
        };
        "nvme/Samba".target = "HDD1/Samba";
        "nvme/Backup".target = "HDD1/Backup";
      };
    };
  };
}
