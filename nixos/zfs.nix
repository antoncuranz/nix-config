{ pkgs, ... }:

{
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  environment.systemPackages = with pkgs; [
    zfs-prune-snapshots
  ];

  boot.kernelParams = [ 
    "zfs.zfs_vdev_scrub_max_active=24"
    "zfs.zfs_vdev_scrub_min_active=4"
    "zfs.zfs_scan_vdev_limit=67108864"
  ];
}
