{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.samba;
  samba = cfg.package;
  nssModulesPath = config.system.nssModules.path;
  adDomain = "dc.serverton.de";
  adWorkgroup = "DC";
  adNetbiosName = "SERVERTON";
  staticIp = "192.168.1.1";
in {
  # Disable resolveconf, we're using Samba internal DNS backend
  systemd.services.resolvconf.enable = false;
  environment.etc = {
    resolvconf = {
      text = ''
        search ${adDomain}
        nameserver ${staticIp}
      '';
    };
  };

  # Rebuild Samba with LDAP, MDNS and Domain Controller support
  nixpkgs.overlays = [ (self: super: {
    samba = (super.samba.override {
      enableLDAP = true;
      enableMDNS = true;
      enableDomainController = true;
      enableProfiling = true; # Optional for logging
       # Set pythonpath manually (bellow with overrideAttrs) as it is not set on 22.11 due to bug
    });
      #.overrideAttrs (finalAttrs: previousAttrs: {
      #  pythonPath = with super; [ python3Packages.dnspython tdb ldb talloc ];
      #});
  })];

  # Disable default Samba `smbd` service, we will be using the `samba` server binary
  systemd.services.samba-smbd.enable = false;  
  systemd.services.samba = {
    description = "Samba Service Daemon";

    requiredBy = [ "samba.target" ];
    partOf = [ "samba.target" ];

    serviceConfig = {
      ExecStart = "${samba}/sbin/samba --foreground --no-process-group";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      LimitNOFILE = 16384;
      PIDFile = "/run/samba.pid";
      Type = "notify";
      NotifyAccess = "all"; #may not do anything...
    };
    unitConfig.RequiresMountsFor = "/var/lib/samba";
  };

  services.samba = {
    enable = true;
    enableNmbd = false;
    enableWinbindd = false;
    configText = ''
      # Global parameters
      [global]
          dns forwarder = ${staticIp}
          netbios name = ${adNetbiosName}
          realm = ${toUpper adDomain}
          server role = active directory domain controller
          workgroup = ${adWorkgroup}
          idmap_ldb:use rfc2307 = yes
          # tls certfile = /home/ant0n/certs/ad.crt
          # tls keyfile = /home/ant0n/certs/ad.key
          # tls cafile =

          # File Sharing
          server string = Serverton
          fruit:model = RackMac
          mdns name = mdns
          fruit:encoding = native
          fruit:metadata = stream
          fruit:zero_file_id = yes
          fruit:nfs_aces = no
          vfs objects = catia fruit streams_xattr
          access based share enum = yes
          
      [Anton]
          path = /mnt/Samba/Anton
          guest ok = no
          comment =
          valid users = ant0n
          read only = no
          browseable = yes
          
      [Faye]
          path = /mnt/Samba/Faye
          guest ok = no
          comment =
          valid users = faye
          read only = no
          browseable = yes
          
      [Shared]
          path = /mnt/Samba/Shared
          guest ok = no
          comment =
          valid users = ant0n faye
          read only = no
          browseable = yes
          
      [TimeMachine]
          path = /mnt/Backup/TimeMachine
          guest ok = no
          comment =
          valid users = ant0n
          read only = no
          browseable = yes
          fruit:time machine = yes
          fruit:time machine max size = 1T
          
      [Faye Backup]
          path = /mnt/Backup/Faye
          guest ok = no
          comment =
          valid users = faye
          read only = no
          browseable = yes
          
      [Backup]
          path = /mnt/Backup/Anton
          guest ok = no
          comment =
          valid users = ant0n
          read only = no
          browseable = yes
          
      [Mediarr]
          path = /mnt/SSD/k8s/mediarr
          guest ok = no
          comment =
          browseable = yes
          valid users = ant0n faye
          read only = yes

      # Required for AD setup
      [sysvol]
          path = /var/lib/samba/sysvol
          read only = No

      [netlogon]
          path = /var/lib/samba/sysvol/${adDomain}/scripts
          read only = No
    '';
  };  
}
