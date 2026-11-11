{
  lib,
  rustPlatform,
  fetchFromGitHub,
  aws-lc,
  pkg-config,
  cmake,
  openssl,
  sqlite,
  zstd,
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
  pname = "sleepy-launcher";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = self.pname;
    rev = self.version;
    sha256 = "sha256-Y245aGuWsHIqqFtde51N0TqneKSo/k69W5Cc9RGVqxo=";
    fetchSubmodules = true;
  };

  prePatch = lib.optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoHash = "sha256-t1ar99CrgbxqJO43OjcMMjctxDPoAa0yr0u5fR3S2NU=";

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
    aws-lc
    gdk-pixbuf
    gsettings-desktop-schemas
    libadwaita
    librsvg
    openssl
    pango
    sqlite
    zstd
  ];

  passthru = {inherit customIcon;};
})
