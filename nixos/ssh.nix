{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "ant0n" "democratic-csi" ];
      X11Forwarding = true;
      PasswordAuthentication = false;
    };
    # Keep the administrator's accepted keys declarative. In particular, an
    # agent key in ~/.ssh/authorized_keys must not bypass the agent account.
    extraConfig = ''
      Match User ant0n
        AuthorizedKeysFile /etc/ssh/authorized_keys.d/%u
    '';
  };
}
