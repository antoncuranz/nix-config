{
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NM0W413915A";
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
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NM0W706699P";
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
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S6P1NF0WA55869R";
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
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_232612800422";
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
          Backup = {
            type = "zfs_fs";
          };
          Kubernetes = {
            type = "zfs_fs";
          };
        };
      };
    };
  };
}
