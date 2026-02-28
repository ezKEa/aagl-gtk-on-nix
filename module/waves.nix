{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.wavey-launcher;
in {
  options.programs.wavey-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable wavey-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.wavey-launcher;
      description = ''
        wavey-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    networking.mihoyo-telemetry.block = true;
  };
}
