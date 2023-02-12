{
lib, rustPlatform, fetchFromGitHub
, pkg-config
, openssl
, glib
, pango
, gdk-pixbuf
, gtk4
, libadwaita
, gobject-introspection
, gsettings-desktop-schemas
, wrapGAppsHook4
, librsvg
, python3
, python3Packages

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
  ''
    cat > components/dxvk/${dxvk}.json << EOF
      [
        {
          "name": "${name}",
          "version": "${version}",
          "uri": "${url}",
          "recommended": true
        }
      ]
    EOF
  '';

  overrideWine = {
    wine ? (toLower name),
    name,
    url,
    version,
    files ? null
  }:
  let
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
    cat > components/wine/${wine}.json << EOF
      [
        {
          "name": "${name}-${version}",
          "title": "${name} ${version}",
          "uri": "${url}",
          "files": {
            "wine": "${files_.wine}",
            "wine64": "${files_.wine64}",
            "wineserver": "${files_.wineserver}",
            "winecfg": "${files_.winecfg}",
            "wineboot": "${files_.wineboot}"
          },
          "recommended": true
        }
      ]
    EOF
  '';
in

rustPlatform.buildRustPackage rec {
  pname = "an-anime-game-launcher-gtk";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher-gtk";
    rev = version;
    sha256 = "sha256-2I3/J173Gn1FA/7wO659hkNHnMLKA9G1Bux/wktySQ4=";
    fetchSubmodules = true;
  };

  prePatch = ''''
    + optionalString (builtins.isPath customIcon || builtins.isString customIcon) ''
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
      files = {
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
    } // customWineGEProton));

  cargoSha256 = "sha256-s67mSAPXYVddAxRW2crE/16PvCkzVylW1bnrBYrpukI=";

  nativeBuildInputs = [
    glib
    gobject-introspection
    gtk4
    pkg-config
    python3
    python3Packages.pygobject3
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
}
