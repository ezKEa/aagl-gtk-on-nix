{ pkgs ? import <nixpkgs> { } }:
let
  sources = import ./nix/sources.nix { };
in
rec {
  an-anime-game-launcher-gtk = pkgs.callPackage ./pkgs/an-anime-game-launcher-gtk { inherit an-anime-game-launcher-gtk-unwrapped; };
  an-anime-game-launcher-gtk-unwrapped = pkgs.callPackage ./pkgs/an-anime-game-launcher-gtk/unwrapped.nix { libadwaita = libadwaita12; };
  libadwaita12 = (import sources.nixpkgs { }).libadwaita;
}
