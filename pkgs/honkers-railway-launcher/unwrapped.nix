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
    pname = "honkers-railway-launcher";
    version = "1.2.4";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "the-honkers-railway-launcher";
      rev = version;
      sha256 = "sha256-t8Oo0XCzOq755YjOwhb//p0n3qWvcyL06fM1i18+hEE=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "anime-game-core-1.13.3" = "sha256-6LqUKOFQuHxjxIy9MXqv2MPe7MOZ5BJlRZoag5obFCo=";
        "anime-launcher-sdk-1.8.7" = "sha256-CpiabtXRRqBmDdzZ/yij+qYL1/ERc27p81jmCt8+FhE=";
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
