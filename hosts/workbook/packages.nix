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
    sshuttle
    unstable.k6
  ];

  homebrew = {
    enable = true;

    casks = [
      "obsidian"
      "scroll-reverser"
    ];
  };
}
