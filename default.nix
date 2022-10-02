{ pkgs ? import <nixpkgs> { } }:
rec {
  module = import ./module;
  an-anime-game-launcher-gtk = pkgs.callPackage ./pkgs/an-anime-game-launcher-gtk { inherit an-anime-game-launcher-gtk-unwrapped; };
  an-anime-game-launcher-gtk-unwrapped = pkgs.callPackage ./pkgs/an-anime-game-launcher-gtk/unwrapped.nix { };
}
