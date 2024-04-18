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
      "--node-ip=192.168.1.4"
      "--write-kubeconfig-mode=644"
      "--disable-cloud-controller"
      "--datastore-endpoint=etcd"
    ];
  };
}
