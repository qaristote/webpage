{
  html,
  data,
  lib,
  ...
}:
let
  attrValsOpt =
    attrs: attrSet: lib.attrVals (builtins.filter (attr: lib.hasAttr attr attrSet) attrs) attrSet;
  concatStringsPrefix =
    prefix: strings: lib.concatStrings (builtins.map (string: prefix + string) strings);
  concatStringsSuffix =
    suffix: strings: lib.concatStrings (builtins.map (string: string + suffix) strings);
  format =
    publication:
    with html;
    with publication;
    {
      inherit
        id
        title
        url
        year
        abstract
        cite
        ;
    }
    // (
      let
        authorsOther = lib.remove "${data.basics.name.first} ${data.basics.name.last}" (
          builtins.map (
            author:
            with author;
            lib.concatStringsSep " " (
              [ given ] ++ lib.optional (author ? non-dropping-particle) non-dropping-particle ++ [ family ]
            )
          ) author
        );
      in
      lib.optionalAttrs (authorsOther != [ ]) {
        authors = "With ${lib.concatStringsSep ", " authorsOther}";
      }
    )
    // lib.optionalAttrs (publication ? note) {
      note = publication.note;
    }
    // lib.optionalAttrs (publication ? container-title) {
      published =
        "In ${em container-title}"
        + concatStringsPrefix ", " (attrValsOpt [ "volume" "issue" "publisher" ] publication);
    }
    // lib.optionalAttrs (publication ? event-title) {
      published = "At ${em event-title}";
    }
    // lib.optionalAttrs (publication ? DOI) {
      doi = "${small "DOI"}: ${href "https://doi.org/${DOI}" (code DOI)}";
    };
  listResearch =
    collection:
    with html;
    section [
      (dl (
        for (sort.reverse.byPath [ "issued" "date-parts" ] collection) (
          publication:
          let
            formatted = format publication;
          in
          with formatted;
          lines [
            (dt { id = "Writings#${id}"; } "${href { target = "_blank"; } url (em title)} (${year})")
            (dd [
              (concatStringsSuffix ". " (attrValsOpt [ "authors" "note" "published" "doi" ] formatted))
              (details [
                (summary "More")
                (dl [
                  (dt "Abstract.")
                  (dd (blockquote abstract))
                  (dt "Cite.")
                  (
                    let
                      citeWith =
                        title: type:
                        details [
                          (summary title)
                          (pre (code (lib.readFile "${data.files}/biblio/${type}/${id}")))
                        ];
                    in
                    dd [
                      (citeWith "BibLaTeX" "biblatex")
                      (citeWith "BibTeX" "bibtex")
                      (citeWith "CSL JSON" "csljson")
                    ]
                  )
                ])
              ])
            ])
          ]
        )
      ))
    ];
in
{
  conferences = listResearch data.research.conferences;
  journals = listResearch data.research.journals;
  misc = listResearch data.research.misc;
  reports = listResearch data.research.reports;
}
