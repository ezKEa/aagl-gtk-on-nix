{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs [
      # Supported OSes
      "x86_64-linux"
    ];
    unwrapped = pkgs: pkgs.callPackage ./pkgs/an-anime-game-launcher/unwrapped.nix {};
    regular = pkgs: pkgs.callPackage ./pkgs/an-anime-game-launcher/default.nix {an-anime-game-launcher-unwrapped = unwrapped pkgs;};
  in {
    nixosModules.default = import ./module/default.nix;
    nixConfig = {
      extra-substituters = ["https://ezkea.cachix.org"];
      extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
    };
    packages = genSystems (system: {
      unwrapped = unwrapped nixpkgs.legacyPackages.${system};
      default = regular nixpkgs.legacyPackages.${system};
    });
    overlays.default = _: prev: {
      an-anime-game-launcher-unwrapped = unwrapped prev;
      an-anime-game-launcher = regular prev;
    };
  };
}
