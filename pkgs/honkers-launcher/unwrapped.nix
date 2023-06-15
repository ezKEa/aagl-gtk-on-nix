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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-OLWjHjIcGq3yCWowltfy5X5s6XCjsegfVu+Rx8UmJbs=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "anime-game-core-1.12.6" = "sha256-wRlI3q7Irlkt21Ej2cFqNzOfa4/CXYzweNHc59Bto1w=";
      "anime-launcher-sdk-1.7.7" = "sha256-/NmisW/xAE2LlY+Kj/+DLXsryBwuvcatEUVdGq2EAw8=";
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
