{ config, lib, pkgs, ... }:

let
  cfg = config.vim;
in
{
  imports = [ ./dark-mode-notify.nix ];

  options.vim = {
    enable = lib.mkEnableOption "enable vim";
  };

  # to fix strikethrough: https://github.com/mhinz/dotfiles/blob/master/bin/fix-term

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      plugins = {
        commentary.enable = true;
        vim-surround.enable = true;
        tmux-navigator.enable = true;
        nvim-tree.enable = true;
        nix.enable = true;
        illuminate.enable = true;
        web-devicons.enable = true;
        telescope.enable = true;
        opencode.enable = true;
        snacks = {
          enable = true;
          settings = {
            input.enabled = true;
          };
        };
        telekasten = {
          enable = true;
          settings = {
            home.__raw = "vim.fn.expand(\"~/zettelkasten\")";
            templates.__raw = "vim.fn.expand(\"~/zettelkasten/templates\")";
            template_new_note.__raw = "vim.fn.expand(\"~/zettelkasten/templates/basenote.md\")";
            template_new_daily.__raw = "vim.fn.expand(\"~/zettelkasten/templates/daily.md\")";
            template_new_weekly.__raw = "vim.fn.expand(\"~/zettelkasten/templates/weekly.md\")";
            take_over_my_home = false;
            auto_set_filetype = false;
            auto_set_syntax = false;
            journal_auto_open = true;
          };
        };
        alpha = {
          enable = true;
          theme = "startify";
        };
        treesitter = {
          enable = true;
          grammarPackages = with pkgs.unstable.vimPlugins.nvim-treesitter.builtGrammars; [
            markdown
            markdown_inline
            latex
            html
          ];
          settings.highlight.enable = true;
        };
        render-markdown = {
          enable = true;
          settings = {
            sign.enabled = false;
            heading.enabled = false;
            bullet.enabled = false;
            link.custom = {
              jira = { pattern = "atlassian%.net/browse"; icon = " "; highlight = "RenderMarkdownLink"; };
              confluence = { pattern = "atlassian%.net/wiki"; icon = " "; highlight = "RenderMarkdownLink"; };
              kibana = { pattern = "kibana%..*%.com"; icon = " "; highlight = "RenderMarkdownLink"; };
              grafana = { pattern = "grafana%..*%.com"; icon = " "; highlight = "RenderMarkdownLink"; };
              gitlab = { pattern = "gitlab%..*%.de"; icon = " "; highlight = "RenderMarkdownLink"; };
              gitlabmiele = { pattern = "appme%.miele%.com/dvcs"; icon = " "; highlight = "RenderMarkdownLink"; };
            };
            checkbox = {
              checked = { icon = "󰱒"; scope_highlight = "@markup.strikethrough"; };
              unchecked.icon = "󰄱";
              custom.todo.rendered = "󰥔";
            };
          };
        };
      };

      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-colors-xcode";
          src = pkgs.fetchFromGitHub {
            owner = "vismaybhargav"; # https://github.com/lunacookies/vim-colors-xcode/pull/36
            repo = "vim-colors-xcode";
            rev = "0f96f664c200eec54f311e7e0640aebaee6402df";
            hash = "sha256-GV057QK32yBRPD883V8xtS2Lu1wlnADxzuKsU743nYg=";
          };
        })
        pkgs.vimPlugins.bullets-vim
        pkgs.vimPlugins.mattn-calendar-vim
      ];

      opts = {
        mouse = "a";
        number = true;
        relativenumber = true;
        tabstop = 2;
        shiftwidth = 0; # match tabstop
        expandtab = true;
        ignorecase = true;
        smartcase = true;
      };

      extraConfigLua = (builtins.readFile ./theming.lua);
    };
  };
}
