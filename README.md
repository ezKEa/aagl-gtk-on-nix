<img src="https://user-images.githubusercontent.com/60455663/192660134-cd43f93e-beef-4c3f-a646-dc6f97ca34d7.png" width="200" />

# aagl-gtk-on-nix
Run [an-anime-team](https://github.com/an-anime-team/) launchers on Nix/NixOS!

## Cachix
It's recommended to set up Cachix so you won't need to build the launchers yourself:
```sh
$ nix-shell -p cachix --run "cachix use ezkea"
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

## Installation
To install the launchers on NixOS, refer to the following example module:
```nix
# configuration.nix
{ config, pkgs, ... }:
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
  # aaglPkgs = aagl-gtk-on-nix.withNixpkgs pkgs
in
{
  imports = [
    aagl-gtk-on-nix.module
    # aaglPkgs.module
  ];

  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.anime-borb-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
}
```

The `withNixpkgs` function allows you change the nixpkgs instance which this package set is built against, similarly to to the `inputs.nixpkgs.follows` syntax in flakes. If you use NixOS on the unstable branch, it's likely that your environment is incompatible with the runtime dependencies provided by the flake-pinned nixpkgs, so you probably want to use this.

### Flakes
Both the Cachix config and NixOS module are accessible via Flakes as well:
```nix
{
  inputs = {
    # Other inputs
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs"; # Name of nixpkgs input you want to use
  };

  outputs = { self, nixpkgs, aagl, ... }: {
    nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Your system modules
        {
          imports = [ aagl.nixosModules.default ];
          nix.settings = aagl.nixConfig; # Set up Cachix
          programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
          programs.anime-games-launcher.enable = true;
          programs.anime-borb-launcher.enable = true;
          programs.honkers-railway-launcher.enable = true;
          programs.honkers-launcher.enable = true;
        }
      ];
    };
  };
}
```

### Home Manager
You can also install the launchers using [home-manager](https://github.com/nix-community/home-manager).
```nix
# home.nix
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  home.packages = [
    aagl-gtk-on-nix.anime-game-launcher
    aagl-gtk-on-nix.anime-borb-launcher
    aagl-gtk-on-nix.honkers-railway-launcher
    aagl-gtk-on-nix.honkers-launcher
  ];
}
```

### Non-NixOS
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
$ nix-env -f https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz -iA anime-game-launcher
```

## Usage
After installation, you can start the launcher by running `anime-game-launcher`, `honkers-railway-launcher`, or `honkers-launcher`. Have fun!
