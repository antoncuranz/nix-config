{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.virtualization;
in
{
  imports = [
    inputs.nixvirt.nixosModules.default
  ];

  options.virtualization = {
    enable = lib.mkEnableOption "enable virtualization";
  };

  config = lib.mkIf cfg.enable {

    # NixVirt: declarative domains and networks.
    virtualisation.libvirt = {
      enable = true;
      connections = {
        "qemu:///system" = {
          domains = [
            { definition = ./domains/talos-1.xml; }
            { definition = ./domains/talos-2.xml; }
            { definition = ./domains/talos-3.xml; }
            # { definition = ./domains/opnsense.xml; }
            # { definition = ./domains/pfsense.xml; }
            # { definition = ./domains/nixos.xml; }
            # { definition = ./domains/win11.xml; }
          ];
          pools = [{
            definition = ./pool.xml;
            volumes = [
              { definition = ./volumes/talos-1.xml; }
              { definition = ./volumes/talos-2.xml; }
              { definition = ./volumes/talos-3.xml; }
              # { definition = ./volumes/opnsense.xml; }
              # { definition = ./volumes/pfsense.xml; }
              # { definition = ./volumes/nixos.xml; }
              # { definition = ./volumes/win11.xml; }
            ];
          }];
        };
      };
    };

    # NixOS libvirt/QEMU host configuration.
    virtualisation.libvirtd = {
      qemu.swtpm.enable = true;

      firewallBackend = "nftables";
      allowedBridges = [ "br-dmz" ];
      sshProxy = false;

      onBoot = "ignore";
      onShutdown = "shutdown";
      shutdownTimeout = 120;

      qemu = {
        package = pkgs.qemu_kvm;

        runAsRoot = false;

        verbatimConfig = ''
          namespaces = []

          # Restrict QEMU's available system calls.
          seccomp_sandbox = 1

          # Route logging through virtlogd, which rotates logs and helps
          # prevent a guest from filling the host filesystem with output.
          stdio_handler = "logd"

          # Do not create QEMU core dumps. They can be huge and can contain
          # guest memory, credentials, keys, and workload data.
          max_core = 0
        '';
      };
    };
  };
}
