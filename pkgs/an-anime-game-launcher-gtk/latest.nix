{ an-anime-game-launcher-gtk-unwrapped
, customDxvk ? null
, customDxvkAsync ? null
, customGEProton ? null
, customLutris ? null
, customSoda ? null
, customWineGEProton ? null
, customIcon ? null
}:
let
  sources = import ./nix/sources.nix { };
  unwrapped = an-anime-game-launcher-gtk-unwrapped.overrideAttrs (
    old: with sources.an-anime-game-launcher-gtk; rec {
      version = builtins.substring 0 7 rev;
      src = sources.an-anime-game-launcher-gtk;
      cargoDeps = old.cargoDeps.overrideAttrs (old: rec {
        inherit src;
        outputHash = cargoSha256;
      });
    }
  );
in
unwrapped.override {
  inherit
    customDxvk
    customDxvkAsync
    customGEProton
    customLutris
    customSoda
    customWineGEProton
    customIcon
  ;
}
