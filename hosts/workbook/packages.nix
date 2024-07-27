{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    colima
    docker
    docker-compose
    iterm2
    k9s
    karabiner-elements
    goku
    spotify
    firefox-bin
  ];

  homebrew = {
    enable = true;

    casks = [
      "obsidian"
      "openlens"
    ];

     masApps = {
       "The Unarchiver" = 425424353;
       "Magnet" = 441258766;
    };
  };
}
