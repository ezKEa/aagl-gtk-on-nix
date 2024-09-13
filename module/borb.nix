{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.anime-borb-launcher;
in {
  imports = [
    (lib.mkAliasOptionModule ["programs" "an-anime-borb-launcher"] ["programs" "anime-borb-launcher"])
  ];

  options.programs.anime-borb-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable anime-borb-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.anime-borb-launcher;
      description = lib.mdDoc ''
        anime-borb-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
