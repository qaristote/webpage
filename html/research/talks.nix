{
  html,
  data,
  lib,
  ...
}: let
  matchFirst = regexp: str: let
    results = builtins.match regexp str;
  in
    if results == null
    then null
    else builtins.head results;
  join = url: name: with html; lib.optionalString (url != null) " · ${href url "${icon "las la-paperclip"} ${name}"}";
  talks = data.publications.talks;
in
  with html;
    dl (for (sort.reverse.byPath ["issued" "date-parts"] talks) (item:
      with item; let
        date-parts = builtins.head issued.date-parts;
        date = {
          year = builtins.elemAt date-parts 0;
          month = builtins.elemAt date-parts 1;
          day = builtins.elemAt date-parts 2;
        };
        extra =
          if item ? note
          then note
          else "";
        abstractURL = matchFirst ".*abstract: ([^\n ]*).*" extra;
        slidesURL = matchFirst ".*slides: ([^\n ]*).*" extra;
        # broken because of tabs
        # paperURL = let
        #   paperId = matchFirst "([A-z0-9]*[0-9]{4})[a-z]" id;
        # in
        #   if paperId == null
        #   then null
        #   else "#Writings#${paperId}";
      in [
        (dt [
          ((
            if abstractURL == null
            then (x: x)
            else href abstractURL
          ) (em title))
        ])
        (dd [
          (with (makeDate date); tag pretty)
          "@ ${href url event-title}, ${publisher-place}"
          (join slidesURL "slides")
          # broken because of tabs
          # (join paperURL "paper")
          (details [
            (summary "More")
            (
              dl (
                lib.optionals (item ? abstract) [
                  (dt "Abstract.")
                  (dd (blockquote abstract))
                ]
                ++ [
                  (dt "Cite.")
                  (let
                    citeWith = title: type:
                      details [
                        (summary title)
                        (pre (code (
                          lib.readFile "${data.publications.files}/${type}/${id}"
                        )))
                      ];
                  in
                    dd [
                      (citeWith "BibLaTeX" "biblatex")
                      (citeWith "BibTeX" "bibtex")
                      (citeWith "CSL JSON" "csljson")
                    ])
                ]
              )
            )
          ])
        ])
      ]))
