{ html, data, lib, ... }:

let education = data.education;
in {
  title = "Education";
  priority = 30;
  body = with html;
    dl (for (sort.reverse.byPath [ "date" "start" ] education) (item:
      with item;
      lines [
        (dt [
          (with institution; "${studyType} @ ${href url name}, ${location}")
          br
          (with date; small (timerange start end))
        ])
        (dd [
          (lib.optionalString (lib.hasAttr "years" item) (lines
            (for (sort.reverse.byPath [ "date" "start" ] years) (year:
              with year;
              details [
                (summary [
                  (with program;
                    "${studyType} @ ${
                      href url (abbr { title = name; } acronym)
                    }")
                  br
                  (with date; small (timerange start end))
                ])
                description
                (lines (for courses (category: list:
                  details [
                    (summary "${category} courses")
                    (lib.concatStringsSep " · " (lib.naturalSort list))
                  ])))
              ]))))
          description
        ])
      ]));
}
