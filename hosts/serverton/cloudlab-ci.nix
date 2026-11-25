{ pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.libvirt ]);
  startVm = pkgs.writeTextFile {
    name = "cloudlab-start-vm";
    destination = "/bin/cloudlab-start-vm";
    executable = true;
    text = ''
      #!${python}/bin/python3 -I
      ${builtins.replaceStrings [ "@domain_xml@" ] [ "${./cloudlab.xml}" ] (builtins.readFile ./cloudlab-start-vm.py)}
    '';
  };
in
{
  users.users.cloudlab-ci = {
    isNormalUser = true;
    group = "cloudlab-ci";
    openssh.authorizedKeys.keys = [ "restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVxfzbnhpgKgHn5KVC3gv4dCcSIB5ib0Wnsreg4Viei cloudlab-forgejo-serverton" ];
  };
  users.groups.cloudlab-ci = { };
  services.openssh.settings.AllowUsers = [ "cloudlab-ci" ];

  environment.systemPackages = [ startVm ];

  security.sudo.extraRules = [{
    users = [ "cloudlab-ci" ];
    runAs = "root";
    commands = [{
      command = "/run/current-system/sw/bin/cloudlab-start-vm \"\"";
      options = [ "NOPASSWD" "NOSETENV" ];
    }];
  }];
}
