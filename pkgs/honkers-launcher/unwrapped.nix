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
  pname = "honkers-launcher";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZUs3T7yMsPvay6IW4fMn/siMtdS/G5yGCTur1Gk1oNI=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "anime-game-core-1.8.2" = "sha256-qoFwkPbmLekvUicLPZSjGcaiuIq9S68G7nFmHQFUSDA=";
      "anime-launcher-sdk-1.2.5" = "sha256-MDBBQ+9x7ZnbG3vDiAQ7P7qzgbIPFjvRAO8ULggMT0M=";
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
