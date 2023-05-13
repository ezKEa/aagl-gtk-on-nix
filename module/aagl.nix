{ config, lib, pkgs, ... }:

with lib;

let
  anime-game-launcher = (import ../default.nix).anime-game-launcher;
  cfg = config.programs.anime-game-launcher;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "programs" "an-anime-game-launcher" ] [ "programs" "anime-game-launcher" ] )
  ];

  options.programs.anime-game-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable anime-game-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = anime-game-launcher;
      description = lib.mdDoc ''
        anime-game-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.mihoyo-telemetry.block = true;
  };
}
