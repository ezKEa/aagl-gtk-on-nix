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
  pname = "the-honkers-railway-launcher";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-BuSzn0WlQegOZVUO0Jg2lC7p+KeJyUoeEFykBqcJO3U=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "anime-game-core-1.8.0" = "sha256-oYK7QZyTnGw2Amk6ESTRbkLCd04J4eXhfxHsHbEv+CY=";
      "anime-launcher-sdk-1.2.2" = "sha256-MFdrxref/We0LYBqmVRVDbU98RiAXAs17gQvP9VkQUQ=";
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
