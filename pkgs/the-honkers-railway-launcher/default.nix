{ lib
, callPackage
, libunwind
, gnutls
, mangohud
, steam
, symlinkJoin
, writeShellScriptBin
, xdelta
, runtimeShell
, stdenv
, makeDesktopItem
, nss_latest
, the-honkers-railway-launcher-unwrapped
}:
let

  fakePkExec = writeShellScriptBin "pkexec" ''
    declare -a final
    for value in "$@"; do
      final+=("$value")
    done
    exec "''${final[@]}"
  '';

  # Nasty hack for mangohud
  fakeBash = writeShellScriptBin "bash" ''
    declare -a final
    for value in "$@"; do
      final+=("$value")
    done
    if [[ "$MANGOHUD" == "1" ]]; then
      exec mangohud ${runtimeShell} "''${final[@]}"
    fi
    exec ${runtimeShell} "''${final[@]}"
  '';

  steam-run-custom = (steam.override {
    extraPkgs = p: [ nss_latest gnutls mangohud xdelta ];
    extraLibraries = p: [ libunwind ];
    extraProfile = ''
      export PATH=${fakePkExec}/bin:${fakeBash}/bin:$PATH
    '';
  }).run;

  unwrapped = the-honkers-railway-launcher-unwrapped;

  wrapper = writeShellScriptBin "honkers-railway-launcher" ''
    ${steam-run-custom}/bin/steam-run ${unwrapped}/bin/honkers-railway-launcher "$@"
  '';

  icon = stdenv.mkDerivation {
    name = "An Anime Game Launcher icon";
    buildCommand = let
      iconPath = if unwrapped.passthru.customIcon != null
      then unwrapped.passthru.customIcon
      else "${unwrapped.src}/assets/images/icon.png";
    in
    ''
      mkdir -p $out/share/pixmaps
      cp ${iconPath} $out/share/pixmaps/moe.launcher.the-honkers-railway-launcher.png
    '';
  };

  desktopEntry = makeDesktopItem {
    name = "the-honkers-railway-launcher";
    desktopName = "The Honkers Railway Launcher";
    genericName = "The Honkers Railway Launcher";
    exec = "${wrapper}/bin/honkers-railway-launcher";
    icon = "moe.launcher.the-honkers-railway-launcher";
    startupNotify = true;
  };
in
symlinkJoin {
  inherit (unwrapped) pname version name;
  paths = [ icon desktopEntry wrapper ];

  meta = with lib; {
    description = "The Honkers Railway launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/the-honkers-railway-launcher/";
    license = licenses.gpl3Only;
  };
}
