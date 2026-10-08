{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    glab
    jira-cli-go
    jdk25
    pnpm
    nodejs
    editorconfig-checker
    yamllint
    hadolint
    ansible
    ansible-lint
  ];

  homebrew = {
    enable = true;

    casks = [
      "obsidian"
      "scroll-reverser"
    ];
  };
}
