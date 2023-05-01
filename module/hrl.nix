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
    networking.hosts = {
      "0.0.0.0" = [
        "overseauspider.yuanshen.com"
        "log-upload-os.hoyoverse.com"
        "log-upload-os.mihoyo.com"

        "log-upload.mihoyo.com"
        "devlog-upload.mihoyo.com"
        "uspider.yuanshen.com"
        "sg-public-data-api.hoyoverse.com"

        "prd-lender.cdp.internal.unity3d.com"
        "thind-prd-knob.data.ie.unity3d.com"
        "thind-gke-usc.prd.data.corp.unity3d.com"
        "cdp.cloud.unity3d.com"
        "remote-config-proxy-prd.uca.cloud.unity3d.com"
      ];
    };
  };
}
