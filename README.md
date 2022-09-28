<img src="https://user-images.githubusercontent.com/60455663/192660134-cd43f93e-beef-4c3f-a646-dc6f97ca34d7.png" width="200" />

# aagl-gtk-on-nix
Run [an-anime-game-launcher-gtk](https://github.com/an-anime-team/an-anime-game-launcher-gtk) on Nix/NixOS!

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
# configuration.nix
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz"){ inherit pkgs; };
in
{
  imports = [
    aagl-gtk-on-nix.module
  ];

  programs.an-anime-game-launcher.enable = true;
}
```
If you are not running NixOS, append the below hosts to your /etc/hosts file:
```
0.0.0.0 overseauspider.yuanshen.com
0.0.0.0 log-upload-os.hoyoverse.com

0.0.0.0 log-upload.mihoyo.com
0.0.0.0 uspider.yuanshen.com
0.0.0.0 sg-public-data-api.hoyoverse.com

0.0.0.0 prd-lender.cdp.internal.unity3d.com
0.0.0.0 thind-prd-knob.data.ie.unity3d.com
0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
0.0.0.0 cdp.cloud.unity3d.com
0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com
```
then install through `nix-env` by running
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
