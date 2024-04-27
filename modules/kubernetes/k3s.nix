{ config, lib, pkgs, ... }:

let
  cfg = config.kubernetes;
in
{
  options.kubernetes = {
    enable = lib.mkEnableOption "enable kubernetes";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.k3s ];

    services.k3s.enable = true;
    services.k3s.role = "server";
    services.k3s.extraFlags = toString [
      "--disable=traefik"
      "--disable=local-storage"
      "--disable=metrics-server"
      "--disable=servicelb"
      "--disable-cloud-controller"
      "--disable-helm-controller"
      "--node-ip=192.168.1.2"
      "--write-kubeconfig-mode=644"
      "--datastore-endpoint=etcd"
    ];

    # required for democratic csi
    system.activationScripts.csi-symlinks.text = ''
      vars="zfs zpool mount umount"
      for x in $vars; do
        ln -sf /run/current-system/sw/bin/$x /usr/bin/$x
      done
    '';
  };
}
