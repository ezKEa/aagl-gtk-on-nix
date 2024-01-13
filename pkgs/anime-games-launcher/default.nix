{
  lib,
  wrapAAGL,
  unwrapped
}:
wrapAAGL {
  inherit unwrapped;
  binName = "anime-games-launcher";
  packageName = "moe.launcher.anime-games-launcher";
  desktopName = "Anime Games Launcher";

  meta = with lib; {
    description = "Universal linux launcher for anime games";
    homepage = "https://github.com/an-anime-team/anime-games-launcher/";
    license = licenses.gpl3Only;
  };
}
