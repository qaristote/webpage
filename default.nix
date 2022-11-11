{ pkgs, html, data }:

let
  commonArgs = {
    inherit data html make;
    inherit (pkgs) lib;
  };
  make = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) commonArgs)
      // overrides);
  lineAwesomeCSS = { fontsRelativeDirectory ? "./webfonts" }:
    pkgs.stdenv.mkDerivation rec {
      name = "line-awesome-css";
      version = "v1.2.1";

      src = pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/icons8/line-awesome/${version}/dist/line-awesome/css/line-awesome.min.css";
        sha256 = "sha256:zmGhjPCE8VADeYNABEZD8ymsX5AEWsstnneDaL15mFQ=";
      };

      phases = [ "installPhase" ];
      installPhase = ''
        cp $src $out
        substituteInPlace $out --replace '../fonts' '${fontsRelativeDirectory}'
      '';
    };

  webpage = { line-awesome, line-awesome-css ? lineAwesomeCSS
    , source ? builtins.toFile "index.html" (make ./index.html.nix { })
    , files ? data.files,
      icon ? ./static/icon.png }:
    pkgs.runCommand "webpage" { } ''
      mkdir "$out"
      ln -sT "${source}" "$out/index.html"
      mkdir "$out/static"
      ln -sT "${icon}" "$out/static/icon.png"
      ln -sT "${files}" "$out/static/files"
      mkdir -p "$out/static/css/fonts/line-awesome"
      ln -sT "${line-awesome}/share/fonts/woff2" "$out/static/css/fonts/line-awesome/webfonts"
      ln -sT "${line-awesome-css {}}" "$out/static/css/fonts/line-awesome/line-awesome.min.css"
    '';
in pkgs.callPackage webpage { }
