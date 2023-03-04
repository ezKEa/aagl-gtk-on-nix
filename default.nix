{ pkgs ? import <nixpkgs> { } }:
with pkgs;
rec {
  module = import ./module;

  an-anime-game-launcher = callPackage ./pkgs/an-anime-game-launcher { inherit an-anime-game-launcher-unwrapped; };
  an-anime-game-launcher-unwrapped = callPackage ./pkgs/an-anime-game-launcher/unwrapped.nix { };

  an-anime-game-launcher-git = callPackage ./pkgs/an-anime-game-launcher {
    an-anime-game-launcher-unwrapped = an-anime-game-launcher-unwrapped-git;
  };
  an-anime-game-launcher-unwrapped-git = callPackage ./pkgs/an-anime-game-launcher/latest.nix {
    inherit an-anime-game-launcher-unwrapped;
  };

  an-anime-game-launcher-gtk = an-anime-game-launcher;
  an-anime-game-launcher-gtk-unwrapped = an-anime-game-launcher-unwrapped;

  an-anime-game-launcher-gtk-git = an-anime-game-launcher-git;
  an-anime-game-launcher-gtk-unwrapped-git = an-anime-game-launcher-unwrapped-git;
}
