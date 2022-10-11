{ lib
, callPackage
, libunwind
, mangohud
, steam
, symlinkJoin
, writeShellScriptBin
, xdelta
, runtimeShell
, stdenv
, makeDesktopItem
, an-anime-game-launcher-gtk-unwrapped
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
    extraPkgs = p: [ mangohud xdelta ];
    extraLibraries = p: [ libunwind ];
    extraProfile = ''
      export PATH=${fakePkExec}/bin:${fakeBash}/bin:$PATH
    '';
  }).run;

  wrapper = writeShellScriptBin "anime-game-launcher" ''
    ${steam-run-custom}/bin/steam-run ${an-anime-game-launcher-gtk-unwrapped}/bin/anime-game-launcher "$@"
  '';

  icon = stdenv.mkDerivation {
    name = "An Anime Game Launcher icon";
    buildCommand = ''
      mkdir -p $out/share/pixmaps
      cp ${an-anime-game-launcher-gtk-unwrapped.src}/assets/images/icon.png $out/share/pixmaps/aagl-gtk.png
    '';
  };

  desktopEntry = makeDesktopItem {
    name = "anime-game-launcher";
    desktopName = "An Anime Game Launcher GTK";
    genericName = "Anime Game Launcher";
    exec = "${wrapper}/bin/anime-game-launcher";
    icon = "aagl-gtk";
    startupNotify = true;
  };
in
symlinkJoin {
  inherit (an-anime-game-launcher-gtk-unwrapped) pname version name;
  paths = [ icon desktopEntry wrapper ];

  meta = with lib; {
    description = "An Anime Game Launcher variant written on Rust, GTK4 and libadwaita, using Anime Game Core library";
    homepage = "https://gitlab.com/an-anime-team/an-anime-game-launcher-gtk/";
    license = licenses.gpl3Only;
  };
}
