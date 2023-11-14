{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
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
with lib;
  rustPlatform.buildRustPackage rec {
    pname = "honkers-railway-launcher";
    version = "1.5.0";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "the-honkers-railway-launcher";
      rev = version;
      sha256 = "sha256-+vf4ZouPALVHKmWsfpaM+xg9Cs+sVBixNYheJ4xf2PY=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    # TODO: Remove this patch when GNOME 45 is merged into nixpkgs
    # https://github.com/NixOS/nixpkgs/pull/247766
    patches = [
      ./gtk4-version.patch
    ];

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.17.2" = "sha256-goZvMP+NdfyAqPV7r2vMfXVYBD21LF/kFT+rlUkggfY=";
        "anime-launcher-sdk-1.12.2" = "sha256-LmAhqssTuFIWyXrqM6KMZ3DWtwaxGV2PYUgU02qyomE=";
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

    passthru = {inherit customIcon;};
  }
