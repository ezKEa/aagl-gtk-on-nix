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
  version = "3.19.5";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher";
    rev = self.version;
    hash = "sha256-crNU1VmMCG/k+Gyo0yutvhM7JXc22uQBPuddeY24tzE=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-1zk/5BghzWXQuPRu1bAw3ZdxQCdw9wA6SOOQQgU77oc=";

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
