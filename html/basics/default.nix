{ html, data, ... }:

let basics = data.basics;
in {
  title = "About me";
  priority = 0;
  body = with html;
    with data.basics;
    lines [
      (div { class = "row"; } [
        (div { class = "col"; } [ (imgWith { src = avatar; }) ])
        (div { class = "col"; } (dl [
          (dt "${icon "las la-at"} e-mail")
          (dd (for email (email: "${mailto email.address} (${email.name}) ${br}")))
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
