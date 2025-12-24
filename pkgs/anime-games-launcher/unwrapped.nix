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
rustPlatform.buildRustPackage (self: {
  pname = "anime-games-launcher";
  version = "2.0.0-beta3";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "anime-games-launcher";
    rev = "v${self.version}";
    sha256 = "sha256-+tKbGKAFPDRM1hDLfH3WcsoVBPdA8oVtO4eVlJ2ia2g=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  # Tests require network access. Skipping.
  doCheck = false;

  cargoHash = "sha256-dWtpiz1NeioqJFPz/Pvyg6G6BX3QKAGnVqooFvOLPgM=";

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

  passthru.customIcon =
    if customIcon != null
    then customIcon
    else "${self.src}/launcher/assets/images/icon.png";
})
