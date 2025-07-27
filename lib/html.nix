{lib, ...}: let
  comment = content: "<!-- ${content} -->";
  lines = content:
    if lib.isList content
    then
      (
        if content == []
        then ""
        else lines (builtins.head content) + "\n" + lines (builtins.tail content)
      )
    else content;
  sortByFun = cmp: f: lib.sort (x: y: cmp (f x) (f y));
  sortByPath = cmp: keys: sortByFun cmp (lib.getAttrFromPath keys);
  sortByKey = cmp: key: sortByPath cmp [key];
  for = iterable: f:
    if lib.isList iterable
    then builtins.map f iterable
    else lib.mapAttrsToList f iterable;

  setAttr = attr: value: ''${attr}="${value}"'';
  tagWithAttrs = tag: attrs: "<${tag}${
    lib.concatMapStrings (x: " ${x}") (lib.mapAttrsToList setAttr attrs)
  }>";
  tryOverride = f: arg:
    if lib.isAttrs arg
    then tryOverride (attrs: content: f (arg // attrs) content)
    else f {} arg;
  container = tag:
    tryOverride
    (attrs: content: "${tagWithAttrs tag attrs}${lines content}</${tag}>");

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
    builtins.foldl' (module: tag: module // {"${tag}" = container tag;}) {}
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
  tagsEmptyFuns = builtins.foldl' (module: tag: let
    tagWith = empty tag;
  in
    module
    // {
      "${tag}With" = tagWith;
      "${tag}" = tagWith {};
    }) {}
  tagsEmpty;

  file = path: "/static/files/${path}";
  href =
    tryOverride (attrs: url: content:
      tagsContainerFuns.a ({href = url;} // attrs) content);
  icon =
    tryOverride (attrs: id: tagsContainerFuns.i (attrs // {class = id;}) "");
  mailto = tryOverride (attrs: address: href attrs "mailto:${address}" address);
  makeDate = date: let
    year = builtins.toString date.year;
    month =
      lib.optionalString (date.month < 10) "0"
      + builtins.toString date.month;
    day =
      if date ? day
      then lib.optionalString (date.day < 10) "0" + builtins.toString date.day
      else "0";
    monthPretty = builtins.head (lib.drop (date.month - 1) [
      "jan"
      "feb"
      "mar"
      "apr"
      "may"
      "jun"
      "jul"
      "aug"
      "sep"
      "oct"
      "nov"
      "dev"
    ]);
  in {
    tag = tagsContainerFuns.time {date = "${year}-${month}-${day}";};
    pretty = "${monthPretty}. " + lib.optionalString (day != "0") "${day}, " + year;
  };
  timerange = let
    print = dateValue: let
      datePretty = (makeDate (builtins.removeAttrs dateValue ["day"])).pretty;
    in
      (makeDate dateValue).tag datePretty;
  in
    start: end: "${print start} - ${print end}";
  doctype = type: ''
    <!DOCTYPE ${type}>
  '';

  tab = name: {
    id,
    checked ? false,
    title,
    content,
  }:
    with tagsContainerFuns;
      lines [
        (tagsEmptyFuns.inputWith ({
            inherit id name;
            type = "radio";
          }
          // lib.optionalAttrs checked {checked = "checked";}))
        (label {for = id;} [(small (b title))])
        (div {class = "tab";} content)
      ];
  tabbox = name: tabs: tagsContainerFuns.div {class = "tabs";} (builtins.map (tab name) tabs);
in
  tagsContainerFuns
  // tagsEmptyFuns
  // {
    inherit
      for
      comment
      container
      doctype
      empty
      file
      href
      icon
      lines
      mailto
      makeDate
      timerange
      tab
      tabbox
      ;
  }
  // {
    blockquote = tryOverride (attrs: content: tagsContainerFuns.blockquote attrs (builtins.replaceStrings ["\n"] ["<br>"] content));
  }
  // {
    sort = let
      lt = x: y: x < y;
      gt = x: y: x > y;
    in {
      byKey = sortByKey lt;
      byPath = sortByPath lt;
      byFun = sortByFun lt;
      reverse = {
        byKey = sortByKey gt;
        byPath = sortByPath gt;
        byFun = sortByFun gt;
      };
    };
  }
