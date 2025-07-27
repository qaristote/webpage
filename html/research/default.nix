{
  make,
  html,
  ...
}: let
  writings = make ./writings.nix {};
  talks = make ./talks.nix {};
in {
  title = "Research";
  priority = 10;
  body = with html;
    tabbox "research" [
      {
        id = "conferences";
        checked = true;
        title = "Conference papers";
        content = writings.conferences;
      }
      {
        id = "journals";
        title = "Journal papers";
        content = writings.journals;
      }
      {
        id = "misc";
        title = "Non-peer-reviewed";
        content = writings.misc;
      }
      {
        id = "reports";
        title = "Reports";
        content = writings.reports;
      }
      {
        id = "talks";
        title = "Talks";
        content = talks;
      }
    ];
}
