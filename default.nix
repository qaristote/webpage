{
  stdenvNoCC,
  # Packages
  imagemagick,
  jq,
  line-awesome,
  line-awesome-css,
  minify,
  nix,
  pandoc,
  uncss,
  yuicompressor,
  # Source files
  nixpkgsSrc,
  src,
  data,
  # Parameters
  theme ? "personal-dark",
}:
let
  convert = "${pandoc}/bin/pandoc";
  parseJSON = "${jq}/bin/jq";
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
  extra-sandbox-paths = [
    "/nix/store/"
    "/nix/var/nix/"
  ];
  subsrcs = [
    src
    data
  ];
  src = "webpage-src";
  unpackPhase = ''
    read -ra srcs <<< "$subsrcs"
    mkdir $src
    ln -s ''${srcs[0]}/* $src/
    mkdir $src/data
    ln -s ''${srcs[1]}/* $src/data/
    rm $src/data/files
    mkdir $src/data/files
    ln -s ''${srcs[1]}/files/* $src/data/files/

    # burst bibliography into src files
    pushd $src
    src=$(pwd)
    popd
    pushd $src/data/files/
    chmod u+w .
    mkdir -p biblio/{biblatex,bibtex,csljson}
    pushd biblio/
    for refs in $src/data/research/*.json
    do
      ${parseJSON} --compact-output ".[]" $refs | while read -r ref
      do
        id=$(echo "$ref" | ${parseJSON} --raw-output '.id')
        echo $id
        echo "$ref" > "csljson/$id"
        cat csljson/$id
        ${convert} --from=csljson --to=biblatex --output "biblatex/$id" <<< "[ $ref ]"
        ${convert} --from=csljson --to=bibtex   --output "bibtex/$id"   <<< "[ $ref ]"
      done
    done
    popd
    chmod -R u-w .
    popd

  '';
  installPhase = ''
    export NIX_STATE_DIR=$TMPDIR/state
    export NIX_STORE_DIR=$TMPDIR/state

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
