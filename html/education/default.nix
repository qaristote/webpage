{
  html,
  data,
  lib,
  ...
}: let
  education = data.education;
  sortByDateStart =
    html.sort.reverse.byFun
    (item: with item.date.start; day + 100 * month + 10000 * year);
in {
  title = "Education";
  priority = 30;
  body = with html;
    dl (for (sortByDateStart education) (item:
      with item; [
        (dt [
          (with institution; "${studyType} @ ${href url name}, ${location}")
          br
          (with date; small (timerange start end))
        ])
        (dd [
          (lib.optionalString (item ? years) (for (sortByDateStart years) (year:
            with year;
              details [
                (summary [
                  (with program; "${studyType} @ ${href url (abbr {title = name;} acronym)}")
                  br
                  (with date; small (timerange start end))
                ])
                description
                (for courses (category: list:
                  details [
                    (summary "${category} courses")
                    (lib.concatStringsSep " · " (lib.naturalSort list))
                  ]))
              ])))
          description
        ])
      ]));
}
