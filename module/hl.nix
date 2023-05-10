{ config, lib, pkgs, ... }:

with lib;

let
  honkers-launcher = (import ../default.nix).honkers-launcher;
  cfg = config.programs.honkers-launcher;
in
{
  options.programs.honkers-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable honkers-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = honkers-launcher;
      description = lib.mdDoc ''
        honkers-launcher package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.mihoyo-telemetry.block = true;
  };
}
