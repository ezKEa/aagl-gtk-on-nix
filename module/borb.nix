{
  config,
  lib,
  ...
}:
with lib; let
  anime-borb-launcher = (import ../default.nix).anime-borb-launcher;
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
      default = anime-borb-launcher;
      description = lib.mdDoc ''
        anime-borb-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
