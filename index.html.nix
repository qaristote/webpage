{ html, make, ... }:

let sections = html.sort.byKey "priority" (make ./content { });
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
      href = "https://classless.de/classless.css";
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
    (footer [ ])
  ])
]
