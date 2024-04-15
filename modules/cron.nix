{ config, lib, pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * TZ=UTC /usr/sbin/sanoid --cron"
      "0 0 * * * /home/ant0n/scripts/backup.sh"
      "0 0 * * 2 /home/ant0n/scripts/sync.sh"
      "0 0 * * 3 /home/ant0n/scripts/extract-ad-certs.sh"
    ];
  };
}
