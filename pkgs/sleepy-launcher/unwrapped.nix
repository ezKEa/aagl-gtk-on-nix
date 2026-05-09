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
  pname = "sleepy-launcher";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = self.pname;
    rev = self.version;
    sha256 = "sha256-s1fI/p7hi7PYLuxVEzC8hZk5Az6v61fzAs/uDUH41Ec=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-xQbisVULbgT9Z6nv55f7zzBM6M66tM6bPu8qNCzAlBk=";

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
