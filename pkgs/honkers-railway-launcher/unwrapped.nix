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
    pname = "honkers-railway-launcher";
    version = "1.7.1";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "the-honkers-railway-launcher";
      rev = version;
      sha256 = "sha256-2XQaNOYzwNu9xWbGQogJoq9NTwKzbFi/VAneEGPOyCc=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-1.22.2" = "sha256-PLsCaKVNUqSvEGxVkuO4nwdxy0I8YsLqAPMcGy2gZ94=";
        "anime-launcher-sdk-1.17.3" = "sha256-5p+3/F9vmHolCqBfkxMxGXoZInjLUzG7riM81zFKIlY=";
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
