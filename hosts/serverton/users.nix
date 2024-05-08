{ secrets, lib, pkgs, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    group = "ant0n";
    extraGroups = [
      "wheel"
      "libvirtd"
      "serverton_users"
    ];
    hashedPassword = "${secrets.hashedPassword}";
    openssh.authorizedKeys.keys = [
      "${secrets.sshKeys.am}"
      "${secrets.sshKeys.at}"
    ];
  };

  users.users.faye = {
    isNormalUser = true;
    uid = 1001;
    group = "faye";
    extraGroups = [
      "serverton_users"
    ];
  };

  users.groups.ant0n.gid = 1000;
  users.groups.faye.gid = 1001;
  users.groups.serverton_users.gid = 1010;
}
