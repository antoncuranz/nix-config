{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    postfix
    procmail
    (python3.withPackages (python-pkgs: with python-pkgs; [
      paho-mqtt
    ]))
  ];
  networking.firewall = {
    allowedTCPPorts = [ 25 ];
  };
  services.postfix = {
    enable = true;
    domain = "postfix.cura.nz";
    destination = ["$myhostname" "localhost.$mydomain" "localhost" "$mydomain"];
    virtual = "@postfix.cura.nz	ant0n@postfix.cura.nz";
    extraConfig = "mailbox_command = /run/current-system/sw/bin/procmail";
  };
}
