{
  html,
  data,
  lib,
  ...
}:
let
  experience = data.experience;
in
{
  title = "Experience";
  priority = 20;
  body =
    with html;
    dl (
      for
        (sort.reverse.byFun (item: with item.date.start; day + 100 * month + 10000 * year) experience.jobs)
        (
          item: with item; [
            (dt [
              (with institution; "${position} @ ${href url name}, ${location}")
              br
              (small (
                lib.concatStringsSep " · " (
                  [ (with date; timerange start end) ]
                  ++
                    lib.optional (item ? supervisors)
                      "supervised by ${
                        lib.concatStringsSep " " (for supervisors (supervisor: with supervisor; href url name))
                      }"
                  # ++ lib.optional (item ? assets) (lib.concatStringsSep " "
                  #   (for assets (asset:
                  #     with asset;
                  #       href "#${type}#${id}"
                  #       "${icon "las la-paperclip"} ${name}")))
                )
              ))
            ])
            (dd description)
          ]
        )
    );
}
