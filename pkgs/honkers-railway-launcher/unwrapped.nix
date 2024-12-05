{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
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
    pname = "honkers-railway-launcher";
    version = "1.9.1";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "the-honkers-railway-launcher";
      rev = version;
      sha256 = "sha256-L3lAY4RnjdIxZOsA9ude2Lb0CgVs/H98JVpIKRiQ/D0=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.27.0" = "sha256-iIabmeKrZLnsfPH8XhH5bLvbb1rPsTWDi4eM0H7ra+o=";
        "anime-launcher-sdk-1.25.0" = "sha256-IeiGvsYyCasNNOwyVn/6JlRMV5cbUyfscAPBWRQOmuI=";
      };
    };

    nativeBuildInputs = [
      cmake
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
