{
  lib,
  wrapAAGL,

  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],

  unwrapped
}:
wrapAAGL (self: {
  inherit unwrapped extraPkgs extraLibraries;
  binName = "sleepy-launcher";
  packageName = "moe.launcher.sleepy-launcher";
  desktopName = "Sleepy Launcher";

  meta = with lib; {
    description = "Sleepy launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/sleepy-launcher/";
    mainProgram = self.binName;
    license = licenses.gpl3Only;
  };
})
