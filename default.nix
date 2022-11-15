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
      "printing"
      "grid"
    ] // setOption "navpos" "fixed"));

in pkgs.callPackage ({
  # Packages
  line-awesome, line-awesome-css, uncss, yuicompressor,
  # Source files
  index-html ? indexHTML, classless-css ? classlessCSS, files ? data.files
  , icon ? ./static/icon.png }:
  let
    compress = "${yuicompressor}/bin/yuicompressor";
    clean = "${uncss}/bin/uncss";
  in pkgs.runCommand "webpage" { } ''
    set -o xtrace
    mkdir $out && pushd "$_"
    ln -sT ${index-html} index.html
    popd

    mkdir $out/static && pushd "$_"
    ln -sT ${icon} icon.png
    ln -sT ${files} files
    popd

    mkdir -p $out/static/css && pushd "$_"
    ${clean} ${index-html} --stylesheets file://${classless-css} \
    | ${compress} --type css >classless.min.css
    popd

    mkdir -p $out/static/css/fonts/line-awesome && pushd "$_"
    ln -sT ${line-awesome}/share/fonts/woff2 webfonts
    ${clean} ${index-html} --stylesheets file://${line-awesome-css} \
    | ${compress} --type css >line-awesome.min.css
    popd

  '') { }

