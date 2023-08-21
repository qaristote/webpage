{ html, data, lib, ... }:

let
  software = data.software;
  format = softwarePiece:
    with html;
    with softwarePiece;
    {
      inherit id title abstract;
      url = URL;
    } // (let
      authorsOther = lib.remove data.basics.name
        (builtins.map (author: "${author.given} ${author.family}") author);
    in lib.optionalAttrs (authorsOther != [ ]) {
      authors = "With ${lib.concatStringsSep ", " authorsOther}";
    });
in {
  title = "Software";
  priority = 15;
  body = with html;
    dl (for (sort.byPath [ "title" ] software) (softwarePiece:
      let formatted = format softwarePiece;
      in with formatted; [
        (dt { id = "Software#${id}"; } (href { target = "_blank"; } url title))
        (dd abstract)
      ]));
}
