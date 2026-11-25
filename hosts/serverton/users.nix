{ config, sshKeys, lib, pkgs, ... }:

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
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    openssh.authorizedKeys.keys = [
      "${sshKeys.am}"
      "${sshKeys.at}"
      "${sshKeys.aw}"
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

  users.users.cloudlab-ci = {
    isNormalUser = true;
    group = "cloudlab-ci";
    extraGroups = [ "libvirtd" ];
    openssh.authorizedKeys.keys = [ "restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVxfzbnhpgKgHn5KVC3gv4dCcSIB5ib0Wnsreg4Viei cloudlab-forgejo-serverton" ];
  };
  users.groups.cloudlab-ci = { };
  services.openssh.settings.AllowUsers = [ "cloudlab-ci" ];

  users.groups.ant0n.gid = 1000;
  users.groups.faye.gid = 1001;
  users.groups.serverton_users.gid = 1010;
}
