{ config, lib, pkgs, ... }:

let
  cfg = config.aerospace;
in
{
  options.aerospace.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable AeroSpace and manage its configuration.";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${config.system.primaryUser}".xdg.configFile."aerospace/aerospace.toml".source = ./aerospace.toml;

    environment.systemPackages = with pkgs; [
      unstable.aerospace
      jankyborders
    ];
  };
}
