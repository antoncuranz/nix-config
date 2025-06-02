{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  homebrew = {
    enable = true;

    casks = [
      "obsidian"
      "openlens"
      "scroll-reverser"
    ];

     masApps = {
       "The Unarchiver" = 425424353;
    };
  };
}
