rec {
  nixConfig = {
    extra-substituters = ["https://ezkea.cachix.org"];
    extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }: let
    genSystems = nixpkgs.lib.genAttrs [
      # Supported OSes
      "x86_64-linux"
    ];

    nixpkgs-nonfree = system: import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    packages = pkgs: with pkgs; let
      alias = import ./pkgs/alias.nix pkgs.lib launchers;
      final = launchers // alias;
      launchers = let
        mkLauncher = launcher: {
          "${launcher}" = callPackage ./pkgs/${launcher} {
            wrapAAGL = callPackage ./pkgs/wrapAAGL;
            unwrapped = callPackage ./pkgs/${launcher}/unwrapped.nix { };
          };
        };
      in builtins.foldl' (a: b: a // b) {} (map mkLauncher [
        "anime-borb-launcher"
        "anime-game-launcher"
        "anime-games-launcher"
        "honkers-launcher"
        "honkers-railway-launcher"
        "sleepy-launcher"
        "wavey-launcher"
      ]);
    in final // {
      allLaunchers = symlinkJoin {
        name = "allLaunchers";
        paths = builtins.attrValues final;
      };
      # return this package set with a given nixpkgs instance
      withNixpkgs = p: packages p;
    };
  in {
    inherit nixConfig;
    nixosModules.default = import ./module (packages (nixpkgs-nonfree "x86_64-linux"));
    packages = genSystems (system: let pkgs = nixpkgs-nonfree system; in packages pkgs);
    overlays.default = _: prev: builtins.removeAttrs (packages prev) ["unwrapped" "regular"];
  };
}
