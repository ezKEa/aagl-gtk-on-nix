{
  libunwind,
  gnutls,
  mangohud,
  steam,
  symlinkJoin,
  writeShellScriptBin,
  xdelta,
  runtimeShell,
  stdenv,
  makeDesktopItem,
  nss_latest,
  git,
  p7zip,
  unwrapped ? null,
  binName ? "",
  packageName ? "",
  desktopName ? "",
  meta ? {},
}: let
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

  # TODO: custom FHS env instead of using steam-run
  steam-run-custom =
    (steam.override {
      extraPkgs = _p: [git gnutls mangohud nss_latest p7zip xdelta];
      extraLibraries = _p: [libunwind];
      extraProfile = ''
        export PATH=${fakePkExec}/bin:${fakeBash}/bin:$PATH
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
