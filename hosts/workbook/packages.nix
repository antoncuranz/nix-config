{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    glab
    jira-cli-go
  ];

  homebrew = {
    enable = true;

    casks = [
      "obsidian"
      "scroll-reverser"
    ];
  };
}
