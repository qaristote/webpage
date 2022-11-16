{ html, data, lib, ... }:

let
  basics = data.basics;
  col = html.div {
    class = "col";
    style = "align-self: center";
  };
  center = container: content:
    container { style = "text-align: center"; } content;
  icon-lab = name: html.icon "lab la-${name}";
in {
  title = "About me";
  priority = 0;
  body = with html;
    with data.basics;
    lines [
      br
      (div { class = "row"; } [
        (col [
          (imgWith {
            src = avatar;
            srcset = lib.concatStringsSep ", "
              (builtins.map (size: "${avatar}.${size} ${size}w") [
                "128"
                "256"
                "512"
              ] ++ [ "${avatar} 934w" ]);
            sizes = "(max-width: 480px) 60vw, 30vw";
            loading = "lazy";
            alt = "Quentin Aristote";
            style = ''
              aspect-ratio: 1 / 1;
              border-radius: 50%;
              padding-left: 20%;
              padding-right: 20%;
            '';
          })
          (center h3 name)
          (center p (with institution; [ position br "@ ${href url name}" ]))
        ])
        (col (dl [
          (dt "${icon "las la-at"} e-mail")
          (dd (for email
            (email: "${mailto email.address} (${email.name}) ${br}")))
          (dt "${icon "las la-key"} keys")
          (dd (for keys.pgp (name: path: href path name)))
          (dt "${icon "las la-map-marker"} address")
          (dd (with location; ''
            ${number} ${street}${br}
             ${postalCode} ${city}
          ''))
          (dt "${icon "las la-globe"} online")
          (dd (for profiles (name: value:
            with value;
            "${icon-lab icon} ${
              if value ? url then
                href url name
              else
                "${name}: ${
                  lines (for profiles (name: value:
                    with value;
                    "${icon-lab icon} ${href url name}"))
                } ${br}"
            }")))
        ]))
      ])
      description
    ];
}
