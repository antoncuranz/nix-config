{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.samba;
  samba = config.services.samba.package;
  nssModulesPath = config.system.nssModules.path;
  adDomain = "dc.serverton.de";
  adWorkgroup = "DC";
  adNetbiosName = "SERVERTON";
  staticIp = "192.168.1.1";
in {
  options.samba = {
    enable = lib.mkEnableOption "enable samba";
  };

  config = lib.mkIf cfg.enable {
    services.samba.openFirewall = true;

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
      package = pkgs.samba4Full;
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
            tls certfile = /home/ant0n/certs/ad.crt
            tls keyfile = /home/ant0n/certs/ad.key
            tls cafile =

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
            path = /mnt/nvme/Samba/Anton
            guest ok = no
            comment =
            valid users = ant0n
            read only = no
            browseable = yes
            
        [Faye]
            path = /mnt/nvme/Samba/Faye
            guest ok = no
            comment =
            valid users = faye
            read only = no
            browseable = yes
            
        [Shared]
            path = /mnt/nvme/Samba/Shared
            guest ok = no
            comment =
            valid users = ant0n faye
            read only = no
            browseable = yes
            
        [TimeMachine]
            path = /mnt/nvme/Backup/TimeMachine
            guest ok = no
            comment =
            valid users = ant0n
            read only = no
            browseable = yes
            fruit:time machine = yes
            fruit:time machine max size = 1T
            
        [Faye Backup]
            path = /mnt/nvme/Backup/Faye
            guest ok = no
            comment =
            valid users = faye
            read only = no
            browseable = yes
            
        [Backup]
            path = /mnt/nvme/Backup/Anton
            guest ok = no
            comment =
            valid users = ant0n
            read only = no
            browseable = yes
            
        [Mediarr]
            path = /home/ant0n/mediarr
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
  };
}
