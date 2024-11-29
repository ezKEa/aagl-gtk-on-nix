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
  aagl = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
  # Or, if you follow Nixpkgs release 24.11:
  # aagl = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/release-24.11.tar.gz");
in
{
  imports = [
    aagl.module
  ];

  nix.settings = aagl.nixConfig; # Set up Cachix
  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
  programs.wavey-launcher.enable = true;
  programs.sleepy-launcher.enable = true;
}
```

By default, the NixOS module adds an overlay to `nixpkgs.overlays`, and the launchers will be built against your `pkgs` instance. If you want to use the launchers directly from this flake's outputs, use the `.package` options:
```nix
# configuration.nix
{ config, pkgs, inputs, }:
let
  aagl = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{

  programs.anime-game-launcher = {
    enable = true;
    # package = aagl.anime-game-launcher; # for non-flakes
    # package = inputs.aagl.packages.x86_64-linux.anime-game-launcher; # for flakes
  };
}
```

### Flakes
Both the Cachix config and NixOS module are accessible via Flakes as well:
```nix
{
  inputs = {
    # Other inputs
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # Or, if you follow Nixkgs release 24.11:
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-24.11";
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
          programs.honkers-railway-launcher.enable = true;
          programs.honkers-launcher.enable = true;
          programs.wavey-launcher.enable = true;
          programs.sleepy-launcher.enable = true;
        }
      ];
    };
  };
}
```

## Usage
After installation, you can start the launcher by running `anime-game-launcher`, `honkers-railway-launcher`, or `honkers-launcher`. Have fun!
