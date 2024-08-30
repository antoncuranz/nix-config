{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.firefox;
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  policies = {
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;

      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
in
{
  options.firefox = {
    enable = lib.mkEnableOption "enable firefox";
    user = lib.mkOption {
      type = lib.types.str;
      default = "ant0n";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [ 
      inputs.arkenfox.hmModules.default 
    ];
    environment.systemPackages = with pkgs; [
      (firefox-bin.overrideAttrs (prevAttrs: {
        postInstall = ''
          folder="$out/Applications/Firefox.app/Contents/Resources/distribution"
          mkdir -p "$folder"
          echo '${builtins.toJSON policies}' > "$folder/policies.json"
        '';
      }))
    ];

    home-manager.users."${cfg.user}".programs.firefox = {
      enable = true;
      arkenfox.enable = true;
      package = null;
      profiles = {
        default = {
          name = "nix-config";
          isDefault = true;
          search = {
            force = true;
            default = "DuckDuckGo";
            order = [ "DuckDuckGo" "Google" ];
          };
          arkenfox = {
            enable = true;
            "0000".enable = true;
            "0100" = { # startup
              enable = true;
              # set about:home as homepage/newtabpage
              "0102".enable = false;
              "0103".enable = false;
              "0104".enable = false;
            };
            "0200".enable = false; # geolocation
            "0300".enable = true; # quieter fox
            "0400".enable = true; # safe browsing
            "0600".enable = true; # implicit outbound
            "0700".enable = true; # dns / doh
            "0800".enable = false; # search bar
            "1000".enable = true; # disk avoidance
            "1200".enable = true; # https
            "1600".enable = true; # referers
            "1700".enable = true; # containers
            "2000".enable = true; # plugins / media
            "2400".enable = true; # dom
            "2600" = { # misc
              enable = true;
              # do not ask for download location
              "2651".enable = false;
              "2652".enable = false;
            };
            "2700".enable = true; # enhanced tracking protection
            "2800".enable = false; # shutdown sanitizing
            "4500".enable = false; # letterboxing
            "6000".enable = true; # don't touch
            "9000".enable = true; # non-project related
          };
          settings = {
            "identity.sync.tokenserver.uri" = "https://ffsync.cura.nz/1.0/sync/1.5";
            "browser.translations.neverTranslateLanguages" = "de";
            "browser.warnOnQuit" = false;
            "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_testpilot-containers-browser-action\",\"sponsorblocker_ajay_app-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\",\"_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"unified-extensions-button\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"_testpilot-containers-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action\",\"developer-button\"],\"dirtyAreaCache\":[\"unified-extensions-area\",\"nav-bar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":20,\"newElementCount\":4}";
          };
        };
      };
    };

    # 1Password integration does not work if symlinked
    system.activationScripts.applications.text = ''
      rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete /Applications/Nix\ Apps/Firefox.app /Applications
    '';
  };
}
