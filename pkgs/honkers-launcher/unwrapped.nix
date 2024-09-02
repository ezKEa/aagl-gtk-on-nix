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
    version = "1.8.1";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = pname;
      rev = version;
      sha256 = "sha256-7agAyQrt+JtEQKhD49NlVcsHWpmvFY86bzi1TVjzR/g=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.24.2" = "sha256-HUTIgxrfzuz/S8cV/9darw4yEVGssnz/8ycAQb9Yyzc=";
        "anime-launcher-sdk-1.20.3" = "sha256-6NqHhoT70/YLSKe8OXF5lxj6/GlpJZPxUQXdzDPhHRY=";
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
