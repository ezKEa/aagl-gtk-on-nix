{
lib, rustPlatform, fetchFromGitHub
, pkg-config
, openssl
, glib
, pango
, gdk-pixbuf
, gtk4
, libadwaita
, gobject-introspection
, gsettings-desktop-schemas
, writeShellScriptBin
, wrapGAppsHook4
, librsvg

, customIcon ? null
}:

with lib;
rustPlatform.buildRustPackage rec {
  pname = "honkers-railway-launcher";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "the-honkers-railway-launcher";
    rev = version;
    sha256 = "sha256-By3bMvUyDCUmaWKDl3PtUkAyhH1x9fK4gjrIKmyIkuI=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "anime-game-core-1.10.4" = "sha256-sUSfVB3vgQ7hKqt8XaLtfHpNJYD9GG2MxEOOaigG62c=";
      "anime-launcher-sdk-1.4.6" = "sha256-pRBEadq/ZwRvjhCaQ/vpvE4dh8bZEF6xV3k4TTq3/WQ=";
    };
  };

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

  passthru = { inherit customIcon; };
}
