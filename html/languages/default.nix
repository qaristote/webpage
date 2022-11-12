{ html, data, ... }:

let languages = data.languages;
in {
  title = "Languages";
  priority = 40;
  body = with html;
    lines (for languages
      (language: with language; "${icon} ${name} (${proficiency})"));
}
