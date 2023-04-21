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
  pname = "an-anime-game-launcher";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher";
    rev = version;
    sha256 = "sha256-UX18qoqHjEdrf5aKkPGRzfyhSIXHLB4SsCzLAT1eOxI=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "anime-game-core-1.7.1" = "sha256-S8npOH7stiKvSQ7N2rnxCNt4Jci49PxfoiTEk0icCrg=";
      "anime-launcher-sdk-1.0.6" = "sha256-g6liASBek0rI5QCWTLwdUP3SLEeshzLEfqfwAL2sCFw=";
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
