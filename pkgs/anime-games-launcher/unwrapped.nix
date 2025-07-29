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
    pname = "anime-games-launcher";
    version = "1.0.2";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "anime-games-launcher";
      rev = "v${version}";
      sha256 = "sha256-EwpZQ0nesTBbL1wfmIOJZBgHXzsKrpKKqyuGCFSCZuI=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    # Tests require network access. Skipping.
    doCheck = false;

    cargoHash = "sha256-mTt3cCK0dK00r6H6UFTbFpkvi09MSgSYiz9xV8Msim4=";

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
