{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    colima
    docker
    docker-compose
    unstable.iterm2
    kubernetes-helm
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
      "scroll-reverser"
    ];

     masApps = {
       "The Unarchiver" = 425424353;
    };
  };
}
