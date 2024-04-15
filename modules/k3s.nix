{ config, lib, pkgs, ... }:

{
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
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
  ];

  #systemd.services.shutdown-k3s = {
  #  enable = true;
  #  description = "Kill containerd-shims on shutdown";
  #  unitConfig = {
  #    DefaultDependencies = false;
  #    Before = "shutdown.target umount.target";
  #  };
  #  serviceConfig = {
  #    ExecStart = "/usr/local/bin/k3s-killall.sh";
  #    Type = "oneshot";
  #  };
  #  wantedBy = [ "shutdown.target" ];
  #};
}
