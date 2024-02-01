{
  lib,
  wrapAAGL,
  unwrapped
}:
wrapAAGL rec {
  inherit unwrapped;
  binName = "anime-borb-launcher";
  packageName = "moe.launcher.an-anime-borb-launcher";
  desktopName = "Punishing: Gray Raven Launcher";

  meta = with lib; {
    description = "Punishing: Gray Raven launcher for Linux";
    homepage = "https://github.com/an-anime-team/an-anime-borb-launcher";
    mainProgram = binName;
    license = licenses.gpl3Only;
  };
}
