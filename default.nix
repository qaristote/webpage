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

  indexHTML = builtins.toFile "index.html" (make ./html { });
  classlessCSS = let
    setOption = option: value: { "${option}" = value; };
    setOptions = options: value:
      builtins.foldl' (tmp: option: tmp // setOption option value) { } options;
    enable = options: setOptions options true;
    disable = options: setOptions options false;
  in builtins.toFile "classless.css" (make ./css/classless.nix
    (disable [ "tables" "hr" ] // enable [
      "headings-advanced"
      "tooltip-citations"
      "navbar"
      "details-cards"
      "big-first-letter"
      "ornaments"
      "printing"
      "grid"
    ] // setOption "navpos" "fixed"));
  lineAwesomeCSS = { fontsRelativeDirectory ? "./webfonts" }:
    pkgs.stdenv.mkDerivation rec {
      name = "line-awesome-css";
      version = "v1.2.1";

      src = pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/icons8/line-awesome/${version}/dist/line-awesome/css/line-awesome.css";
        sha256 = "sha256:GU24Xz6l3Ww4ZCcL2ByssTe04fHBRz9k2aZVRdj0xm4=";
      };

      phases = [ "installPhase" ];
      installPhase = ''
        cp $src $out
        substituteInPlace $out --replace '../fonts' '${fontsRelativeDirectory}'
      '';
    };

  webpage = { # Packages
    line-awesome, yuicompressor,
    # Source files
    index-html ? indexHTML, classless-css ? classlessCSS
    , line-awesome-css ? lineAwesomeCSS, files ? data.files
    , icon ? ./static/icon.png }:
    let compress = "'${yuicompressor}/bin/yuicompressor'";
    in pkgs.runCommand "webpage" { } ''
      mkdir "$out"
      ln -sT "${index-html}" "$out/index.html"
      mkdir "$out/static"
      ln -sT "${icon}" "$out/static/icon.png"
      ln -sT "${files}" "$out/static/files"
      mkdir -p "$out/static/css"
      ${compress} "${classless-css}" --type css -o "$out/static/css/classless.min.css"
      mkdir -p "$out/static/css/fonts/line-awesome"
      ln -sT "${line-awesome}/share/fonts/woff2" "$out/static/css/fonts/line-awesome/webfonts"
      ${compress} "${
        line-awesome-css { }
      }" --type css -o "$out/static/css/fonts/line-awesome/line-awesome.min.css"
    '';
in pkgs.callPackage webpage { }
