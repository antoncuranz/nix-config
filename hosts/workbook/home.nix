{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ant0n";
  home.homeDirectory = "/Users/ant0n";

  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
  };

  home.shellAliases = {
    k = "kubectl";
    oc = "opencode";
    cd = "z";
    vim = "nvim";
    vzf = "vim $(fzf --preview 'bat -n --color=always --theme=ansi {}')";
    rebuild = "sudo darwin-rebuild switch --flake '/Users/ant0n/Developer/nix-config#workbook'";
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

  programs.git = {
    enable = true;
    settings = {
      user.name = "Anton Curanz";
      user.email = "anton.curanz@stackmeister.com";
      init.defaultBranch = "main";
    };
  };

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
