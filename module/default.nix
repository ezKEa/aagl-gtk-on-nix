{ config, lib, pkgs, ... }:

with lib;

let
  an-anime-game-launcher = (import ../default.nix { inherit pkgs; }).an-anime-game-launcher;
  cfg = config.programs.an-anime-game-launcher;
in
{
  options.programs.an-anime-game-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable an-anime-game-launcher.
      '';
    };
    package = mkOption {
      type = types.package;
      default = an-anime-game-launcher;
      description = lib.mdDoc ''
        an-anime-game-launcher package to use.
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
