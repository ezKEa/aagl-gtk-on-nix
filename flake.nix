{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs [
      # Supported OSes
      "x86_64-linux"
    ];

    nixpkgs-nonfree = system: import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    packages = pkgs: rec {
      an-anime-game-launcher-unwrapped = pkgs.callPackage ./pkgs/an-anime-game-launcher/unwrapped.nix {};
      an-anime-game-launcher = pkgs.callPackage ./pkgs/an-anime-game-launcher/default.nix {
        inherit an-anime-game-launcher-unwrapped;
      };

      the-honkers-railway-launcher = pkgs.callPackage ./pkgs/the-honkers-railway-launcher {
        inherit the-honkers-railway-launcher-unwrapped;
      };

      the-honkers-railway-launcher-unwrapped = pkgs.callPackage ./pkgs/the-honkers-railway-launcher/unwrapped.nix {};

      honkers-launcher = pkgs.callPackage ./pkgs/honkers-launcher/default.nix {
        inherit honkers-launcher-unwrapped;
      };

      honkers-launcher-unwrapped = pkgs.callPackage ./pkgs/honkers-launcher/unwrapped.nix {};

      unwrapped = an-anime-game-launcher-unwrapped;
      regular = an-anime-game-launcher;
    };
  in {
    nixosModules.default = import ./module/default.nix;
    nixConfig = {
      extra-substituters = ["https://ezkea.cachix.org"];
      extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
    };
    packages = genSystems (system: let pkgs = nixpkgs-nonfree system; in packages pkgs );
    overlays.default = _: prev: builtins.removeAttrs (packages prev) [ "unwrapped" "regular" ];
  };
}
