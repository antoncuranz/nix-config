{ config, lib, pkgs, ... }:

{
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      baikal = {
        image = "ckulka/baikal:nginx";
        ports = ["127.0.0.1:8080:80"];
        volumes = [
          "/persist/containers/baikal/Specific:/var/www/baikal/Specific"
          "/persist/containers/baikal/config:/var/www/baikal/config"
        ];
      };
      backplate = {
        image = "ghcr.io/antoncuranz/backplate:latest";
        ports = ["127.0.0.1:8090:8090"];
        volumes = [
          "/persist/containers/backplate/images:/app/images"
          "/persist/containers/backplate/inbox:/app/inbox"
        ];
      };
    };
  };
}
