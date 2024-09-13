{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.honkers-railway-launcher;
in {
  imports = [
    (lib.mkRenamedOptionModule ["programs" "the-honkers-railway-launcher"] ["programs" "honkers-railway-launcher"])
  ];

  options.programs.honkers-railway-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable honkers-railway-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.honkers-railway-launcher;
      description = lib.mdDoc ''
        honkers-railway-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    networking.mihoyo-telemetry.block = true;
  };
}
