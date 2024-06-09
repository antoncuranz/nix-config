{ config, lib, pkgs, ... }:

let
  cfg = config.backup.restic;
in
{
  options.backup.restic = {
    enable = lib.mkEnableOption "enable restic jobs";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      restic rclone
    ];
    services.restic.backups.samba = {
      repository = "rclone:koofr:restic-repo";
      passwordFile = "/persist/secrets/backup/restic.key";
      rcloneConfigFile = "/persist/secrets/backup/rclone.conf";
      paths = [ "/mnt/nvme/Samba" ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
      # timerConfig = (daily at midnight)
    };
  };
}
