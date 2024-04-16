{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.nixvirt.nixosModules.default ];
  
  virtualisation.libvirt.enable = true;
  #virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  #programs.virt-manager.enable = true;

  virtualisation.libvirt.connections = {
    "qemu:///system" = {
      domains = [
        { definition = ./domains/nixos.xml; }
      ];
      pools = [{
        definition = ./pool.xml;
        volumes = [
          { definition = ./volumes/nixos.xml; }
          { definition = ./volumes/nixos-1.xml; }
          { definition = ./volumes/nixos-2.xml; }
          { definition = ./volumes/nixos-3.xml; }
        ];
      }];
    };
  };
}
