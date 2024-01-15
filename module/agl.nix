packages:
{
  config,
  lib,
  ...
}:
with lib; let
  anime-games-launcher = packages.anime-games-launcher;
  cfg = config.programs.anime-games-launcher;
in {
  imports = [
    (lib.mkRenamedOptionModule ["programs" "an-anime-games-launcher"] ["programs" "anime-games-launcher"])
  ];

  options.programs.anime-games-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable anime-games-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = anime-games-launcher;
      description = lib.mdDoc ''
        anime-games-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    networking.mihoyo-telemetry.block = true;
  };
}
