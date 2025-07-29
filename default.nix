let
  flake = (import (
    let
      lock = builtins.fromJSON (builtins.readFile ./flake.lock);
    in
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
    ) {
      src = ./.;
    }
  ).defaultNix;

  overlay = flake.outputs.overlays.default;

  pkgs = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [
      (import flake.inputs.rust-overlay)
      overlay
    ];
  };

  outputs = let
    packages = overlay pkgs pkgs;
  in packages // {
    inherit overlay;
    inherit (flake.outputs) nixConfig;
    module = import ./module;
  };
in outputs
