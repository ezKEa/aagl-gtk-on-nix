{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  openssl,
  protobuf,
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
  pname = "anime-game-launcher";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher";
    rev = self.version;
    hash = "sha256-W7q6LciFpDoPm8uoHRrCgKjH2Dgodw6SV8njyivSddw=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-+GdSGZwMDTsnQBbY+d1e2x3UndMKuJZQdQRLQlEwYC8=";

  nativeBuildInputs = [
    cmake
    protobuf
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
