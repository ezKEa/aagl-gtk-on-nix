{
lib, rustPlatform, fetchFromGitHub
, pkg-config
, openssl
, glib
, pango
, gdk-pixbuf
, gtk4
, jq
, libadwaita
, gobject-introspection
, gsettings-desktop-schemas
, wrapGAppsHook4
, librsvg

, customDxvk ? null
, customDxvkAsync ? null
, customGEProton ? null
, customLutris ? null
, customSoda ? null
, customWineGEProton ? null
, customIcon ? null
}:

with lib;

let
  overrideDXVK = {
    dxvk ? "vanilla",
    name ? "dxvk-${version}",
    url,
    version
  }:
  let
    json = "anime-launcher-sdk/components/dxvk/${dxvk}.json";
  in
  ''
    newJson="$(jq -r '. |= [{
      "name": "${name}",
      "version": "${version}",
      "uri": "${url}",
      "recommended": true
    }] + .' ${json})"
    echo "$newJson" > ${json}
  '';

  overrideWine = {
    wine ? (toLower name),
    fullname ? "${wine}-${version}-x86_64",
    title ? "${name} ${version}",
    name,
    url,
    version,
    files ? null
  }:
  let
    json = "anime-launcher-sdk/components/wine/${wine}.json";
    # Take default arguments for the files attrset
    files_ = let
      default = {
        wine = "bin/wine";
        wine64 = "bin/wine64";
        wineboot = "bin/wineboot";
        winecfg = "lib64/wine/x86_64-windows/winecfg.exe";
        wineserver = "bin/wineserver";
      };
    in
    if (builtins.isAttrs files)
    then ( default // files )
    else default;
  in
  ''
    newJson="$(jq -r '. |= [{
      "name": "${fullname}",
      "title": "${title}",
      "uri": "${url}",
      "files": {
        "wine": "${files_.wine}",
        "wine64": "${files_.wine64}",
        "wineserver": "${files_.wineserver}",
        "wineboot": "${files_.wineboot}",
        "winecfg": "${files_.winecfg}"
      },
      "recommended": true
    }] + .' ${json})"
    echo "$newJson" > ${json}
  '';
in

rustPlatform.buildRustPackage rec {
  pname = "an-anime-game-launcher";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher";
    rev = version;
    sha256 = "sha256-mnHgl8wtBJYswVZ7sSLWxDsb77sQYPql423K1I20nrs=";
    fetchSubmodules = true;
  };

  prePatch = ''''
    + optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    ''

    + optionalString (builtins.isAttrs customDxvk) (overrideDXVK customDxvk)
    + optionalString (builtins.isAttrs customDxvkAsync) (overrideDXVK ( rec {
      inherit (customDxvkAsync) url version;
      dxvk = "async";
      name = "dxvk-async-${version}";
    } // customDxvkAsync))

    # Override GE-Proton
    + optionalString (builtins.isAttrs customGEProton) (overrideWine ( rec {
      inherit (customGEProton) url version;
      name = "GE-Proton";
      fullname = "${name}${version}";
      files = {
        wine = "file/bin/wine";
        wine64 = "files/bin/wine64";
        wineboot = "files/bin/wineboot";
        winecfg = "files/lib64/wine/x86_64-windows/winecfg.exe";
        wineserver = "files/bin/wineserver";
      };
    } // customGEProton))

    # override Lutris
    + optionalString (builtins.isAttrs customLutris) (overrideWine ( rec {
      inherit (customLutris) url version;
      name = "Lutris";
    } // customLutris))

    # override Soda
    + optionalString (builtins.isAttrs customSoda) (overrideWine ( rec {
      inherit (customSoda) url version;
      name = "Soda";
      files.winecfg = "lib/wine/x86_64-windows/winecfg.exe";
    } // customSoda))

    # override Wine-GE-Proton
    + optionalString (builtins.isAttrs customWineGEProton) (overrideWine ( rec {
      inherit (customWineGEProton) url version;
      name = "Wine-GE-Proton";
      fullname = "lutris-GE-Proton${version}-x86_64";
    } // customWineGEProton));

  cargoSha256 = "sha256-eEvPTXaaMqgCq+X/a6YR3WzOozX63DD0wxvxSoBqzTE=";

  nativeBuildInputs = [
    glib
    gobject-introspection
    gtk4
    jq
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gsettings-desktop-schemas
    libadwaita
    librsvg
    openssl
    pango
  ];

  passthru = { inherit customIcon; };
}
