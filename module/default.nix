packages: {...}: {
  imports = [
    (import ./aagl.nix packages)
    (import ./agl.nix packages)
    (import ./borb.nix packages)
    (import ./hrl.nix packages)
    (import ./hl.nix packages)
    ./hosts.nix
  ];
}
