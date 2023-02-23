{ lib, ... }:

let
  comment = content: "<!-- ${content} -->";
  lines = lib.concatStringsSep "\n";
  sortByPath = cmp: keys:
    lib.sort
    (x: y: cmp (lib.getAttrFromPath keys x) (lib.getAttrFromPath keys y));
  sortByKey = cmp: key: sortByPath cmp [ key ];
  for = iterable: f:
    if lib.isList iterable then
      builtins.map f iterable
    else
      lib.mapAttrsToList f iterable;

  setAttr = attr: value: ''${attr}="${value}"'';
  tagWithAttrs = tag: attrs:
    "<${tag}${
      lib.concatMapStrings (x: " ${x}") (lib.mapAttrsToList setAttr attrs)
    }>";
  lineOrLines = f: content:
    if lib.isList content then f (lines content) else f content;
  tryOverride = f: arg:
    if lib.isAttrs arg then
      tryOverride (attrs: content: f (arg // attrs) content)
    else
      f { } arg;
  container = tag:
    tryOverride (attrs:
      lineOrLines (content: "${tagWithAttrs tag attrs}${content}</${tag}>"));

  empty = tagWithAttrs;

  tagsContainer = [
    # Main root
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#main_root
    "html"
    # Document metadata
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#document_metadata
    "head"
    "style"
    "title"
    # Sectioning root
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#sectioning_root
    "body"
    # Content sectioning
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#content_sectioning
    "address"
    "article"
    "aside"
    "footer"
    "header"
    "h1"
    "h2"
    "h3"
    "h4"
    "h5"
    "h6"
    "main"
    "nav"
    "section"
    # Text content
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#text_content
    "blockquote"
    "dd"
    "div"
    "dl"
    "dt"
    "figcaption"
    "figure"
    "li"
    "menu"
    "ol"
    "p"
    "pre"
    "ul"
    # Inline text semantics
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#inline_text_semantics
    "a"
    "abbr"
    "b"
    "bdi"
    "bdo"
    "cite"
    "code"
    "data"
    "dfn"
    "em"
    "i"
    "kbd"
    "mark"
    "q"
    "rp"
    "rt"
    "ruby"
    "s"
    "samp"
    "small"
    "span"
    "strong"
    "sub"
    "time"
    "u"
    "var"
    # Image and multimedia
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#image_and_multimedia
    "audio"
    "map"
    "track"
    "video"
    # Embedded content
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#embedded_content
    "iframe"
    "object"
    "picture"
    "portal"
    "source"
    # SVG and MathML
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#svg_and_mathml
    "svg"
    "math"
    # Scripting
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#scripting
    "canvas"
    "noscript"
    "script"
    # Demarcating edits
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#demarcating_edits
    "del"
    "ins"
    # Table content
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#table_content
    "caption"
    "colgroup"
    "table"
    "tbody"
    "td"
    "tfoot"
    "th"
    "thead"
    "tr"
    # Forms
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#forms
    "button"
    "datalist"
    "fieldset"
    "form"
    "label"
    "legend"
    "meter"
    "optgroup"
    "option"
    "output"
    "progress"
    "select"
    "textarea"
    # Interactive elements
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#interactive_elements
    "details"
    "dialog"
    "summary"
    # Web components
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element#web_components
    "slot"
    "template"
  ];
  tagsContainerFuns =
    builtins.foldl' (module: tag: module // { "${tag}" = container tag; }) { }
    tagsContainer;

  tagsEmpty = [
    "area"
    "base"
    "br"
    "col"
    "embed"
    "hr"
    "img"
    "input"
    "keygen"
    "link"
    "meta"
    "param"
    "source"
    "track"
    "wbr"
  ];
  tagsEmptyFuns = builtins.foldl' (module: tag:
    let tagWith = empty tag;
    in module // {
      "${tag}With" = tagWith;
      "${tag}" = tagWith { };
    }) { } tagsEmpty;

  file = path: "/static/files/${path}";
  href = tryOverride (attrs: url: content:
    tagsContainerFuns.a ({ href = url; } // attrs) content);
  icon =
    tryOverride (attrs: id: tagsContainerFuns.i (attrs // { class = id; }) "");
  mailto = tryOverride (attrs: address: href attrs "mailto:${address}" address);
  timerange = start: end:
    "${tagsContainerFuns.time { date = start; } start} - ${
      tagsContainerFuns.time { date = end; } end
    }";
  doctype = type: "<!DOCTYPE ${type}>\n";
in tagsContainerFuns // tagsEmptyFuns // {
  inherit for comment container doctype empty file href icon lines mailto timerange;
} // {
  sort = let
    lt = x: y: x < y;
    gt = x: y: x > y;
  in {
    byKey = sortByKey lt;
    byPath = sortByPath lt;
    reverse = {
      byKey = sortByKey gt;
      byPath = sortByPath gt;
    };
  };
}
