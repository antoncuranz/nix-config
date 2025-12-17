{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.ghostty;
in
{
  options.ghostty = {
    enable = lib.mkEnableOption "enable ghostty";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ghostty-bin
    ];

    home-manager.users."${config.system.primaryUser}".xdg.configFile = {
      "ghostty/config" = {
        source = ./config;
      };
      "ghostty/themes" = {
        source = ./themes;
      };
    };
  };
}
