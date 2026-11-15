{ ... }:
{
  sops.defaultSopsFile = ../../secrets/secrets.enc.json;
  sops.defaultSopsFormat = "json";
  # This host key is persisted by impermanence and available before user creation.
  sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets = {
    hashedPassword.neededForUsers = true;
    "pushover/token" = { };
    "pushover/user" = { };
    "healthchecks/hdd-replication" = { };
  };
}
