{ inputs, config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  #overlay-unstable = final: prev: {
  #  unstable = import inputs.nixpkgs-unstable {
  #    system = prev.system;
  #  };
  #};
  nixpkgs.overlays = [ 
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.system;
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lshw
    git-crypt
    powertop
    cockpit
    lm_sensors
    htop
    k9s
    kubernetes-helm
    unzip
    gnumake
    tree
    tmux
    iperf3
    neofetch
    lazygit
    lsof
    pciutils
    bc
    jq
    restic
    rclone
    buildah
  ];

  # services.cockpit = {
  #   enable = true;
  #   port = 9090;
  # };
}
