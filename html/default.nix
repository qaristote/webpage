{
  html,
  make,
  data,
  ...
}: let
  sections = html.sort.byKey "priority" (make ./sections.nix {});
  preloadFont = href:
    html.linkWith {
      inherit href;
      rel = "preload";
      as = "font";
    };
  fullname = with data.basics.name; "${first} ${last}";
in
  with html;
    doctype "html"
    + html.html {lang = "en";} [
      (head [
        # Basic page needs
        (metaWith {charset = "utf-8";})
        (title fullname)
        (metaWith {
          name = "description";
          content = "Personal webpage of ${fullname}";
        })
        (metaWith {
          name = "author";
          content = "Quentin Aristote";
        })
        (metaWith {
          http-equiv = "x-ua-compatible";
          content = "ie=edge";
        })
        # Mobile specific needs
        (metaWith {
          name = "viewport";
          content = "width=device-width, initial-scale=1";
        })
        # Font
        (linkWith {
          rel = "stylesheet";
          href = "/static/css/fonts/line-awesome/line-awesome.min.css";
        })
        (preloadFont "/static/css/fonts/line-awesome/webfonts/la-solid-900.woff2")
        (preloadFont "/static/css/fonts/line-awesome/webfonts/la-brands-400.woff2")
        # CSS
        (linkWith {
          rel = "stylesheet";
          href = "/static/css/classless.min.css";
        })
        # Favicon
        (linkWith {
          rel = "icon";
          type = "image/png";
          href = "/static/icon.png";
        })
      ])
      (body [
        (main {role = "main";} (for sections (section: section.body)))
        (footer "Webpage ${
            href "#Software#aristoteWebpage" "generated"
          } with the help of ${href "https://nixos.org/" "Nix"} and ${
            href "https://classless.de/" "Classless CSS"
          }, and compressed with the help of ${
            href "https://go.tacodewolff.nl/minify" "minify"
          }, ${
            href "https://github.com/uncss/uncss" "uncss"
          }, ${href "https://yui.github.io/yuicompressor/" "YUI Compressor"} and ${
            href "https://imagemagick.org/" "ImageMagick"
          }.")
      ])
    ]
