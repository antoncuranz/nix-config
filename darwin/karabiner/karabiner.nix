{ config, lib, pkgs, ... }:

let
  cfg = config.karabiner;
in
{
  options.karabiner = {
    enable = lib.mkEnableOption "enable karabiner";
    user = lib.mkOption {
      type = lib.types.str;
      default = "ant0n";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      karabiner-elements
    ];

    home-manager.users."${cfg.user}".home.file.".config/karabiner.edn" = {
      source = ./karabiner.edn;
      onChange = "${pkgs.goku}/bin/goku";
    };
  };
}
