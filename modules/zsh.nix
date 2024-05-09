{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc

      # Make user colour green in prompt instead of default blue
      zstyle ':prompt:grml:left:items:user' pre '%F{green}%B'
    '';
    promptInit = ""; # otherwise it'll override the grml prompt
  };

  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake '/home/ant0n/nix-config'";
  };
}
