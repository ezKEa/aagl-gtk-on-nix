{
  lib,
  wrapAAGL,
  unwrapped
}:
wrapAAGL rec {
  inherit unwrapped;
  binName = "sleepy-launcher";
  packageName = "moe.launcher.sleepy-launcher";
  desktopName = "Sleepy Launcher";

  meta = with lib; {
    description = "Sleepy launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/sleepy-launcher/";
    mainProgram = binName;
    license = licenses.gpl3Only;
  };
}
