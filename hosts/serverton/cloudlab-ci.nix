{ pkgs, ... }:

let
  domainUuid = "5ff3e8db-0fe6-48a3-99be-2e5a02771a4d";
  domainDefinition = pkgs.writeText "cloudlab.xml" (
    builtins.replaceStrings [ "@domainUuid@" ] [ domainUuid ] (builtins.readFile ./cloudlab.xml)
  );
in
{
  users.users.cloudlab-ci = {
    isNormalUser = true;
    group = "cloudlab-ci";
    openssh.authorizedKeys.keys = [ "restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVxfzbnhpgKgHn5KVC3gv4dCcSIB5ib0Wnsreg4Viei cloudlab-forgejo-serverton" ];
  };
  users.groups.cloudlab-ci = { };
  services.openssh.settings.AllowUsers = [ "cloudlab-ci" ];

  virtualisation.libvirt.connections."qemu:///system".domains = [{
    definition = domainDefinition;
    restart = false;
  }];

  virtualisation.libvirtd.extraConfig = ''
    access_drivers = [ "polkit" ]
  '';

  security.polkit.extraConfig =
    builtins.replaceStrings [ "@domainUuid@" ] [ domainUuid ] (builtins.readFile ./cloudlab-libvirt.rules);
}
