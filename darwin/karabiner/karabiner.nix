{ config, lib, pkgs, ... }:

let
  cfg = config.karabiner;
in
{
  options.karabiner = {
    enable = lib.mkEnableOption "enable karabiner";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      karabiner-elements
    ];

    home-manager.users."${config.system.primaryUser}".home.file.".config/karabiner.edn" = {
      source = ./karabiner.edn;
      onChange = "${pkgs.goku}/bin/goku";
    };
  };
}
