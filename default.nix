{ pkgs ? import <nixpkgs> { } }:
with pkgs;
rec {
  module = import ./module;

  an-anime-game-launcher = callPackage ./pkgs/an-anime-game-launcher { inherit an-anime-game-launcher-unwrapped; };
  an-anime-game-launcher-unwrapped = callPackage ./pkgs/an-anime-game-launcher/unwrapped.nix { };

}
