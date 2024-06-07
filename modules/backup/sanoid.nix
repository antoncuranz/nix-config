{ config, lib, pkgs, ... }:

let
  cfg = config.backup.sanoid;
in
{
  options.backup.sanoid = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.backup.enable;
    };
    datasets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["zroot/home" "zroot/persist"];
      description = "Datasets to create automatic snapshots of.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sanoid
    ];

    services.sanoid = {
      enable = true;

      datasets = builtins.foldl' (acc: dataset: { "${dataset}" = {
        useTemplate = [ "main" ];
        recursive = true;
      }; } // acc) {} cfg.datasets;

      templates.main = {
        hourly = 24;
        daily = 30;
        monthly = 12;
        autosnap = true;
        autoprune = true;
      };
    };
  };
}
