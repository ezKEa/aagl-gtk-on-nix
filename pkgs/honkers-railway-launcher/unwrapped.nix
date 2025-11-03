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
  pname = "honkers-railway-launcher";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "the-honkers-railway-launcher";
    rev = self.version;
    sha256 = "sha256-DJh2b+EjOptxE4Cc8j0rlHCZtwSFiI+nSW2+fBHqjzQ=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-UJWzQlB4eAaa89nvYbYvm0cvkICTI6zt9Km2qn/illk=";

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
