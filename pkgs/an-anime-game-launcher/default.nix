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
, an-anime-game-launcher-unwrapped

, customIcon ? null
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

  iconChanged = builtins.isPath customIcon || builtins.isString customIcon;

  unwrapped = if iconChanged
    then an-anime-game-launcher-unwrapped.override { inherit customIcon; }
    else an-anime-game-launcher-unwrapped;

  wrapper = writeShellScriptBin "anime-game-launcher" ''
    ${steam-run-custom}/bin/steam-run ${unwrapped}/bin/anime-game-launcher "$@"
  '';

  icon = stdenv.mkDerivation {
    name = "An Anime Game Launcher icon";
    buildCommand = let
      iconPath = if iconChanged then customIcon
      else "${unwrapped.src}/assets/images/icon.png";
    in
    ''
      mkdir -p $out/share/pixmaps
      cp ${iconPath} $out/share/pixmaps/moe.launcher.an-anime-game-launcher.png
    '';
  };

  desktopEntry = makeDesktopItem {
    name = "anime-game-launcher";
    desktopName = "An Anime Game Launcher";
    genericName = "Anime Game Launcher";
    exec = "${wrapper}/bin/anime-game-launcher";
    icon = "moe.launcher.an-anime-game-launcher";
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
