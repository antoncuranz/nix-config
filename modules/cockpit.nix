{ config, lib, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
  };
}
