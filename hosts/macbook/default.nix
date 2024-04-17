{ config, lib, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Playground
  users.users.ant0n.home = "/Users/ant0n";
  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    launchctl stop com.apple.Dock.agent
    launchctl start com.apple.Dock.agent
  '';

  system.defaults = {
    dock = {
      orientation = "left";
      show-recents = false;
      tilesize = 42;
    };
  };

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
