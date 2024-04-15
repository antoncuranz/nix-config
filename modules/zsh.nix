{ config, lib, pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    source ${pkgs.grml-zsh-config}/etc/zsh/zshrc

    # Make user colour green in prompt instead of default blue
    zstyle ':prompt:grml:left:items:user' pre '%F{green}%B'
  '';
  programs.zsh.promptInit = ""; # otherwise it'll override the grml prompt
  users.defaultUserShell = pkgs.zsh;
}
