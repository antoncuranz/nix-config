{ config, lib, pkgs, ... }:

let
  cfg = config.power;
in
{
  options.power.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable powerManagement";
  };

  config = lib.mkIf cfg.enable {
    powerManagement = {
      enable = true;
      scsiLinkPolicy = "med_power_with_dipm";
      powertop.enable = true;
      cpuFreqGovernor = "powersave";
    };
    systemd.tmpfiles.rules = [
      "w /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference - - - - balance_power"
    ];
  };
}
