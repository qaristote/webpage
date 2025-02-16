{lib, ...}: let
  fs = lib.fileset;
in
  fs.toSource {
    root = ./.;
    fileset = fs.unions [./html ./lib ./css ./static ./make.nix];
  }
