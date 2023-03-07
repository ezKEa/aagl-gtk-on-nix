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
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "an-anime-team";
    repo = "an-anime-game-launcher";
    rev = version;
    sha256 = "sha256-6OCUB6KuV0EV172o526UibHvOUDsU1FXx0Vvz0KIYgM=";
    fetchSubmodules = true;
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoSha256 = "sha256-d1vdjvHLFz0DRepECtuo064lIKdnYPV0sPjyXKH3fYU=";

  nativeBuildInputs = let
    # Later do this the right way
    fakeGit = writeShellScriptBin "git" ''
      dir="$(basename $PWD)"
      if [[ "$dir" == "anime-launcher-sdk" ]]; then
        echo "219d0f7704e18d74a9205163ffbb7d1718291ea4";
      fi
      if [[ "$dir" == "anime-game-core" ]]; then
        echo "45894e77c9ec1fcfe264c80f6a39774876413386";
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
