{ secrets, pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    tunnels."cloudton" = {
      credentialsFile = "/persist/secrets/cloudflared.json";
      default = "http_status:404";
      ingress = {
        "baikal.cura.nz" = {
          service = "http://localhost:8080";
        };
        "www.cura.nz" = {
          service = "http://localhost:8090";
        };
        "cura.nz" = {
          service = "http://localhost:8090";
        };
      };
    };
  };
}
