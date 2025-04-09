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
    version = "3.13.1";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "an-anime-game-launcher";
      rev = version;
      hash = "sha256-oxwW/hVUk7ch+Xi73KLj/sYLfiClOKzuoUMS/ZdJ2sI=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    useFetchCargoVendor = true;
    cargoHash = "sha256-pE+PNeLPfqmNrubh5U7i19/UJqJJCeoEYGx0s2GmXuw=";

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
