{ secrets, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "ant0n" "democratic-csi" ];
      X11Forwarding = true;
      PasswordAuthentication = false;
    };
  };
}
