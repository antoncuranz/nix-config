{ secrets, config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ant0n";
  home.homeDirectory = "/Users/ant0n";

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    OP_ACCOUNT = "${secrets.opAccount}";
    #DISPLAY = ":0"
  };

  home.shellAliases = {
    k = "kubectl";
    oc = "opencode";
    vim = "nvim";
    rebuild = "sudo darwin-rebuild switch --flake '/Users/ant0n/Developer/nix-config#macbook'";
    update = "nix flake update --flake '/Users/ant0n/Developer/nix-config'";
    "virt-manager" = "GSETTINGS_BACKEND=keyfile virt-manager --no-fork -c qemu+ssh://192.168.1.2/system";
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      # fish & atuin
      set -gx ATUIN_NOBIND "true"
      bind \cr _atuin_search
      bind -M insert \cr _atuin_search

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
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Anton Curanz";
      user.email = "anton@curanz.de";
      init.defaultBranch = "main";
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
