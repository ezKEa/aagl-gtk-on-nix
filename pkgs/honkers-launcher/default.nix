{
  lib,
  wrapAAGL,

  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],

  unwrapped
}:
wrapAAGL (self: {
  inherit unwrapped extraPkgs extraLibraries;
  binName = "honkers-launcher";
  packageName = "moe.launcher.honkers-launcher";
  desktopName = "Honkers Launcher";

  meta = with lib; {
    description = "Honkers launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/honkers-launcher/";
    mainProgram = self.binName;
    license = licenses.gpl3Only;
  };
})
