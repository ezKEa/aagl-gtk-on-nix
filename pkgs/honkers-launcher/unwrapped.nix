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
  protobuf,
  customIcon ? null,
}:
rustPlatform.buildRustPackage (self: {
  pname = "honkers-launcher";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = self.pname;
    rev = self.version;
    sha256 = "sha256-o2+9biGcdpaEj344Tc5AD0CU/KRjBHEMQa3DyMnfdUc=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-40F604197temTCOF+UAcwh8MiY9ptKQgB/UfovJ0Ysw=";

  nativeBuildInputs = [
    cmake
    glib
    gobject-introspection
    gtk4
    pkg-config
    protobuf
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
