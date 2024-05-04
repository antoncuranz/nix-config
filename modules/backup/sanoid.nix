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
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sanoid
    ];

    services.sanoid = {
      enable = true;

      datasets = {
        "zroot/home" = {
          useTemplate = [ "main" ];
          recursive = true;
        };
  
        "zroot/persist" = {
          useTemplate = [ "main" ];
          recursive = true;
        };
    
        "zroot/mediarr" = {
          useTemplate = [ "main" ];
          recursive = true;
        };
  
        "zroot/k8s" = {
          useTemplate = [ "main" ];
          recursive = true;
        };
  
        "nvme" = {
          useTemplate = [ "main" ];
          recursive = true;
        };
      };
  
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
