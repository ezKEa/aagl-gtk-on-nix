let
  flake = import ../compat.nix;
in
{
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
    (import ../overlay.nix flake)
  ];
}
