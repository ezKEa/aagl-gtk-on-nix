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
    pname = "anime-game-launcher";
    version = "3.9.6";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "an-anime-game-launcher";
      rev = version;
      hash = "sha256-bdpQzUxouj9NhdE38VRignWYqFhHaVGas5L3MIGnOMc=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "anime-game-core-1.17.8" = "sha256-a6SEnBgSaw2aa9BbZ1EfcA4milbXHhFvKaMFEuLI598=";
        "anime-launcher-sdk-1.12.10" = "sha256-lbQEiMUWShY8bbxcPkxqmHAOMJ+X9lckd2REUNaWwBM=";
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
