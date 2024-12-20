{ secrets, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

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
      mosquitto = {
        image = "docker.io/library/eclipse-mosquitto";
        ports = [
          "127.0.0.1:1883:1883"
          "127.0.0.1:9001:9001"
        ];
        volumes = [
          "/persist/containers/mosquitto/config:/mosquitto/config"
          "/persist/containers/mosquitto/data:/mosquitto/data"
          "/persist/containers/mosquitto/log:/mosquitto/log"
        ];
      };
      firefox_mariadb = {
        # sudo podman exec -it firefox_mariadb mysql -uroot -p -e "CREATE DATABASE IF NOT EXISTS syncstorage_rs;CREATE DATABASE IF NOT EXISTS tokenserver_rs;GRANT ALL PRIVILEGES on syncstorage_rs.* to sync@'%';GRANT ALL PRIVILEGES on tokenserver_rs.* to sync@'%';"
        # also insert a service and node! See https://github.com/dan-r/syncstorage-rs-docker/blob/main/entrypoint.sh or https://artemis.sh/2023/03/27/firefox-syncstorage-rs.html
        image = "docker.io/linuxserver/mariadb:10.11.8";
        ports = ["127.0.0.1:3306:3306"];
        volumes = [
          "/persist/containers/firefox/mariadb:/config"
        ];
        environment = {
          MYSQL_DATABASE = "syncstorage";
          MYSQL_USER = "sync";
          MYSQL_PASSWORD = "${secrets.cloudton.firefoxSync.dbPassword}";
          MYSQL_ROOT_PASSWORD = "${secrets.cloudton.firefoxSync.dbPassword}";
        };
      };
      firefox_syncserver = {
        image = "ghcr.io/antoncuranz/syncstorage-rs:0.17.1";
        ports = ["127.0.0.1:8000:8000"];
        dependsOn = ["firefox_mariadb"];
        environment = {
          SYNC_HOST = "0.0.0.0";
          SYNC_MASTER_SECRET = "${secrets.cloudton.firefoxSync.syncMasterSecret}";
          SYNC_SYNCSTORAGE__DATABASE_URL = "mysql://sync:${secrets.cloudton.firefoxSync.dbPassword}@firefox_mariadb:3306/syncstorage_rs";
          SYNC_TOKENSERVER__DATABASE_URL = "mysql://sync:${secrets.cloudton.firefoxSync.dbPassword}@firefox_mariadb:3306/tokenserver_rs";
          SYNC_TOKENSERVER__RUN_MIGRATIONS = "true";
          SYNC_TOKENSERVER__ENABLED = "true";
          SYNC_TOKENSERVER__FXA_EMAIL_DOMAIN = "true";
          SYNC_TOKENSERVER__FXA_METRICS_HASH_SECRET = "${secrets.cloudton.firefoxSync.metricsHashSecret}";
          SYNC_TOKENSERVER__FXA_OAUTH_SERVER_URL = "https://oauth.accounts.firefox.com";
          SYNC_TOKENSERVER__FXA_BROWSERID_AUDIENCE = "https://token.services.mozilla.com";
          SYNC_TOKENSERVER__FXA_BROWSERID_ISSUER = "https://api.accounts.firefox.com";
          SYNC_TOKENSERVER__FXA_BROWSERID_SERVER_URL = "https://verifier.accounts.firefox.com/v2";
        };
      };
    };
  };
}
