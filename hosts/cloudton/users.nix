{ secrets, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    group = "ant0n";
    extraGroups = [
      "wheel"
    ];
    hashedPassword = "${secrets.hashedPassword}";
    openssh.authorizedKeys.keys = [
      "${secrets.sshKeys.am}"
      "${secrets.sshKeys.at}"
    ];
  };

  users.users.syncoid = {
    isNormalUser = true;
    group = "syncoid";
    uid = 1001;
    openssh.authorizedKeys.keys = [
      "${secrets.sshKeys.rs}"
    ];
  };

  services.openssh.settings.AllowUsers = [ "ant0n" "syncoid" ];

  users.groups.ant0n.gid = 1000;
  users.groups.syncoid.gid = 1001;

  security.sudo.extraRules = [{
    users = ["syncoid"];
    commands = [{ command = "/run/current-system/sw/bin/zfs"; options = ["NOPASSWD"]; }];
  }];
}
