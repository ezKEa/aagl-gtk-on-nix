# aagl-gtk-on-nix
Run [an-anime-game-launcher-gtk](https://gitlab.com/an-anime-team/alternatives/an-anime-game-launcher-gtk) on Nix/NixOS!

## Installation and Usage

Before we start, it's recommended to set up Cachix so you won't need to build the launcher yourself:
```sh
$ nix-shell -p cachix --run cachix use ezkea
```
Alternatively, you can add the Cachix declaratively:
```nix
# configuration.nix
{
  nix.settings = {
    substituters = [ "https://ezkea.cachix.org" ];
    trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };
}
```
To install the launcher on NixOS, add the following to `configuration.nix`:
```nix
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz"){ inherit pkgs; };
in
{
  # Block telementry hosts
  networking.extraHosts = ''
    0.0.0.0 overseauspider.yuanshen.com
    0.0.0.0 log-upload-os.hoyoverse.com

    0.0.0.0 log-upload.mihoyo.com
    0.0.0.0 uspider.yuanshen.com

    0.0.0.0 prd-lender.cdp.internal.unity3d.com
    0.0.0.0 thind-prd-knob.data.ie.unity3d.com
    0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
    0.0.0.0 cdp.cloud.unity3d.com
    0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com
  '';

  # Install launcher
  environment.systemPackages = [
    aagl-gtk-on-nix.an-anime-game-launcher-gtk
  ];
}
```
If you are not running NixOS, append the above hosts to your /etc/hosts file, and install through `nix-env` by running
```sh
$ nix-env -f https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz -iA an-anime-game-launcher-gtk
```
Alternatively, you can install the launcher using [home-manager](https://github.com/nix-community/home-manager).
```nix
# home.nix
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz"){ inherit pkgs; };
in
{
  home.packages = [ aagl-gtk-on-nix.an-anime-game-launcher-gtk ];
}
```
After installation, you can start the launcher by running `anime-game-launcher`. Have fun!
