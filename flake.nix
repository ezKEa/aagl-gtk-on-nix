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

    nixpkgs-nonfree = import nixpkgs { config = { allowUnfree = true; }; };

    an-anime-game-launcher-unwrapped = pkgs: pkgs.callPackage ./pkgs/an-anime-game-launcher/unwrapped.nix {};
    an-anime-game-launcher = pkgs: pkgs.callPackage ./pkgs/an-anime-game-launcher/default.nix {
      an-anime-game-launcher-unwrapped = an-anime-game-launcher-unwrapped pkgs;
    };


    unwrapped = an-anime-game-launcher-unwrapped;
    regular = an-anime-game-launcher;
  in {
    nixosModules.default = import ./module/default.nix;
    nixConfig = {
      extra-substituters = ["https://ezkea.cachix.org"];
      extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
    };
    packages = genSystems (system: {
      unwrapped = unwrapped nixpkgs-nonfree;
      default = regular nixpkgs-nonfree;

      an-anime-game-launcher-unwrapped = unwrapped nixpkgs-nonfree;
      an-anime-game-launcher = regular nixpkgs-nonfree;
    });
    overlays.default = _: prev: {
      an-anime-game-launcher-unwrapped = unwrapped prev;
      an-anime-game-launcher = regular prev;
    };
  };
}
