rec {
  nixConfig = {
    extra-substituters = ["https://ezkea.cachix.org"];
    extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
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
        overlays = [
          (import self.inputs.rust-overlay)
          self.overlays.default
        ];
      };
      overlay = self.overlays.default pkgs pkgs;
    in overlay;
  in {
    inherit nixConfig;
    overlays.default = import ./overlay.nix;
    nixosModules.default = import ./module;
    packages = genSystems pkgsFor;
  };
}
