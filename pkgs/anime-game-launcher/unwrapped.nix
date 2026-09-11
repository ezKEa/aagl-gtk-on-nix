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
  version = "3.19.8";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher";
    rev = self.version;
    hash = "sha256-QQzQ5xl4UBKLtmjBnGpVQV5hUFKc4IqWZcK+p2gadcI=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-7q+R9caeS72miOfh/uRmvyi2fWr4ys/5tLLHmvJuPjY=";

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
