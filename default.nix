{ pkgs ? import <nixpkgs> { } }:

rec {
  an-anime-game-launcher-gtk = pkgs.callPackage ./pkgs/an-anime-game-launcher-gtk { inherit an-anime-game-launcher-gtk-unwrapped; };
  an-anime-game-launcher-gtk-unwrapped = pkgs.callPackage ./pkgs/an-anime-game-launcher-gtk/unwrapped.nix { };
}
