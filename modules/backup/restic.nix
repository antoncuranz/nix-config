{ config, lib, pkgs, ... }:

let
  cfg = config.backup;
in
{
  options.backup = {
    enable = lib.mkEnableOption "enable backup jobs";
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
