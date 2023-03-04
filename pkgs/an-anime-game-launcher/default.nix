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

, an-anime-game-launcher-gtk-unwrapped ? null
, an-anime-game-launcher-unwrapped ? an-anime-game-launcher-gtk-unwrapped
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
    extraPkgs = p: [ gnutls mangohud xdelta ];
    extraLibraries = p: [ libunwind ];
    extraProfile = ''
      export PATH=${fakePkExec}/bin:${fakeBash}/bin:$PATH
    '';
  }).run;

  wrapper = writeShellScriptBin "anime-game-launcher" ''
    ${steam-run-custom}/bin/steam-run ${an-anime-game-launcher-unwrapped}/bin/anime-game-launcher "$@"
  '';

  icon = stdenv.mkDerivation {
    name = "An Anime Game Launcher icon";
    buildCommand = ''
      mkdir -p $out/share/pixmaps
      cp ${an-anime-game-launcher-unwrapped.src}/assets/images/icon.png $out/share/pixmaps/aagl-gtk.png
    '';
  };

  desktopEntry = makeDesktopItem {
    name = "anime-game-launcher";
    desktopName = "An Anime Game Launcher";
    genericName = "Anime Game Launcher";
    exec = "${wrapper}/bin/anime-game-launcher";
    icon = "aagl-gtk";
    startupNotify = true;
  };
in
symlinkJoin {
  inherit (an-anime-game-launcher-unwrapped) pname version name;
  paths = [ icon desktopEntry wrapper ];

  meta = with lib; {
    description = "An Anime Game launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/an-anime-game-launcher/";
    license = licenses.gpl3Only;
  };
}
