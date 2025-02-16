{
  html,
  data,
  lib,
  ...
}: let
  attrValsOpt = attrs: attrSet:
    lib.attrVals (builtins.filter (attr: lib.hasAttr attr attrSet) attrs)
    attrSet;
  concatStringsPrefix = prefix: strings:
    lib.concatStrings (builtins.map (string: prefix + string) strings);
  concatStringsSuffix = suffix: strings:
    lib.concatStrings (builtins.map (string: string + suffix) strings);
  format = publication:
    with html;
    with publication;
      {
        inherit id title url year abstract cite;
      }
      // (let
        authorsOther =
          lib.remove "${data.basics.name.first} ${data.basics.name.last}"
          (builtins.map (author: "${author.given} ${author.family}") author);
      in
        lib.optionalAttrs (authorsOther != []) {
          authors = "With ${lib.concatStringsSep ", " authorsOther}";
        })
      // lib.optionalAttrs (publication ? note) {
        note = publication.note;
      }
      // lib.optionalAttrs (publication ? container-title) {
        published =
          "In ${em container-title}"
          + concatStringsPrefix ", "
          (attrValsOpt ["volume" "issue" "publisher"] publication);
      }
      // lib.optionalAttrs (publication ? event-title) {
        published = "At ${em event-title}";
      }
      // lib.optionalAttrs (publication ? ISBN) {
        isbn = "${small "ISBN"}: ${ISBN}";
      }
      // lib.optionalAttrs (publication ? ISSN) {
        issn = "${small "ISSN"}: ${ISSN}";
      }
      // lib.optionalAttrs (publication ? DOI) {
        doi = "${small "DOI"}: ${href "https://doi.org/${DOI}" (code DOI)}";
      };
  listPublications = collection: collectionTitle:
    with html;
      section {id = "Publications#${collectionTitle}";} [
        (h2 collectionTitle)
        (dl (for (sort.reverse.byPath ["issued" "date-parts"] collection)
          (publication: let
            formatted = format publication;
          in
            with formatted;
              lines [
                (dt {id = "Publications#${id}";}
                  "${href {target = "_blank";} url title} (${year})")
                (dd [
                  (concatStringsSuffix ". "
                    (attrValsOpt ["authors" "note" "published" "isbn" "issn" "doi"]
                      formatted))
                  (details [
                    (summary "More")
                    (dl [
                      (dt "Abstract.")
                      (dd (blockquote abstract))
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
                    ])
                  ])
                ])
              ])))
      ];
in {
  title = "Publications";
  priority = 10;
  body = with html;
    lines [
      (listPublications data.publications.selected "Selected works")
      (listPublications (with data.publications; lib.subtractLists selected all) "Other works")
    ];
}
