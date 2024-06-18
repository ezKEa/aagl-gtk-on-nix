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
  gst_all_1,
  librsvg,
  customIcon ? null,
}:
with lib;
  rustPlatform.buildRustPackage rec {
    pname = "anime-games-launcher";
    version = "1.0.2";

    src = fetchFromGitHub {
      owner = "an-anime-team";
      repo = "anime-games-launcher";
      rev = "v${version}";
      sha256 = "sha256-EwpZQ0nesTBbL1wfmIOJZBgHXzsKrpKKqyuGCFSCZuI=";
      fetchSubmodules = true;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "anime-game-core-2.0.0" = "sha256-Pnvk9bfuucU3t5WeL4U4FLF68GXtoy2sDEY50AFl7t0=";
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
    ] ++ (with gst_all_1; [
      gst-libav
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gstreamer
    ]);

    passthru = {inherit customIcon;};
  }
