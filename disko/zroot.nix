{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HAHQ-000H1_S425NA1M917993";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          acltype = "posixacl";
          compression = "lz4";
          relatime = "on";
          xattr = "sa";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          var = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var";
          };
          home = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
          bitcoin = { # TODO
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home/ant0n/bitcoin";
          };
          k3s = { # TODO
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var/lib/rancher/k3s";
          };
        };
      };
    };
  };
}


