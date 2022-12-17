{ html, make, ... }:

let sections = html.sort.byKey "priority" (make ./sections.nix { });
in with html;
html.html { lang = "en"; } [
  (head [
    # Basic page needs
    (metaWith { charset = "utf-8"; })
    (title "Quentin Aristote")
    (metaWith {
      name = "description";
      content = "Personal webpage of Quentin Aristote";
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
    # CSS
    (linkWith {
      rel = "stylesheet";
      href = "/static/css/classless.min.css";
    })
    # Favicon
    (linkWith {
      rel = "icon";
      type = "image/png";
      href = "static/icon.png";
    })
  ])
  (body [
    (header [
      (nav (ul ([ (li "Quentin Aristote") ] ++ for sections
        (section: li (href "#${section.title}" section.title)))))
    ])
    (main { role = "main"; } (for sections (section: section.body)))
    (footer "Webpage ${
        href "#Software#aristoteWebpage" "generated"
      } with the help of ${href "https://nixos.org/" "Nix"} and ${
        href "https://classless.de/" "Classless CSS"
      }, and compressed with the help of ${
        href "https://github.com/uncss/uncss" "uncss"
      }, ${href "https://yui.github.io/yuicompressor/" "YUI Compressor"} and ${
        href "https://imagemagick.org/" "ImageMagick"
      }.")
  ])
]
