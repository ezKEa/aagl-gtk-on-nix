overlay: {
  imports = [
    ./aagl.nix
    ./agl.nix
    ./borb.nix
    ./hrl.nix
    ./hl.nix
    ./waves.nix
    ./sleepy.nix
    ./hosts.nix
    ./version.nix
  ];

  nixpkgs.overlays = [ overlay ];
}
