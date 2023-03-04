#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git gron jq niv nix-prefetch

PS4=''
set -x

sourceJson="./nix/sources.json"

updateCargoSha(){
  gronnedJson="$(gron  "$sourceJson")"
  # update AAGL's cargoSha256
  # shellcheck disable=SC2016
  aaglCargoSha="$(nix-prefetch "
    { sha256 }:
    let
      sources = import ./nix/sources.nix { };
      aagl-gtk-on-nix = import ../.. { };
    in
    aagl-gtk-on-nix.an-anime-game-launcher-unwrapped.cargoDeps.overrideAttrs (_: {
      src = sources.an-anime-game-launcher;
      cargoSha256 = sha256;
    })
  ")"
  gronnedJson="$gronnedJson"$'\n'"json[\"an-anime-game-launcher\"].cargoSha256 = \"$aaglCargoSha\";"
  gron -u <<< "$gronnedJson" | jq -r '.' --indent 4 > "$sourceJson"
}

getAttribute(){
  jq -r ".[\"$1\"].$2" "$sourceJson"
}

aaglOldRev="$(getAttribute an-anime-game-launcher rev)"

niv init
niv update

aaglNewRev="$(getAttribute an-anime-game-launcher rev)"

updateCargoSha
