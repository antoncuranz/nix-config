{ config, ... }:

{
  system.defaults = {
    dock = {
      orientation = "left";
      show-recents = false;
      tilesize = 42;
    };
    NSGlobalDomain = {
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
