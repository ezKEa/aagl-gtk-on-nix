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
    version = "3.10.0";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "an-anime-game-launcher";
      rev = version;
      hash = "sha256-HfHcMlVYuPo5BAIOsUAPKUlo79j9ltldFFQSVWZfdx8=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.19.0" = "sha256-3i8o0YjJbcNZom6IzAzVosNHaYodoQcZjSsPnVt9CTQ=";
        "anime-launcher-sdk-1.14.0" = "sha256-h6nJLaq92Ad8lKXYK1WmExTWoKLOaEvhFbVQjTnTyJg=";
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
