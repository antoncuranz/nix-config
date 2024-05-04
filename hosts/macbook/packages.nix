{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    colima
    docker
    docker-compose
    iterm2
    k9s
    virt-manager
    karabiner-elements
    goku
    spotify
    _1password-gui
    firefox-bin
  ];

  homebrew = {
    enable = true;

    # casks = [
    #   "obsidian"
    #   "telegram"
    #   "signal"
    #   "timemachineeditor"
    #   "openlens"
    # ];

     masApps = {
       "1Password for Safari" = 1569813296;
       "The Unarchiver" = 425424353;
       "WireGuard" = 1451685025;
       "Magnet" = 441258766;
    };
  };
}
