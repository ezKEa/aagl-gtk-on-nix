{
  lib,
  rustPlatform,
  fetchFromGitHub,
  aws-lc,
  pkg-config,
  openssl,
  sqlite,
  zstd,
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
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "anime-games-launcher";
    rev = "v${self.version}";
    sha256 = "sha256-gUwH9osEKCwm6GdgCOvF73qLtHg4pan3xJU3Zxcihr8=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm crates/anime-games-launcher/assets/images/icon.png
    cp ${customIcon} crates/anime-games-launcher/assets/images/icon.png
  '';

  # Tests require network access. Skipping.
  doCheck = false;

  cargoHash = "sha256-33kLcKYkC5v1w8Rwd4Qisn/qHREVMw4Euu62q21XSr0=";

  nativeBuildInputs = [
    glib
    gobject-introspection
    gtk4
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    aws-lc
    gdk-pixbuf
    gsettings-desktop-schemas
    libadwaita
    librsvg
    openssl
    pango
    sqlite
    zstd
  ];

  passthru.customIcon =
    if customIcon != null
    then customIcon
    else "${self.src}/crates/anime-games-launcher/assets/images/icon.png";
})
