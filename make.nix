{
  pkgs,
  dataSrc,
}: let
  html = (import ./lib {inherit (pkgs) lib;}).pp.html;
  data = import dataSrc {
    inherit pkgs;
    markup = html;
  };
  commonArgs = {
    inherit data make;
    inherit (pkgs) lib;
    inherit html;
  };
  make = path: overrides: let
    f = import path;
  in
    f ((builtins.intersectAttrs (builtins.functionArgs f) commonArgs)
      // overrides);
in
  make
