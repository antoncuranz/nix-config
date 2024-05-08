{ config, lib, pkgs, ... }:

{
  services.openssh.enable = true;
  services.openssh.settings = {
    AllowUsers = [ "ant0n" ];
    X11Forwarding = true;
    PasswordAuthentication = false;
  };
}
