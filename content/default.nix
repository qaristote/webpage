{ html, make, ... }:

let
  sectionTemplate = section: {
    inherit (section) title priority;
    body = html.section { id = section.title; } [
      (html.h1 section.title)
      section.body
    ];
  };
  makeSection = path: sectionTemplate (make path { });
in builtins.map makeSection [
  ./basics.html.nix
  ./education.html.nix
  ./experience.html.nix
  # ./languages.html.nix
  ./publications.html.nix
]
