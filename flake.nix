rec {
  nixConfig = {
    extra-substituters = ["https://ezkea.cachix.org"];
    extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    lib = nixpkgs.lib;

    genSystems = lib.genAttrs [
      # Supported OSes
      "x86_64-linux"
    ];

    pkgsFor = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      overlay = lib.fix (lib.flip self.overlays.default pkgs);
    in overlay;
  in {
    inherit nixConfig;

    overlays.default = (import ./overlay.nix) { inherit rust-overlay; };

    nixosModules.default = {
      imports = [ ./module ];
      nixpkgs.overlays = [ self.overlays.default ];
    };

    packages = genSystems pkgsFor;
  };
}
