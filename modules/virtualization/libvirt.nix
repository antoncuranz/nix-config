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
    virtualisation.libvirt.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;

    virtualisation.libvirt.connections = {
      "qemu:///system" = {
        domains = [
          { definition = ./domains/nixos.xml; }
        ];
        pools = [{
          definition = ./pool.xml;
          volumes = [
            { definition = ./volumes/nixos.xml; }
          ];
        }];
      };
    };
  };
}
