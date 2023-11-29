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

    nixpkgs-nonfree = system:
      import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };

    packages = pkgs: let
      alias = import ./pkgs/alias.nix {inherit packages;};
      wrapAAGL = (pkgs.callPackage ./pkgs/wrapAAGL {}).override;
      packages = {
        anime-borb-launcher = pkgs.callPackage ./pkgs/anime-borb-launcher {
          inherit wrapAAGL;
          unwrapped = pkgs.callPackage ./pkgs/anime-borb-launcher/unwrapped.nix {};
        };
        anime-game-launcher = pkgs.callPackage ./pkgs/anime-game-launcher {
          inherit wrapAAGL;
          unwrapped = pkgs.callPackage ./pkgs/anime-game-launcher/unwrapped.nix {};
        };
        honkers-railway-launcher = pkgs.callPackage ./pkgs/honkers-railway-launcher {
          inherit wrapAAGL;
          unwrapped = pkgs.callPackage ./pkgs/honkers-railway-launcher/unwrapped.nix {};
        };
        honkers-launcher = pkgs.callPackage ./pkgs/honkers-launcher {
          inherit wrapAAGL;
          unwrapped = pkgs.callPackage ./pkgs/honkers-launcher/unwrapped.nix {};
        };
      };
    in
      packages // alias;
  in {
    nixosModules.default = import ./module/default.nix (packages (nixpkgs-nonfree "x86_64-linux"));
    nixConfig = {
      extra-substituters = ["https://ezkea.cachix.org"];
      extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
    };
    packages = genSystems (system: let pkgs = nixpkgs-nonfree system; in packages pkgs);
    overlays.default = _: prev: builtins.removeAttrs (packages prev) ["unwrapped" "regular"];
  };
}
