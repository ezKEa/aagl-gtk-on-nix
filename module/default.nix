{ config, lib, pkgs, ... }:
{
  imports = [
    ./aagl.nix
    ./hrl.nix
    ./hl.nix
    ./hosts.nix
  ];
}
