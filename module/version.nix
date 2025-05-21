{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.aagl;
  aaglReleaseBranch = "25.11";
in
{
  options.aagl = {
    enableNixpkgsReleaseBranchCheck = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Determines whether to check for release version mismatch between AAGL
        and Nixpkgs. Using mismatched versions is likely to cause errors and
        unexpected behavior.
      '';
    };
  };

  config = let
    nixpkgsRelease = lib.trivial.release;
  in mkIf cfg.enableNixpkgsReleaseBranchCheck {
    warnings = if nixpkgsRelease != aaglReleaseBranch then [
      ''

        The aagl-gtk-on-nix release branch is ${aaglReleaseBranch}, but the current
        Nixpkgs release is ${nixpkgsRelease}. This mismatch may cause errors and
        unexpected behavior. It is recommended to use a release of
        aagl-gtk-on-nix that matches your Nixpkgs release.

        If you insist on using this version, you can disable this warning by
        setting

        aagl.enableNixpkgsReleaseBranchCheck = false;

        in your configuration.
      ''
    ] else [];
  };
}
