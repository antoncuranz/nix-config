{ config, lib, pkgs, ... }:

let
  dark-mode-notify = pkgs.swiftPackages.stdenv.mkDerivation {
    name = "dark-mode-notify";

    src = pkgs.fetchFromGitHub {
      owner = "bouk";
      repo = "dark-mode-notify";
      rev = "4d7fe211f81c5b67402fad4bed44995344a260d1";
      sha256 = "LsAQ5v5jgJw7KsJnQ3Mh6+LNj1EMHICMoD5WzF3hRmU=";
    };

    nativeBuildInputs = [
      pkgs.swift
      pkgs.swiftpm
      pkgs.swiftPackages.Foundation
    ];

    phases = [ "unpackPhase" "buildPhase" "installPhase" ];

    preBuild = ''
      mkdir -p $TMP/swiftpm-cache
    '';

    buildPhase = ''
      swift build -c release --disable-sandbox --cache-path $TMP/swiftpm-cache
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp -r .build/release/dark-mode-notify $out/bin/
    '';
  };
  notify-vim = pkgs.writeShellScriptBin "notify-vim" ''
      for pid in $(pgrep vim)
      do
        kill -SIGUSR1 $pid
      done
  '';
in
{
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
             <string>${dark-mode-notify}/bin/dark-mode-notify</string>
             <string>${notify-vim}/bin/notify-vim</string>
          </array>
      </dict>
      </plist>
    '';
  };
}
