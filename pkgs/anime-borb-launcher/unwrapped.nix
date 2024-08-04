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
    pname = "anime-borb-launcher";
    version = "";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "an-anime-borb-launcher";
      rev = version;
      sha256 = "sha256-dT1dA22gMPw7H353+zeu2Y+pHD0Qgs98ZolqJ7zzIeQ=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.12.5" = "sha256-1JHPGMkzaVOIfXjt/LgFHc0Q+95/SpRI7kbxhT1DO/U=";
        "anime-launcher-sdk-1.7.6" = "sha256-dVxms1nq8ZgsGCBwskpsQQqMzO9HNiWi4ozJebvD+To=";
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
