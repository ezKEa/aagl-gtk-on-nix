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
, git
, p7zip
, honkers-launcher-unwrapped
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
    extraPkgs = p: [ git gnutls mangohud nss_latest p7zip xdelta ];
    extraLibraries = p: [ libunwind ];
    extraProfile = ''
      export PATH=${fakePkExec}/bin:${fakeBash}/bin:$PATH
    '';
  }).run;

  unwrapped = honkers-launcher-unwrapped;

  wrapper = writeShellScriptBin "honkers-launcher" ''
    ${steam-run-custom}/bin/steam-run ${unwrapped}/bin/honkers-launcher "$@"
  '';

  icon = stdenv.mkDerivation {
    name = "Honkers Launcher icon";
    buildCommand = let
      iconPath = if unwrapped.passthru.customIcon != null
      then unwrapped.passthru.customIcon
      else "${unwrapped.src}/assets/images/icon.png";
    in
    ''
      mkdir -p $out/share/pixmaps
      cp ${iconPath} $out/share/pixmaps/moe.launcher.honkers-launcher.png
    '';
  };

  desktopEntry = makeDesktopItem {
    name = "honkers-launcher";
    desktopName = "Honkers Launcher";
    genericName = "Honkers Launcher";
    exec = "${wrapper}/bin/honkers-launcher";
    icon = "moe.launcher.honkers-launcher";
    startupNotify = true;
  };
in
symlinkJoin {
  inherit (unwrapped) pname version name;
  paths = [ icon desktopEntry wrapper ];

  meta = with lib; {
    description = "Honkers launcher for Linux with automatic patching and telemetry disabling.";
    homepage = "https://github.com/an-anime-team/honkers-launcher/";
    license = licenses.gpl3Only;
  };
}
