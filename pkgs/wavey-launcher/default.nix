{
  lib,
  wrapAAGL,

  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],

  unwrapped
}:
wrapAAGL (self: {
  inherit unwrapped extraPkgs extraLibraries;
  binName = "wavey-launcher";
  packageName = "moe.launcher.Wavey-launcher";
  desktopName = "Wavey Launcher";

  meta = with lib; {
    description = "Wavey launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/wavey-launcher/";
    mainProgram = self.binName;
    license = licenses.gpl3Only;
  };
})
