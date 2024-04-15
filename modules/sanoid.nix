{ config, lib, pkgs, ... }:

{
  services.sanoid.enable = true;

  services.sanoid.datasets.zroot = {
    useTemplate = [ "main" ];
    recursive = true;
  };

  services.sanoid.datasets.SSD = {
    useTemplate = [ "main" ];
    recursive = true;
  };

  services.sanoid.datasets.Samba = {
    useTemplate = [ "main" ];
    recursive = true;
  };

  services.sanoid.datasets.Backup = {
    useTemplate = [ "main" ];
    recursive = true;
  };

  services.sanoid.datasets."zroot/bitcoin" = {
    autosnap = false;
    autoprune = false;
    monitor = false;
  };

  services.sanoid.templates.main = {
    hourly = 24;
    daily = 30;
    monthly = 12;
    autosnap = true;
    autoprune = true;
  };
}
