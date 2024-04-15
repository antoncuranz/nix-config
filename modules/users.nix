{ config, lib, pkgs, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "libvirtd"
      "serverton_users"
    ];
  };

  users.users.faye = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "serverton_users"
    ];
  };

  users.groups.serverton_users.gid = 1010;
}
