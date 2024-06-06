{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    plugins = {
      commentary.enable = true;
      surround.enable = true;
      tmux-navigator.enable = true;
      nvim-tree.enable = true;
      nix.enable = true;
      treesitter.enable = true;

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
    };

    extraConfigLua = (builtins.readFile ./theming.lua);
  };

  environment.userLaunchAgents."ke.bou.dark-mode-notify.plist" = {
    enable = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>ke.bou.dark-mode-notify</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
             <string>/Users/ant0n/macOS_darkMode/dark-mode-notify.swift</string>
             <string>/Users/ant0n/macOS_darkMode/onDarkModeChanged.sh</string>
          </array>
      </dict>
      </plist>
    '';
  };
}
