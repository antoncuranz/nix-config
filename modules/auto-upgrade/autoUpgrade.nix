{ config, lib, pkgs, ... }:

let
  cfg = config.auto-upgrade;
in
{
  options.auto-upgrade = {
    enable = lib.mkEnableOption "enable autoUpgrade";
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = "/home/ant0n/nix-config";
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
        "--commit-lock-file"
      ];
      dates = "weekly";
      randomizedDelaySec = "45min";
    };
  };
}
