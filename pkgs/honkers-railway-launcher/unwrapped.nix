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
rustPlatform.buildRustPackage (self: {
  pname = "honkers-railway-launcher";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "the-honkers-railway-launcher";
    rev = self.version;
    sha256 = "sha256-DyOAXSkfOm3di9yujZVhu3+r3F9W8eKNi/A7yUGdKiU=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-uSQ3kjT/UcAJ4/xzfe+sTiwm7zRnuRmbBSAhrGQGbBo=";

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
})
