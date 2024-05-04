{ config, lib, pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "26 11 * * *	/home/ant0n/scripts/backup.sh >> /tmp/cron.log"
      "0 0 * * 2	/home/ant0n/scripts/sync.sh >> /tmp/cron.log"
      "0 0 * * 3	/home/ant0n/scripts/extract-ad-certs.sh >> /tmp/cron.log"
    ];
  };
}
