{ config, lib, pkgs, ... }:

{
  programs.git.enable = true;
  programs.git.config = {
    user = {
      name = "Anton Curanz";
      email = "anton@curanz.de";
    };
    init = {
      defaultBranch = "main";
    };
  };
}
