{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # _1password-gui
    nodejs_22
  ];

  homebrew = {
    enable = true;

    # casks = [
    #   "obsidian"
    #   "telegram"
    #   "signal"
    #   "timemachineeditor"
    #   "openlens"
    #   "scroll-reverser"
    # ];

     masApps = {
       "1Password for Safari" = 1569813296;
       "The Unarchiver" = 425424353;
       "WireGuard" = 1451685025;
    };
  };
}
