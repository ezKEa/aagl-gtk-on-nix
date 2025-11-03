{
  lib,
  wrapAAGL,

  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],

  unwrapped
}:
wrapAAGL (self: {
  inherit unwrapped extraPkgs extraLibraries;
  binName = "anime-game-launcher";
  packageName = "moe.launcher.an-anime-game-launcher";
  desktopName = "An Anime Game Launcher";

  meta = with lib; {
    description = "An Anime Game launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/an-anime-game-launcher/";
    mainProgram = self.binName;
    license = licenses.gpl3Only;
  };
})
