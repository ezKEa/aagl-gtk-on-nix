{
  lib,
  wrapAAGL,
  unwrapped
}:
wrapAAGL {
  inherit unwrapped;
  binName = "honkers-launcher";
  packageName = "moe.launcher.honkers-launcher";
  desktopName = "Honkers Launcher";

  meta = with lib; {
    description = "Honkers launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/honkers-launcher/";
    license = licenses.gpl3Only;
  };
}
