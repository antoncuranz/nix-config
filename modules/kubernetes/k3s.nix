{ config, lib, pkgs, ... }:

let
  cfg = config.kubernetes;
in
{
  options.kubernetes = {
    enable = lib.mkEnableOption "enable kubernetes";
    nodeIp = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.unstable.k3s ];

    services.k3s.enable = true;
    services.k3s.package = pkgs.unstable.k3s;
    services.k3s.role = "server";
    services.k3s.extraFlags = toString [
      "--disable=traefik"
      "--disable=local-storage"
      "--disable=metrics-server"
      "--disable=servicelb"
      "--disable-cloud-controller"
      "--disable-helm-controller"
      "--node-ip=${cfg.nodeIp}"
      "--write-kubeconfig-mode=644"
      "--datastore-endpoint=etcd"
    ];

    # required for democratic csi
    systemd.services."csi-symlink@" = {
      description = "Create a symlink in /usr/bin";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/run/current-system/sw/bin/ln -sf /run/current-system/sw/bin/%I /usr/bin/%I";
      };
    };
    
    systemd.services."k3s".wants = [
      "csi-symlink@zfs.service"
      "csi-symlink@zpool.service"
      "csi-symlink@mount.service"
      "csi-symlink@umount.service"
    ];
  };
}
