{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "ant0n" "democratic-csi" ];
      X11Forwarding = true;
      PasswordAuthentication = false;
    };
    # Only accept keys managed through users.users.<name>.openssh.authorizedKeys.
    authorizedKeysInHomedir = false;
  };
}
