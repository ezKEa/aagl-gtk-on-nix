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
    pname = "honkers-launcher";
    version = "1.10.1";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = pname;
      rev = version;
      sha256 = "sha256-sLBTwyloUpYJOo9Ztk/06FFZDHZwAs24jdSu3b+Vxmg=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.26.0" = "sha256-8YnsOyhrHLQ0o7ewHjaHO6hXze/SPqlAO1gH6ljaDWs=";
        "anime-launcher-sdk-1.23.0" = "sha256-v8BUbwHM9BWtiKRig6g5sWCBbpYZ+AsL67Xf0b5wjb0=";
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
