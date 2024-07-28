{ secrets, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "ant0n" ];
      X11Forwarding = true;
      PasswordAuthentication = false;
    };
    knownHosts = {
      "5.255.126.130".publicKey = "${secrets.sshKeys.sc}";
    };
  };
}
