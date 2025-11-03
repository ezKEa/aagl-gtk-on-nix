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
  pname = "wavey-launcher";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = self.pname;
    rev = self.version;
    sha256 = "sha256-9hjrHBKHb1ALmyvFUvUEFOSuRAvU6wRhhhgqwGXze3g=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-rz/zLXV/YsgoSogzShF0MHY9hXvCYvP1indRqeWT/lc=";

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
