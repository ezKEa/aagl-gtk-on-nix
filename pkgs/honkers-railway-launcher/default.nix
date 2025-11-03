{
  lib,
  wrapAAGL,

  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],

  unwrapped
}:
wrapAAGL (self: {
  inherit unwrapped extraPkgs extraLibraries;
  binName = "honkers-railway-launcher";
  packageName = "moe.launcher.the-honkers-railway-launcher";
  desktopName = "The Honkers Railway Launcher";

  meta = with lib; {
    description = "The Honkers Railway launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/the-honkers-railway-launcher/";
    mainProgram = self.binName;
    license = licenses.gpl3Only;
  };
})
