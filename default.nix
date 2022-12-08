{ pkgs ? import <nixpkgs> { } }:
with pkgs;
rec {
  module = import ./module;

  an-anime-game-launcher-gtk = callPackage ./pkgs/an-anime-game-launcher-gtk { inherit an-anime-game-launcher-gtk-unwrapped; };
  an-anime-game-launcher-gtk-unwrapped = callPackage ./pkgs/an-anime-game-launcher-gtk/unwrapped.nix { };

  an-anime-game-launcher-gtk-git = callPackage ./pkgs/an-anime-game-launcher-gtk {
    an-anime-game-launcher-gtk-unwrapped = an-anime-game-launcher-gtk-unwrapped-git;
  };
  an-anime-game-launcher-gtk-unwrapped-git = callPackage ./pkgs/an-anime-game-launcher-gtk/latest.nix {
    inherit an-anime-game-launcher-gtk-unwrapped;
  };
}
