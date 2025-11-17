{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    glab
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
