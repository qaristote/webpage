{
  html,
  data,
  lib,
  ...
}: let
  publications = data.publications;
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
      // lib.optionalAttrs (publication ? container-title) {
        published =
          "In ${em container-title}"
          + concatStringsPrefix ", "
          (attrValsOpt ["volume" "issue" "publisher"] publication);
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
in {
  title = "Publications";
  priority = 10;
  body = with html;
    dl (for (sort.reverse.byPath ["issued" "date-parts"] publications)
      (publication: let
        formatted = format publication;
      in
        with formatted;
          lines [
            (dt {id = "Publications#${id}";}
              "${href {target = "_blank";} url title} (${year})")
            (dd [
              (concatStringsSuffix ". "
                (attrValsOpt ["authors" "published" "isbn" "issn" "doi"]
                  formatted))
              (details [
                (summary "More")
                (dl [
                  (dt "Abstract.")
                  (dd (blockquote abstract))
                  (dt "Cite.")
                  (let
                    citeWith = title: attr:
                      details [
                        (summary title)
                        (pre (code (lib.getAttr attr cite)))
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
          ]));
}
