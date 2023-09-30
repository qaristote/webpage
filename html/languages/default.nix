{
  html,
  data,
  ...
}: let
  languages = data.languages;
in {
  title = "Languages";
  priority = 40;
  body = with html; (for languages (language:
    with language; "${
      lib.concatStrings (for icon.codepoints (codepoint: "&x${codepoint}"))
    } ${name} (${proficiency})"));
}
