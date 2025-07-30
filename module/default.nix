flake: {
  imports = [
    ./aagl.nix
    ./agl.nix
    ./hrl.nix
    ./hl.nix
    ./waves.nix
    ./sleepy.nix
    ./hosts.nix
    ./version.nix
  ];

  nixpkgs.overlays = [
    flake.outputs.overlays.default
  ];
}
