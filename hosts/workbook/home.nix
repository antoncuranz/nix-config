{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "anton.curanz";
  home.homeDirectory = "/Users/anton.curanz";

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    DOCKER_HOST = "unix://$HOME/.rd/docker.sock";
  };

  home.shellAliases = {
    k = "kubectl";
    oc = "opencode";
    cd = "z";
    vim = "nvim";
    vzf = "vim $(fzf --preview 'bat -n --color=always --theme=ansi {}')";
    rebuild = "sudo darwin-rebuild switch --flake '/Users/anton.curanz/Developer/nix-config#workbook'";
  };

  programs.fish = {
    enable = true;
    completions.mcs = ''
      mcs completion fish | source
    '';

    shellInit = ''
      # ghostty ssh fix
      if test "$TERM_PROGRAM" = "ghostty"
        set -x TERM xterm-256color
      end

      # homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
  };
  programs.zoxide.enable = true;
  programs.git.enable = true;

  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      mode = "split";
      theme = "auto";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
