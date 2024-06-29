{
  lib,
  wrapAAGL,
  unwrapped
}:
wrapAAGL rec {
  inherit unwrapped;
  binName = "wavey-launcher";
  packageName = "moe.launcher.Wavey-launcher";
  desktopName = "Wavey Launcher";

  meta = with lib; {
    description = "Wavey launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/wavey-launcher/";
    mainProgram = binName;
    license = licenses.gpl3Only;
  };
}
