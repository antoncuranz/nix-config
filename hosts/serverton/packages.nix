{ inputs, config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    intel-media-driver
    intel-gpu-tools
  ];
}
