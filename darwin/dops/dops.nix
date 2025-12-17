{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.dops;
in
{
  options.dops = {
    enable = lib.mkEnableOption "enable dops";
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      taps = [
        "mikescher/tap"
      ];

      brews = [
        "dops"
      ];
    };

    home-manager.users."${config.system.primaryUser}".home.file."Library/Application Support/dops.conf" = {
      source = ./dops.conf;
    };
  };
}
