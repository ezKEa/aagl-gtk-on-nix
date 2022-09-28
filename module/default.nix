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
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.extraHosts = ''
      # Logging servers (do not remove!)
      0.0.0.0 overseauspider.yuanshen.com
      0.0.0.0 log-upload-os.hoyoverse.com
      0.0.0.0 overseauspider.yuanshen.com

      # Logging servers (do not remove!)
      0.0.0.0 log-upload.mihoyo.com
      0.0.0.0 uspider.yuanshen.com
      0.0.0.0 sg-public-data-api.hoyoverse.com

      # Optional Unity proxy/cdn servers
      0.0.0.0 prd-lender.cdp.internal.unity3d.com
      0.0.0.0 thind-prd-knob.data.ie.unity3d.com
      0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
      0.0.0.0 cdp.cloud.unity3d.com
      0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com
    '';
  };
}
