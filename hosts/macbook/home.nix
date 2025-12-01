{ config, pkgs, ... }:

  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ant0n";
  home.homeDirectory = "/Users/ant0n";

  programs.zsh.enable = true;

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    #DISPLAY = ":0"
  };

  home.shellAliases = {
    opencode = "opencode --agent plan";
    vim = "nvim";
    rebuild = "sudo darwin-rebuild switch --flake '/Users/ant0n/Developer/nix-config#macbook'";
    update = "nix flake update --flake '/Users/ant0n/Developer/nix-config'";
    "virt-manager" = "GSETTINGS_BACKEND=keyfile virt-manager --no-fork -c qemu+ssh://192.168.1.2/system";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      user.name = "Anton Curanz";
      user.email = "anton@curanz.de";
      init.defaultBranch = "main";
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
