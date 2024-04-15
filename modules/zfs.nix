{ config, lib, pkgs, ... }:

let
  secrets = import ../secrets.nix;
in
{
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot"; }
    ];
  };

  fileSystems."/" =
    { device = "zroot/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "zroot/nix";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "zroot/var";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zroot/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HAHQ-000H1_S425NA1M917993-part1";
      fsType = "vfat";
    };

  swapDevices = [ ];
  
  # ZFS Remote unlock (https://nixos.wiki/wiki/ZFS)
  boot = {
    initrd.kernelModules = [ "e1000e" ];
    initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222; 
        hostKeys = [
          /etc/secrets/initrd/ssh_host_rsa_key
          /etc/secrets/initrd/ssh_host_ed25519_key
        ];
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrvAseTJHY51PRx32hGgqqAXm3BzapliBJn4qmVCmLWJ0Jep2POo5zMI7TBaeQq4hiIvirpCROBiUmwVjW3VUNglTgRAybW06ZzEFGNk07xSQfvqKR3FH9V3p6Iu1uI14TBx+vxAo+HltIlFfyNAJ/W6uyAt0agT6ce0Un97alz7Z8FG2qYn16hJmJZaoYjChvEkVEgvGMn+o+F8i53pRtp2etUhbkMbtTKNVibL8IzOaubAUS7BkmHz3TRpciqnaCxhLbRqGNaya/pQ/BU/hjlO8Oa2J7F//TVbhy3Gjlo2t2Ad/YUjVtoaAAtsCicnssYrNIUrd02VBfKfiafmEZiVuFENxo6sL6fi2wF9yBVoojlhTNBtPamBpHmtJ24qKyE9mkQx1CO8zEpL334KGkUPtTygBeLI6HpoDFDVVZPzacwSnv8hdSnR11B7z6UG/ZSjrlKUv66QsrVnEyhwk9tOKsvw9aGdAtYbgDPreTtj8sOzy3YwmnUyi1Zm03yWc="
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9vjqeM89Q5GpdpFbRez1GSEHJh9puNm9MN8otYjOUr4pNibeboYJixMrq15RtlxbR+s4hY8vEuVYunLSBOKeD6wYqH52rPWycO/CIO/oEU22WrZ3v2oIhVH23suBqQRLRYqJaWmn+1aIeJMFbkeG7IWHbcLu8aym6eDgwLHVFnYzfa01No0rjx5u9ZUWHbXr1+2TXdE/0QX91rN21SszX5hI9GX7TBRIGxmYNCt9LIDHq7rtbME1Im8W9wjJvQO6uprK/ys+BJ7lbVSmGRnGzb27l3mWgan8Ydt+kbnvMpM2Ri+rOTUVL0adtGVYUgvV4qxP3+hzk//SHc96DIHKL9V9LQntfeTKDbsaMw6s5ltP2ZyFPih5q1usLJOLo0UVcy2aA53cVyJvBGLsenUbwVL8rf068K1ah2H9RN6w7SGG12S4L2iIc4p8k6xRu/QKgeeGCk8MvhZRGWxAoqwsLGnFJdBm5WNW4qYnOJa7oE/TmD1/XkFk8HtXfyQMQdRiIbIGc3ixfjAuujqovqHPhWnz1DnHy1sIWNyOkERC4VoDZIlnGgybAVqhMfVVkqm2AZQEHf6ra/LDDhJsXxnVbfHYCJbvxb91BLS4RxqPKUDrrDTn44QMGBni30ZGJ1apTF3TlA/jrejNMp2LvTv5QnrJpAg22tPnggXdONmoYUQ=="
        ];
      };
      postCommands = ''
        wget -qO- \
          --post-data "token=${secrets.pushover.token}&user=${secrets.pushover.user}&message=System is booting: Please unlock zroot." \
          https://api.pushover.net/1/messages.json
      '';
    };
  };
}
