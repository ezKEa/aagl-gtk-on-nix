lib: p: with p;
let
  anime-borb-launcher = lib.warn "anime-borb-launcher is deprecated and will be removed in release 24.11"
    p.anime-borb-launcher;
in {
  inherit anime-borb-launcher;

  an-anime-borb-launcher = anime-borb-launcher;
  an-anime-borb-launcher-unwrapped = anime-borb-launcher.unwrapped;

  an-anime-game-launcher = anime-game-launcher;
  an-anime-game-launcher-unwrapped = anime-game-launcher.unwrapped;

  anime-games-launcher-unwrapped = anime-games-launcher.unwrapped;

  the-honkers-railway-launcher = honkers-railway-launcher;
  the-honkers-railway-launcher-unwrapped = honkers-railway-launcher.unwrapped;

  honkers-launcher-unwrapped = honkers-launcher.unwrapped;

  wavey-launcher-unwrapped = wavey-launcher.unwrapped;

  sleepy-launcher-unwrapped = sleepy-launcher.unwrapped;

  unwrapped = anime-game-launcher.unwrapped;
  regular = anime-game-launcher;
}
