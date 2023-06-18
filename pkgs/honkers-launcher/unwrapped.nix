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
    version = "1.2.1";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = pname;
      rev = version;
      sha256 = "sha256-v1ihzFbJnvjvG3Cm5f8wqVZ/MOdEU8XOFoiACzbOm9I=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "anime-game-core-1.13.1" = "sha256-HkhLQ0ZUVYnHUiORreedH2D3UarJ+6889ctks3fBioE=";
        "anime-launcher-sdk-1.8.3" = "sha256-GIn1J6H62lzrgfAmMw2FQW5APG0zPKn0WF5T7OXN9JA=";
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
