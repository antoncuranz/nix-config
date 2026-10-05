{ config, lib, pkgs, ... }:

{
  # Apple's libffi-40 crashes when allocating GTK callbacks on macOS 27.
  # https://github.com/NixOS/nixpkgs/issues/541367
  nixpkgs.overlays = [
    (final: prev: {
      libffi = final.libffiReal;
    })
  ];

  environment.systemPackages = with pkgs; [
    # _1password-gui
    nodejs_22
    go-critic
    unstable.talosctl
    npm-check-updates
    virt-manager
    ansible
    android-tools
    scrcpy
  ];

  homebrew = {
    enable = true;

    # casks = [
    #   "obsidian"
    #   "telegram"
    #   "signal"
    #   "timemachineeditor"
    #   "scroll-reverser"
    # ];

     masApps = {
       "1Password for Safari" = 1569813296;
       "The Unarchiver" = 425424353;
       "WireGuard" = 1451685025;
    };
  };
}
