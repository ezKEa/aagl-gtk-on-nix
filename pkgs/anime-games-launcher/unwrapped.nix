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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "anime-games-launcher";
    rev = "v${self.version}";
    sha256 = "sha256-MQbUBXRA9iCgaZtSVywNmwEKHCopW373mCMLJWY5IY8=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm crates/anime-games-launcher/assets/images/icon.png
    cp ${customIcon} crates/anime-games-launcher/assets/images/icon.png
  '';

  # Tests require network access. Skipping.
  doCheck = false;

  cargoHash = "sha256-luWMxIgDzl2zvDq7HAAkTVQ7Z1p2OfbCIB7cXargavA=";

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
