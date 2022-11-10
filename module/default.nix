{ config, lib, pkgs, ... }:

with lib;

let
  an-anime-game-launcher-gtk = (import ../default.nix { inherit pkgs; }).an-anime-game-launcher-gtk;
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
      default = an-anime-game-launcher-gtk;
      description = lib.mdDoc ''
        an-anime-game-launcher package to use.
      '';
    };
    serverAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Game server host to connect to.
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
    } // attrsets.optionalAttrs (builtins.isString cfg.serverAddress) {
      "${cfg.serverAddress}" = [
        "dispatchosglobal.yuanshen.com"
        "dispatchcnglobal.yuanshen.com"
        "osusadispatch.yuanshen.com"
        "oseurodispatch.yuanshen.com"
        "osasiadispatch.yuanshen.com"

        "hk4e-api-os-static.mihoyo.com"
        "hk4e-api-static.mihoyo.com"
        "hk4e-api-os.mihoyo.com"
        "hk4e-api.mihoyo.com"
        "hk4e-sdk-os.mihoyo.com"
        "hk4e-sdk.mihoyo.com"

        "account.mihoyo.com"
        "api-os-takumi.mihoyo.com"
        "api-takumi.mihoyo.com"
        "sdk-os-static.mihoyo.com"
        "sdk-static.mihoyo.com"
        "webstatic-sea.mihoyo.com"
        "webstatic.mihoyo.com"
        "uploadstatic-sea.mihoyo.com"
        "uploadstatic.mihoyo.com"

        "api-os-takumi.hoyoverse.com"
        "sdk-os-static.hoyoverse.com"
        "sdk-os.hoyoverse.com"
        "webstatic-sea.hoyoverse.com"
        "uploadstatic-sea.hoyoverse.com"
        "api-takumi.hoyoverse.com"
        "sdk-static.hoyoverse.com"
        "sdk.hoyoverse.com"
        "webstatic.hoyoverse.com"
        "uploadstatic.hoyoverse.com"
        "account.hoyoverse.com"
        "api-account-os.hoyoverse.com"
        "api-account.hoyoverse.com"

        "hk4e-api-os.hoyoverse.com"
        "hk4e-api-os-static.hoyoverse.com"
        "hk4e-sdk-os.hoyoverse.com"
        "hk4e-sdk-os-static.hoyoverse.com"
        "hk4e-api.hoyoverse.com"
        "hk4e-api-static.hoyoverse.com"
        "hk4e-sdk.hoyoverse.com"
        "hk4e-sdk-static.hoyoverse.com"
      ];
    };
  };
}
