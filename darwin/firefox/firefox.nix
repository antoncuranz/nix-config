{ config, lib, pkgs, ... }:

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
      # DisableFirefoxAccounts = true;
      # DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"

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

      Preferences = {
        "identity.sync.tokenserver.uri" = { Value = "https://ffsync.cura.nz/1.0/sync/1.5"; Status = "locked"; }; # TODO: not working
        "browser.uiCustomization.state" = { Value = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_testpilot-containers-browser-action\",\"sponsorblocker_ajay_app-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\",\"_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"unified-extensions-button\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"_testpilot-containers-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action\",\"developer-button\"],\"dirtyAreaCache\":[\"unified-extensions-area\",\"nav-bar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":20,\"newElementCount\":4}"; };
        "browser.warnOnQuit" = lock-false;
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
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
        };
      };
    };
  };
}
