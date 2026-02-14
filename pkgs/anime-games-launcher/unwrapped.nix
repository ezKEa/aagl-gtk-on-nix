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
  version = "2.0.0-beta4";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "anime-games-launcher";
    rev = "v${self.version}";
    sha256 = "sha256-gYlGgB6b8SpkXWmnWYpsgRDR31bVMPgh8DwVQ/R+btY=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm crates/anime-games-launcher/assets/images/icon.png
    cp ${customIcon} crates/anime-games-launcher/assets/images/icon.png
  '';

  # Tests require network access. Skipping.
  doCheck = false;

  cargoHash = "sha256-Zn5WAroa44I/NQshIfIVSIT6zR/Tou6kJUxZcFeJFWM=";

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
    else "${self.src}/crates/anime-games-launcher/assets/images/icon.png";
})
