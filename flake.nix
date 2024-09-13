rec {
  nixConfig = {
    extra-substituters = ["https://ezkea.cachix.org"];
    extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }: let
    genSystems = nixpkgs.lib.genAttrs [
      # Supported OSes
      "x86_64-linux"
    ];

    pkgsFor = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
      overlay = self.overlays.default pkgs pkgs;
    in overlay // {
      allLaunchers = pkgs.symlinkJoin {
        name = "allLaunchers";
        paths = builtins.filter pkgs.lib.isDerivation (builtins.attrValues overlay);
      };
    };
  in {
    inherit nixConfig;
    overlays.default = import ./overlay.nix;
    nixosModules.default = import ./module (self.overlays.default);
    packages = genSystems pkgsFor;
  };
}
