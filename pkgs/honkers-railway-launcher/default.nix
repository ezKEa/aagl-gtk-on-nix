{
  lib,
  wrapAAGL,
  unwrapped
}:
wrapAAGL rec {
  inherit unwrapped;
  binName = "honkers-railway-launcher";
  packageName = "moe.launcher.the-honkers-railway-launcher";
  desktopName = "The Honkers Railway Launcher";

  meta = with lib; {
    description = "The Honkers Railway launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/the-honkers-railway-launcher/";
    mainProgram = binName;
    license = licenses.gpl3Only;
  };
}
