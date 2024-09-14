final: prev:
let
  mkLauncher = launcher: final.callPackage ./pkgs/${launcher} {
    unwrapped = final.callPackage ./pkgs/${launcher}/unwrapped.nix {};
  };

  launchers = prev.lib.genAttrs [
    "anime-borb-launcher"
    "anime-game-launcher"
    "anime-games-launcher"
    "honkers-launcher"
    "honkers-railway-launcher"
    "sleepy-launcher"
    "wavey-launcher"
  ] mkLauncher;

in launchers // {
  allLaunchers = final.symlinkJoin {
    name = "allLaunchers";
    paths = builtins.attrValues launchers;
  };

  anime-borb-launcher = final.lib.warn "anime-borb-launcher is deprecated and will be removed in release 24.11" launchers.anime-borb-launcher;

  an-anime-borb-launcher = final.anime-borb-launcher;
  an-anime-borb-launcher-unwrapped = final.anime-borb-launcher.unwrapped;

  an-anime-game-launcher = final.anime-game-launcher;
  an-anime-game-launcher-unwrapped = final.anime-game-launcher.unwrapped;

  anime-games-launcher-unwrapped = final.anime-games-launcher.unwrapped;

  the-honkers-railway-launcher = final.honkers-railway-launcher;
  the-honkers-railway-launcher-unwrapped = final.honkers-railway-launcher.unwrapped;

  honkers-launcher-unwrapped = final.honkers-launcher.unwrapped;

  wavey-launcher-unwrapped = final.wavey-launcher.unwrapped;

  sleepy-launcher-unwrapped = final.sleepy-launcher.unwrapped;

  wrapAAGL = final.callPackage ./pkgs/wrapAAGL {};
}
