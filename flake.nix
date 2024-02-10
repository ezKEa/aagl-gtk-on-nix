rec {
  nixConfig = {
    extra-substituters = ["https://ezkea.cachix.org"];
    extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
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
      alias = import ./pkgs/alias.nix launchers;
      wrapAAGL = (callPackage ./pkgs/wrapAAGL {}).override;
      launchers = let
        mkLauncher = launcher: callPackage ./pkgs/${launcher} {
          inherit wrapAAGL;
          unwrapped = callPackage ./pkgs/${launcher}/unwrapped.nix {};
        };
      in lib.genAttrs [
        "anime-borb-launcher"
        "anime-game-launcher"
        "anime-games-launcher"
        "honkers-railway-launcher"
        "honkers-launcher"
      ] mkLauncher;
    in launchers // alias // {
      allLaunchers = symlinkJoin {
        name = "allLaunchers";
        paths = builtins.attrValues launchers;
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
