{
  lib,
  wrapAAGL,

  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],

  unwrapped
}:
wrapAAGL (self: {
  inherit unwrapped extraPkgs extraLibraries;
  binName = "anime-games-launcher";
  packageName = "moe.launcher.anime-games-launcher";
  desktopName = "Anime Games Launcher";

  meta = with lib; {
    description = "Universal linux launcher for anime games";
    homepage = "https://github.com/an-anime-team/anime-games-launcher/";
    mainProgram = self.binName;
    license = licenses.gpl3Only;
  };
})
