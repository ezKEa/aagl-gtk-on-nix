{ config, lib, pkgs, ... }:

with lib;

let
  the-honkers-railway-launcher = (import ../default.nix).the-honkers-railway-launcher;
  cfg = config.programs.the-honkers-railway-launcher;
in
{
  options.programs.the-honkers-railway-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable the-honkers-railway-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = the-honkers-railway-launcher;
      description = lib.mdDoc ''
        the-honkers-railway-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.mihoyo-telemetry.block = true;
  };
}
