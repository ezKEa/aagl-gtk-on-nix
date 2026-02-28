{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.anime-games-launcher;
in {
  imports = [
    (lib.mkRenamedOptionModule ["programs" "an-anime-games-launcher"] ["programs" "anime-games-launcher"])
  ];

  options.programs.anime-games-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable anime-games-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.anime-games-launcher;
      description = ''
        anime-games-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    networking.mihoyo-telemetry.block = true;
  };
}
