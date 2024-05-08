{ secrets, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.pkgs-caddy.caddy.override {
      externalPlugins = [
        {
          name = "cloudflare";
          repo = "github.com/caddy-dns/cloudflare";
          version = "master";
        }
      ];
      vendorHash = "sha256-C7JOGd4sXsRZL561oP84V2/pTg7szEgF4OFOw35yS1s=";
    };
    configFile = pkgs.writeText "Caddyfile" ''
      {
        acme_dns cloudflare "${secrets.cloudflare_token}"
        email "anton@curanz.de"
      }

      (tls) {
        @blocked not remote_ip ${builtins.readFile ./cloudflare-ip-list}
        respond @blocked 403

        tls {
          dns cloudflare "${secrets.cloudflare_token}"
          resolvers 1.1.1.1
          key_type rsa4096
        }
        log {
          output file /var/log/caddy/access.log
        }
      }

      baikal.cura.nz {
        import tls
        reverse_proxy localhost:8080
      }

      cura.nz {
        import tls
        reverse_proxy localhost:8090
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [443];
}
