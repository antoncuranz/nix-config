{ secrets, lib, pkgs, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "ant0n"
      "wheel"
      "libvirtd"
      "serverton_users"
    ];
    hashedPassword = "${secrets.hashedPassword}";
    openssh.authorizedKeys.keys = [
      "${secrets.sshKeys.a}"
      "${secrets.sshKeys.b}"
    ];
  };

  users.users.faye = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "faye"
      "serverton_users"
    ];
  };

  users.groups.ant0n.gid = 1000;
  users.groups.faye.gid = 1001;
  users.groups.serverton_users.gid = 1010;
}
