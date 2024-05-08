{ secrets, config, lib, pkgs, ... }:

{
  services.openssh.enable = true;
  services.openssh.settings = {
    AllowUsers = [ "ant0n" ];
    X11Forwarding = true;
    PasswordAuthentication = false;
  };
  
  users.users.ant0n.openssh.authorizedKeys.keys = [
    "${secrets.sshKeys.a}"
    "${secrets.sshKeys.b}"
  ];
}
