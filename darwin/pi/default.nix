{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.pi;

  frontend-slides = pkgs.fetchFromGitHub {
    owner = "joemccann";
    repo = "pi-exa";
    rev = "efbfd05100547ed435f94d4bba1e77919cf9e681";
    hash = "sha256-egzx2BXEbyiOr0F7iuPa8f3QXjkCOvWl4V3GTsA1vyk=";
  };
in
{
  imports = [ inputs.pi.nixosModules.default ];

  options.pi.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable pi";
  };

  config = lib.mkIf cfg.enable {
    programs.pi.coding-agent = {
      enable = true;
      package = inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.coding-agent;

      rules = builtins.readFile ./AGENTS.md;

      skills = [
        ./skills/rpi-research
        ./skills/rpi-plan
        ./skills/rpi-implement

        "${frontend-slides}/plugins/frontend-slides/skills/frontend-slides"
      ];

      # extensions = [
      #   ./extensions/wakatime.ts
      #   # "${pi-thinking-steps}"
      #   "${pi-fff}/packages/pi-fff"
      #   "${pi-usage-extension}/usage-extension"
      #   "${pi-openai}"
      #   "${pi-exa}/extensions/index.ts"
      # ];
    };
  };
}
