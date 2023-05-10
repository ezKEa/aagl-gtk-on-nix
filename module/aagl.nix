{ config, lib, pkgs, ... }:

with lib;

let
  an-anime-game-launcher = (import ../default.nix).an-anime-game-launcher;
  cfg = config.programs.an-anime-game-launcher;
in
{
  options.programs.an-anime-game-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable an-anime-game-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = an-anime-game-launcher;
      description = lib.mdDoc ''
        an-anime-game-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.mihoyo-telemetry.block = true;
  };
}
