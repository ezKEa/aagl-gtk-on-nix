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

  # Get the pinned nixpkgs to act as the default nixpkgs.
  nixpkgs-nonfree = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  outputs = pkgs: let
    packages = flake.outputs.packages.x86_64-linux.withNixpkgs pkgs;
  in packages // {
    module = import ./module packages;
    overlay = flake.outputs.overlays.default;
    # Provide a mechanism for non-flake users to override nixpkgs.
    # nixos unstable environment is often incompatible with stable nixpkgs runtimes.
    withNixpkgs = p: outputs p;
  };
in outputs nixpkgs-nonfree
