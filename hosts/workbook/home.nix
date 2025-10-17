{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "anton.curanz";
  home.homeDirectory = "/Users/anton.curanz";

  programs.zsh.enable = true;

  home.sessionPath = [
    "/Library/TeX/texbin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    DOCKER_HOST = "unix://$HOME/.rd/docker.sock";
    # DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
  };

  home.shellAliases = {
    vim = "nvim";
    rebuild = "sudo darwin-rebuild switch --flake '/Users/anton.curanz/Developer/nix-config#workbook'";
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
