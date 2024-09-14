{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.sleepy-launcher;
in {

  options.programs.sleepy-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable sleepy-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.sleepy-launcher;
      description = lib.mdDoc ''
        sleepy-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    networking.mihoyo-telemetry.block = true;
  };
}
