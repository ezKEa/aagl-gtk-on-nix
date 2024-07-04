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
with lib;
  rustPlatform.buildRustPackage rec {
    pname = "sleepy-launcher";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = pname;
      rev = version;
      sha256 = "sha256-tNTitOaN2N3BRcoXFWiW9imB/WMYViiRKSexVIyIxRE=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.21.0" = "sha256-RYKzjc2n45HTLwzT5g8IcD1r98rP9KYtBBS3luOnSpo=";
        "anime-launcher-sdk-1.16.2" = "sha256-bdtyK4p5m8CD86DiT2nB3SFmcql4f57+aWswW+kq2f8=";
      };
    };

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
  }
