# medium, milligram and sepia are commented out as they require external fonts
let
  updateBorder = theme:
    if theme ? cmed
    then theme // {border = "1px solid ${theme.cmed}";}
    else theme;
in {
  light = updateBorder {};

  personal-light = updateBorder {
    clink = "#2e6f40";
    cemph = "#253d2c";
  };

  dark = updateBorder {
    cdark = ''#999'';
    clight = ''#333'';
    cmed = ''#566'';
    clink = ''#1ad'';
    # foreground
    cfg = ''#cecbc4'';
    cemph = ''#0b9'';
    # background
    cbg = ''#252220'';
    cemphbg = ''#0b91'';
  };

  personal-dark = updateBorder {
    cdark = ''#999'';
    clight = ''#262a2b'';
    cmed = ''#566'';
    clink = ''#68BA7F'';
    # foreground
    cfg = ''#eeeeee'';
    cemph = ''#0b9'';
    # background
    cbg = ''#181a1b'';
    cemphbg = ''#0b91'';
  };

  # sepia = updateBorder {
  #   rem = ''14pt'';
  #   width = ''48rem'';
  #   font-p = ''1em/1.6 'Libertinus Serif', Times, serif'';
  #   font-h = ''1em/1.6 'Libertinus Sans', Helvetica, sans'';
  #   font-c = ''85%/1.4 monospace'';
  #   ornament = ''"∞ ∞ ∞"''; # ''"❦ ❦ ❦"''; "☙ ❧";
  #   cdark = ''#6c605c'';
  #   clight = ''#f3efea'';
  #   cmed = ''#a8928e'';
  #   clink = ''#bd0000'';
  #   # foreground  | color
  #   cfg = ''#433'';
  #   cbg = ''#fefbf4'';
  #   # background
  #   cemph = ''#a35403'';
  #   cemphbg = ''#a3540310'';
  # };

  # milligram = updateBorder {
  #   navpos = ''fixed'';
  #   rem = ''11pt'';
  #   width = ''800px'';
  #   font-p = ''300 1em/1.6 'Roboto', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif'';
  #   font-h = ''300 1em/1.3 'Roboto', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif'';
  #   font-c = ''86%/1.4 monospace'';
  #   ornament = ''"‹‹‹ ›››"'';
  #   cdark = ''#6c605c'';
  #   clight = ''#f4f5f6'';
  #   cmed = ''#d1d1d1'';
  #   clink = ''#9b4dca'';
  #   # foreground
  #   cfg = ''#606c76'';
  #   cemph = ''#9b4dca'';
  #   # background
  #   cbg = ''#fff'';
  #   cemphbg = ''#9b4dca10'';
  # };

  pure = updateBorder {
    navpos = ''absolute'';
    width = ''768px'';
    rem = ''18px'';
    font-p = ''1em/1.6 Helvetica,Arial,sans-serif'';
    font-h = ''1em/1.6 Helvetica,Arial,sans-serif'';
    font-c = ''86%/1.4 monospace'';
    ornament = ''"‹‹‹ ›››"'';
    cdark = ''#777'';
    clight = ''#f8f8ff'';
    cmed = ''#e6e6e6'';
    clink = ''#3b8bba'';
    # foreground
    cfg = ''#777'';
    cemph = ''#1f8dd6'';
    # background
    cbg = ''#fff'';
    cemphbg = ''#1f8dd610'';
  };

  sakura = updateBorder {
    navpos = ''absolute'';
    width = ''684px'';
    rem = ''18px'';
    font-p = ''1em/1.5 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif'';
    font-h = ''1em/1.5 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif'';
    font-c = ''.8em/1.4 monospace'';
    ornament = ''""'';
    cdark = ''#4a4a4a'';
    clight = ''#f1f1f1'';
    cmed = ''#d1d1d1'';
    clink = ''#1d7484'';
    # foreground
    cfg = ''#4a4a4a'';
    cemph = ''#982c61'';
    # background
    cbg = ''#f9f9f9'';
    cemphbg = ''#982c6110'';
  };

  skeleton = updateBorder {
    navpos = ''absolute'';
    rem = ''15px'';
    width = ''800px'';
    font-p = ''1em/1.6 "Raleway", "HelveticaNeue", "Helvetica Neue", Helvetica, Arial, sans-serif'';
    font-h = ''1em/1.6 "Raleway", "HelveticaNeue", "Helvetica Neue", Helvetica, Arial, sans-serif'';
    font-c = ''.9em/1.4 monospace'';
    ornament = ''"───────"'';
    cdark = ''#4a4a4a'';
    clight = ''#f1f1f1'';
    cmed = ''#e1e1e1'';
    clink = ''#1eaedb'';
    # foreground
    cfg = ''#222'';
    cemph = ''#0fa0ce'';
    # background
    cbg = ''#fff'';
    cemphbg = ''#0fa0ce10'';
  };

  bootstrap = updateBorder {
    rem = ''16px'';
    navpos = ''absolute'';
    width = ''960px'';
    font-p = ''1em/1.6 system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif'';
    font-h = ''1em/1.6 "Raleway", "HelveticaNeue", "Helvetica Neue", Helvetica, Arial, sans-serif'';
    font-c = ''.9em/1.4 SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace'';
    ornament = ''""'';
    cdark = ''#343a40'';
    clight = ''#f8f9fa'';
    cmed = ''#6c757d'';
    clink = ''#0d6efd'';
    # foreground
    cfg = ''#212529'';
    cemph = ''#7952b3'';
    # background
    cbg = ''#fff'';
    cemphbg = ''#7952b310'';
  };

  medium = updateBorder {
    rem = ''19px'';
    navpos = ''absolute'';
    width = ''720px'';
    font-p = ''1em/1.6 'Lora', serif'';
    font-h = ''.9em/1.4 'Archivo', sans !important'';
    font-c = ''.9em/1.4 Consolas,"Liberation Mono","Courier New",monospace'';
    ornament = ''""'';
    cdark = ''#343a40'';
    clight = ''#fafafa'';
    cmed = ''#757575'';
    clink = ''#1a8917'';
    # foreground
    cfg = ''#292929'';
    cemph = ''#1a8917'';
    # background
    cbg = ''#fff'';
    cemphbg = ''#1a891710'';
  };

  tufte = updateBorder {
    rem = ''15px'';
    navpos = ''absolute'';
    width = ''800px'';
    font-p = ''1.4em/2 et-book, Palatino, "Palatino Linotype", "Palatino LT STD", "Book Antiqua", Georgia, serif'';
    font-h = ''1.4em/1.5 et-book, Palatino, "Palatino Linotype", "Palatino LT STD", "Book Antiqua", Georgia, serif'';
    font-c = ''.9em/1.4 Consolas,"Liberation Mono","Courier New",monospace'';
    ornament = ''""'';
    cdark = ''#111'';
    clight = ''#fffff8'';
    cmed = ''#b4d5fe'';
    clink = ''#111'';
    cemph = ''#111'';
    # foreground
    cfg = ''#111'';
    # background
    cbg = ''#fffff8'';
  };
}
