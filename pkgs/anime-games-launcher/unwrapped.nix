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
    version = "2.0.0-alpha2";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "anime-games-launcher";
      rev = "v${version}";
      sha256 = "sha256-wtvPqJbAv0dqKdrtgx35rXHHLjr998CIKklwhlh+iqA=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    # Tests require network access. Skipping.
    doCheck = false;

    cargoHash = "sha256-CX/B4twbVYPkDvQ+zd97hk4GY1Sg9tCjvhI9P/l4OWY=";

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
