{
  lib,
  wrapAAGL,
  unwrapped
}:
wrapAAGL rec {
  inherit unwrapped;
  binName = "anime-game-launcher";
  packageName = "moe.launcher.an-anime-game-launcher";
  desktopName = "An Anime Game Launcher";

  meta = with lib; {
    description = "An Anime Game launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/an-anime-game-launcher/";
    mainProgram = binName;
    license = licenses.gpl3Only;
  };
}
