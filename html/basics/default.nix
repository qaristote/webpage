{ html, data, ... }:

let
  basics = data.basics;
  col = html.div {
    class = "col";
    style = "align-self: center";
  };
  center = container: content:
    container { style = "text-align: center"; } content;
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
            style = ''
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
        ]))
      ])
      description
    ];
}
