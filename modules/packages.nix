{ inputs, config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  nixpkgs.overlays = [ 
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.system;
      };
    })
    (final: prev: {
      pkgs-caddy = import inputs.nixpkgs-caddy {
        system = prev.system;
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    lshw
    git-crypt
    powertop
    cockpit
    lm_sensors
    htop
    unzip
    gnumake
    tree
    tmux
    iperf3
    neofetch
    lazygit
    lsof
    pciutils
    jq
    inetutils
    dig
  ];
}
