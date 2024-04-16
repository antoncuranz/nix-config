{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ant0n";
  home.homeDirectory = "/Users/ant0n";

  programs.zsh.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    #DISPLAY = ":0"
  };

  home.shellAliases = {
    vim = "nvim";
    rebuild = "darwin-rebuild switch --flake '/Users/ant0n/Developer/non-TUB/nix-config#macbook'";
    "virt-manager" = "virt-manager --no-fork -c qemu+ssh://192.168.1.4/system";
    ibrew = "arch -x86_64 /usr/local/bin/brew";
    izsh = "arch -x86_64 zsh";
    ipython = "arch -x86_64 /usr/local/bin/python3";
  };

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Anton Curanz";
      user.email = "anton@curanz.de";
      init.defaultBranch = "main";
    };
  };

  programs.firefox = {
    enable = false; # TODO
    package = pkgs.firefox-bin;
    profiles = {
      default = {
        name = "nix-config";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          multi-account-containers
          onepassword-password-manager
          sponsorblock
        ];
      };
    };
  };

  # TODO: eval "$(direnv hook zsh)"

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
