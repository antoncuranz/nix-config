{
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/disk/by-id/virtio-eins";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "nvme";
              };
            };
          };
        };
      };
      two = {
        type = "disk";
        device = "/dev/disk/by-id/virtio-zwei";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "nvme";
              };
            };
          };
        };
      };
      three = {
        type = "disk";
        device = "/dev/disk/by-id/virtio-drei";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "nvme";
              };
            };
          };
        };
      };
      four = {
        type = "disk";
        device = "/dev/disk/by-id/virtio-vier";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "nvme";
              };
            };
          };
        };
      };
    };
    zpool = {
      nvme = {
        type = "zpool";
        mode = "raidz";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          acltype = "posixacl";
          compression = "lz4";
          relatime = "on";
          xattr = "sa";
          mountpoint = "/mnt/nvme";
          encryption = "aes-256-gcm";
          keyformat = "raw";
          keylocation = "file:///persist/secrets/zfs/nvme.key";
        };
        datasets = {
          Samba = {
            type = "zfs_fs";
          };
          "Samba/Anton" = {
            type = "zfs_fs";
          };
          "Samba/Faye" = {
            type = "zfs_fs";
          };
          "Samba/Shared" = {
            type = "zfs_fs";
          };
          Backup = {
            type = "zfs_fs";
          };
          "Backup/Anton" = {
            type = "zfs_fs";
          };
          "Backup/Faye" = {
            type = "zfs_fs";
          };
          "Backup/TimeMachine" = {
            type = "zfs_fs";
          };
          Kubernetes = {
            type = "zfs_fs";
          };
          "Kubernetes/immich" = {
            type = "zfs_fs";
          };
          "Kubernetes/mediarr" = {
            type = "zfs_fs";
          };
          "Kubernetes/paperless" = {
            type = "zfs_fs";
          };
        };
      };
    };
  };
}


