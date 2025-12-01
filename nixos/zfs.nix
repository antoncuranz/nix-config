{ pkgs, ... }:

{
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  environment.systemPackages = with pkgs; [
    zfs-prune-snapshots
  ];

  boot.kernelParams = [ 
    "zfs.zfs_scrub_delay=0" 
  ];
}
