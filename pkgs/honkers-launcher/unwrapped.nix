{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  glib,
  pango,
  gdk-pixbuf,
  gtk4,
  libadwaita,
  gobject-introspection,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  librsvg,
  customIcon ? null,
}:
with lib;
  rustPlatform.buildRustPackage rec {
    pname = "honkers-launcher";
    version = "1.4.0";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = pname;
      rev = version;
      sha256 = "sha256-dbQCNlk4cdtYGqiRgXRdLgzzh/F6Dv9tZ9IDN7AbPeY=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "anime-game-core-1.14.0" = "sha256-iAfDk0OK+mU6lST5LnpmTbzL498YcDQ7i7kymQHeOdE=";
        "anime-launcher-sdk-1.9.0" = "sha256-r1TQ0Dfy3CtY/LXcOxS9eSpw/aqQvV6wynAjnHCmNvw=";
      };
    };

    nativeBuildInputs = [
      glib
      gobject-introspection
      gtk4
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

    passthru = {inherit customIcon;};
  }
