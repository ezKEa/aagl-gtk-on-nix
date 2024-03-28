{
  cabextract,
  libunwind,
  gnutls,
  gst_all_1,
  mangohud,
  steam,
  symlinkJoin,
  writeShellScriptBin,
  xdelta,
  stdenv,
  makeDesktopItem,
  nss_latest,
  git,
  p7zip,
  gamescope,
  unzip,
  unwrapped ? null,
  binName ? "",
  packageName ? "",
  desktopName ? "",
  meta ? {},
}:
let
  fakePkExec = writeShellScriptBin "pkexec" ''
    declare -a final
    for value in "$@"; do
      final+=("$value")
    done
    exec "''${final[@]}"
  '';

  # TODO: custom FHS env instead of using steam-run
  steam-run-custom =
    (steam.override {
      extraPkgs = _p: [cabextract gamescope git gnutls mangohud nss_latest p7zip xdelta unzip];
      extraLibraries = _p: [libunwind gst_all_1.gst-libav];
      extraProfile = ''
        export PATH=${fakePkExec}/bin:$PATH
      '';
    })
    .run;

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
