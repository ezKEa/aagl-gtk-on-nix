{
  cabextract,
  libunwind,
  gnutls,
  mangohud,
  callPackage,
  symlinkJoin,
  writeShellScriptBin,
  xdelta,
  stdenv,
  makeDesktopItem,
  nss_latest,
  git,
  p7zip,
  libwebp,
  gamescope,
  unzip,
  extraPkgs ? pkgs: [ ], # extra packages to add to targetPkgs
  extraLibraries ? pkgs: [ ], # extra packages to add to multiPkgs
}:
{
  unwrapped,
  binName,
  packageName,
  desktopName,
  meta,
}:
let
  # needed to retrieve old versions of gstreamer 
  # that is required to play HSR cutscenes
  pkgs_old = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/f62d6734af4581af614cab0f2aa16bcecfc33c11.tar.gz";
  }) {};

  fakePkExec = writeShellScriptBin "pkexec" ''
    declare -a final
    for value in "$@"; do
      final+=("$value")
    done
    exec "''${final[@]}"
  '';

  # TODO: custom FHS env instead of using steam-run
  steam-run-custom = (callPackage ./fhsenv.nix {
      extraPkgs = _p: [
        cabextract
        gamescope
        git
        gnutls
        mangohud
        nss_latest
        p7zip
        xdelta
        unzip
        libwebp
      ] ++ (
        extraPkgs _p
      );
      extraLibraries = _p: [
        libunwind
      ] ++ ( with pkgs_old.gst_all_1; [
        # Needed for HSR cutscenes.
        # TODO: figure out which of these are actually needed.
        gst-libav
        gst-vaapi
        gst-plugins-bad
        gst-plugins-good
      ]) ++ (
        extraLibraries _p
      );
      extraProfile = ''
        export PATH=${fakePkExec}/bin:$PATH
      '';
  }).passthru.run;

  wrapper = writeShellScriptBin binName ''
    ${steam-run-custom}/bin/steam-run ${unwrapped}/bin/${binName} "$@"
  '';

  icon = stdenv.mkDerivation {
    name = "${binName}-icon";
    buildCommand = let
      iconPath =
        if unwrapped.passthru.customIcon != null
        then unwrapped.passthru.customIcon
        else "${unwrapped.src}/assets/images/icon.png";
    in ''
      mkdir -p $out/share/pixmaps
      cp ${iconPath} $out/share/pixmaps/${packageName}.png
    '';
  };

  desktopEntry = makeDesktopItem {
    name = binName;
    inherit desktopName;
    genericName = desktopName;
    exec = "${wrapper}/bin/${binName}";
    icon = packageName;
    categories = ["Game"];
    startupWMClass = packageName;
    startupNotify = true;
  };
in
  symlinkJoin {
    inherit unwrapped meta;
    inherit (unwrapped) pname version name;
    paths = [icon desktopEntry wrapper];

    passthru = {
      inherit icon desktopEntry wrapper;
    };
  }
