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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-jWh6niLdqZ+jylHltotmU89DvP1jKADUC0DqQByg50M=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "anime-game-core-1.7.4" = "sha256-WRiplxMWcS/35evhyhhHQ5Bl9xZimB6Qq52JCwvUomY=";
      "anime-launcher-sdk-1.0.12" = "sha256-nCygykcg7IimBf4ISpDGaQ9KHPJEhzcvdtIa9+cdaUY=";
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
