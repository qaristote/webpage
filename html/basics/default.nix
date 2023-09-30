{
  html,
  data,
  lib,
  ...
}: let
  basics =
    data.basics
    // {
      fullname = with data.basics.name; "${first} ${last}";
    };
  col = html.div {
    class = "col";
    style = "align-self: center";
  };
  center = container: content:
    container {style = "text-align: center";} content;
  icon-lab = name: html.icon "lab la-${name}";
in {
  title = "About me";
  priority = 0;
  body = with html;
  with basics; [
    br
    (div {class = "row";} [
      (col [
        (imgWith {
          src = avatar;
          srcset =
            lib.concatStringsSep ", "
            (builtins.map (size: "${avatar}.${size} ${size}w") [
                "128"
                "256"
                "512"
              ]
              ++ ["${avatar} 934w"]);
          sizes = "(max-width: 480px) 60vw, 30vw";
          alt = fullname;
          style = ''
            aspect-ratio: 1 / 1;
            border-radius: 50%;
            margin: auto;
            display: block;
          '';
        })
        (center h3 fullname)
        (center p (with institution; [position wbr "@ ${href url name}"]))
      ])
      (col (dl [
        (dt "${icon "las la-at"} e-mail")
        (dd
          (lib.mapAttrsToList (name: value: "${mailto value} (${name}) ${br}")
            email))
        (dt "${icon "las la-key"} keys")
        (dd (for keys.pgp (name: path: href path name)))
        (dt "${icon "las la-map-marker"} address")
        (dd (with location; ''
          Office ${office}${br}
          ${number} ${street}${br}
          ${postalCode} ${city}
        ''))
        (dt "${icon "las la-globe"} online")
        (dd (for profiles (name: value:
          with value; "${icon-lab icon} ${
            if value ? url
            then href url name
            else "${name}: ${
              lines (for profiles (name: value:
                  with value; "${icon-lab icon} ${href url name}"))
            } ${br}"
          }")))
      ]))
    ])
    description
  ];
}
