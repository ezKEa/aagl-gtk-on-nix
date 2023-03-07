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
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher";
    rev = version;
    sha256 = "sha256-+docyWhrmxbKD0fnbCQc1ilo/vvRY9qaP8sjgK73e7I=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoSha256 = "sha256-loKrExbu0LnW57gkTTCJIOrrISIpmW0wSKBjXmlx6Jw=";

  nativeBuildInputs = let
    # Later do this the right way
    fakeGit = writeShellScriptBin "git" ''
      dir="$(basename $PWD)"
      if [[ "$dir" == "anime-launcher-sdk" ]]; then
        echo "7bcfdbee8583f046c9df045577bd679ee4eb45c2";
      fi
      if [[ "$dir" == "anime-game-core" ]]; then
        echo "7593e6ba4bdffe1e5de27e8010abfa309633207a";
      fi
    '';
  in
  [
    fakeGit
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
