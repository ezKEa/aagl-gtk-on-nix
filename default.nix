let
  flake = import ./compat.nix;

  overlay = flake.outputs.overlays.default;

  pkgs = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [
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
