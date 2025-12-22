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
  version = "2.0.0-beta2";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "anime-games-launcher";
    rev = "v${self.version}";
    sha256 = "sha256-hFfFPX4JjNAGOWAdwJz74seHNklMZmBCMUktICjaIc0=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  # Tests require network access. Skipping.
  doCheck = false;

  cargoHash = "sha256-lmrwPFSB2iD5V4ZOM8HMKWodYN6iYAMKw9aAv8Xghm4=";

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
