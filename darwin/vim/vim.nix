{ config, lib, pkgs, ... }:

let
  cfg = config.vim;
in
{
  imports = [ ./dark-mode-notify.nix ];

  options.vim = {
    enable = lib.mkEnableOption "enable vim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      plugins = {
        commentary.enable = true;
        vim-surround.enable = true;
        tmux-navigator.enable = true;
        nvim-tree.enable = true;
        nix.enable = true;
        treesitter = {
          enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            markdown
            markdown_inline
            latex
            html
          ];
          settings = {
            highlight = {
              enable = true;
            };
          };
        };
        web-devicons.enable = true;
        render-markdown = {
          enable = true;
          settings = {
            sign = {
              enabled = false;
            };
          };
        };

        alpha = {
          enable = true;
          theme = "startify";
        };
        illuminate.enable = true;
      };

      extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
        name = "vim-colors-xcode";
        src = pkgs.fetchFromGitHub {
          owner = "vismaybhargav"; # https://github.com/lunacookies/vim-colors-xcode/pull/36
          repo = "vim-colors-xcode";
          rev = "0f96f664c200eec54f311e7e0640aebaee6402df";
          hash = "sha256-GV057QK32yBRPD883V8xtS2Lu1wlnADxzuKsU743nYg=";
        };
      })];

      opts = {
        mouse = "a";
        number = true;
        relativenumber = true;
        tabstop = 2;
        shiftwidth = 0; # match tabstop
        expandtab = true;
        ignorecase = true;
        smartcase = true;
        conceallevel = 2;
      };

      extraConfigLua = (builtins.readFile ./theming.lua);
    };
  };
}
