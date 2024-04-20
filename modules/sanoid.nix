{ config, lib, pkgs, ... }:

{
  services.sanoid.enable = true;

  services.sanoid.datasets."zroot/home" = {
    useTemplate = [ "main" ];
    recursive = true;
  };

  services.sanoid.datasets."zroot/persist" = {
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

  services.sanoid.templates.main = {
    hourly = 24;
    daily = 30;
    monthly = 12;
    autosnap = true;
    autoprune = true;
  };
}
