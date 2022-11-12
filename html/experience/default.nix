{ html, data, lib, ... }:

let experience = data.experience;
in {
  title = "Experience";
  priority = 20;
  body = with html;
    dl (for (sort.reverse.byPath [ "date" "start" ] experience) (item:
      with item;
      lines [
        (dt [
          (with institution; "${position} @ ${href url name}, ${location}")
          br
          (small (lib.concatStringsSep " · "
            ([ (with date; timerange start end) ]
              ++ lib.optional (lib.hasAttr "supervisors" item)
              "supervised by ${
                lib.concatStringsSep " "
                (for supervisors (supervisor: with supervisor; href url name))
              }" ++ lib.optional (lib.hasAttr "assets" item)
              (lib.concatStringsSep " " (for assets
                (asset: with asset; href "#Publications#${id}" "${icon "las la-paperclip"} ${name}"))))))
        ])
        (dd description)
      ]));
}
