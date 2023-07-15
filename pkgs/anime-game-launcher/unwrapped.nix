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
    pname = "anime-game-launcher";
    version = "3.7.6";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "an-anime-game-launcher";
      rev = version;
      sha256 = "sha256-3bNVDyInkes8z/7etaex7q5GHyNNQIPrAe+3w7SEY8U=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "anime-game-core-1.13.2" = "sha256-ng924Z+JbciZ1q2YjSY9CChQi1w5j7QfKOGvZDycjqk=";
        "anime-launcher-sdk-1.8.6" = "sha256-oBdZP7WgaWoQqSuHuOg2I8jZt9DGvRwj6R0vSrbPt1Q=";
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
