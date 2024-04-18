{ config, lib, pkgs, secrets, ... }:

{
  users.users.ant0n = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "libvirtd"
      "serverton_users"
    ];
    hashedPassword = "${secrets.hashedPassword}";
  };

  users.users.faye = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "serverton_users"
    ];
  };

  users.groups.serverton_users.gid = 1010;
  users.defaultUserShell = pkgs.zsh;
}
