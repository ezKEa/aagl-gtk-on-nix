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
, wrapGAppsHook4
, writeShellScriptBin
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
    sha256 = "sha256-MjXOx+lsNBOJAo1FcoPPPpS7XKwDT2Yw+9hdOm+Opwk=";
    fetchSubmodules = true;
    leaveDotGit = true;
    # leaveDotGit causes indeterminism
    # https://github.com/NixOS/nixpkgs/issues/8567
    # Need git commits hashes for about menu, so we'll get those and save them
    postFetch = ''
      buildDir="$PWD"
      find "$out" -type d -name .git | while read -r dir; do
        cd "$dir/.."
        echo "$(git rev-parse HEAD)" "$(basename $PWD)" >> $buildDir/COMMITS
      done
      find "$out" -name .git -print0 | xargs -0 rm -rf
      cat $buildDir/COMMITS | tail -n +2 > $out/COMMITS
    '';
  };

  prePatch = optionalString (customIcon != null) ''
    rm assets/images/icon.png
    cp ${customIcon} assets/images/icon.png
  '';

  cargoSha256 = "sha256-d1vdjvHLFz0DRepECtuo064lIKdnYPV0sPjyXKH3fYU=";

  nativeBuildInputs = let
    fakeGit = writeShellScriptBin "git" ''
      set -e
      cat $src/COMMITS | grep "$(basename $PWD)" | awk '{ print $1 }'
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
