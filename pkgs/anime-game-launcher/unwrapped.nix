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
    version = "3.12.0";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "an-anime-game-launcher";
      rev = version;
      hash = "sha256-5vEYIdHEp1+vW6/Apwr6iFeC21JD1MjNTloN76oGjWk=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.24.1" = "sha256-7rHx5wz9D4cvFuWOIju/LD3cCeWhrxm9+aVCk4dkQCk=";
        "anime-launcher-sdk-1.20.1" = "sha256-AUZ46b9hGH1I/ppwIDLx8Eppd9dYuYpcse6gXaL72QU=";
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
