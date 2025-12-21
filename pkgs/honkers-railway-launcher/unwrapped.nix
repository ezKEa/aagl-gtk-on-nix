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
  pname = "honkers-railway-launcher";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "the-honkers-railway-launcher";
    rev = self.version;
    sha256 = "sha256-W0OlFQEjSRUlOp4DijpNXDihEyOfPOCbUKIGihQcsvg=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-hZjQBnoa93LH7OceEHZWRNw2pISqLU68ZDuy5fgVmTs=";

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
