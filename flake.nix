{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat?rev=35bb57c0c8d8b62bbfd284272c928ceb64ddbde9";
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
        anime-borb-launcher = pkgs.callPackage ./pkgs/anime-borb-launcher {inherit wrapAAGL;};
        anime-game-launcher = pkgs.callPackage ./pkgs/anime-game-launcher {inherit wrapAAGL;};
        honkers-railway-launcher = pkgs.callPackage ./pkgs/honkers-railway-launcher {inherit wrapAAGL;};
        honkers-launcher = pkgs.callPackage ./pkgs/honkers-launcher {inherit wrapAAGL;};
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
