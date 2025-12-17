{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc

      # Make user colour green in prompt instead of default blue
      zstyle ':prompt:grml:left:items:user' pre '%F{green}%B'
      if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
          export TERM=xterm-256color
      fi
    '';
    promptInit = ""; # otherwise it'll override the grml prompt
  };
}
