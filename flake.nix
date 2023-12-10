{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = {nixpkgs, ...}: let
    genSystems = nixpkgs.lib.genAttrs [
      # Supported OSes
      "x86_64-linux"
    ];

    nixpkgs-nonfree = system: import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    packages = pkgs: let
      alias = import ./pkgs/alias.nix launchers;
      wrapAAGL = (pkgs.callPackage ./pkgs/wrapAAGL {}).override;
      mkLauncher = (launcher: {
        "${launcher}" = pkgs.callPackage ./pkgs/${launcher} {
          inherit wrapAAGL;
          unwrapped = pkgs.callPackage ./pkgs/${launcher}/unwrapped.nix {};
        };
      });
      launchers = builtins.foldl' (a: b: a // b) {} (map mkLauncher [
        "anime-borb-launcher"
        "anime-game-launcher"
        "honkers-railway-launcher"
        "honkers-launcher"
      ]);
    in launchers // alias;
  in {
    nixosModules.default = import ./module (packages (nixpkgs-nonfree "x86_64-linux"));
    nixConfig = {
      extra-substituters = ["https://ezkea.cachix.org"];
      extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
    };
    packages = genSystems (system: let pkgs = nixpkgs-nonfree system; in packages pkgs);
    overlays.default = _: prev: builtins.removeAttrs (packages prev) ["unwrapped" "regular"];
  };
}
