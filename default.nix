let flake = (import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  in fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash; }
) {
  src =  ./.;
}).defaultNix;
in
{
  module = flake.outputs.nixosModules.default;

  inherit (flake.outputs.packages.x86_64-linux)
    an-anime-game-launcher
    an-anime-game-launcher-unwrapped

    the-honkers-railway-launcher
    the-honkers-railway-launcher-unwrapped;
}
