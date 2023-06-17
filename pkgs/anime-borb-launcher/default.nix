{
  lib,
  callPackage,
  wrapAAGL,
  unwrapped ? callPackage ./unwrapped.nix {},
}:
wrapAAGL {
  inherit unwrapped;
  binName = "anime-borb-launcher";
  packageName = "moe.launcher.an-anime-borb-launcher";
  desktopName = "Punishing: Gray Raven Launcher";

  meta = with lib; {
    description = "Punishing: Gray Raven launcher for Linux";
    homepage = "https://github.com/an-anime-team/an-anime-borb-launcher";
    license = licenses.gpl3Only;
  };
}
