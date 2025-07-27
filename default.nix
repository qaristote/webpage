{
  stdenvNoCC,
  # Packages
  line-awesome,
  line-awesome-css,
  uncss,
  yuicompressor,
  imagemagick,
  nix,
  minify,
  # Source files
  nixpkgsSrc,
  src,
  data,
  # Parameters
  theme ? "light",
}: let
  compress = "${yuicompressor}/bin/yuicompressor";
  clean = "${uncss}/bin/uncss";
  compressJPEG = size: image: ''
    ${imagemagick}/bin/magick  ${image} \
                               -sampling-factor 4:2:0 \
                               -strip \
                               -quality 85 \
                               -interlace JPEG \
                               -colorspace RGB \
                               -resize ${size}x${size} \
                               -colorspace sRGB \
                               ${image}.${size}
  '';
  mkPushDir = dir: ''mkdir -p ${dir} && pushd "$_"'';
  nixEvalExpr = "${nix}/bin/nix --extra-experimental-features nix-command --extra-experimental-features flakes eval --impure --raw --show-trace --expr";
  make = "import $src/make.nix {pkgs = import ${nixpkgsSrc} {}; dataSrc = $src/data;}";
in
  stdenvNoCC.mkDerivation {
    name = "webpage";
    requiredSystemFeatures = ["recursive-nix"];
    subsrcs = [src data];
    src = "webpage-src";
    unpackPhase = ''
      read -ra srcs <<< "$subsrcs"
      mkdir $src
      ln -s ''${srcs[0]}/* $src/
      ln -s ''${srcs[1]} $src/data
      ls $src
    '';
    installPhase = ''
      # set -o xtrace
      pushd $src
      src=$(pwd)
      popd
      ${mkPushDir "$out"} # $out/

      # build HTML
      ${nixEvalExpr} "
        ${make} $src/html {}
      " > index.html
      ${minify}/bin/minify index.html --output index.html

      # copy static files
      cp -r $src/static/ .
      ln -s static/robots.txt
      chmod 777 static
      pushd static # $out/static/
      cp -r ${data}/files .
      chmod 777 files
      pushd files # $out/static/files/
      ${compressJPEG "128" "avatar.jpg"}
      ${compressJPEG "256" "avatar.jpg"}
      ${compressJPEG "512" "avatar.jpg"}

      popd # $out/static/

      # build and compress CSS
      ${mkPushDir "css"} # $out/static/css/
      ${nixEvalExpr} "
        ${make} $src/css/classless.nix ({
           big-first-letter = true;
           details-cards = true;
           grid = true;
           hr = false;
           navbar = true;
           tables = false;
           tooltip-citations = true;
           printing = true;
           tabs = true;
        } // (import $src/css/themes.nix).${theme})
      " > classless.css
      ${clean} $out/index.html --stylesheets file://$(pwd)/classless.css \
      | ${compress} --type css >classless.min.css
      rm classless.css
      ${mkPushDir "fonts/line-awesome"} # $out/static/css/fonts/lineawesome
      ln -s ${line-awesome}/share/fonts/woff2 webfonts
      ${clean} $out/index.html --stylesheets file://${line-awesome-css} \
      | ${compress} --type css >line-awesome.min.css

      popd # $out/static
      popd # $out/
      popd #
    '';
  }
