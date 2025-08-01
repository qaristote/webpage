# Inspired from Classless.css v1.1
# https://classless.de/
let
  defaultFont = "'Open Sans', 'DejaVu Sans', FreeSans, Helvetica, sans-serif";
  defaultFontCode = "'DejaVu Sans Mono', monospace";
in
  {
    lib,
    # Enable / disable features
    reset ? true,
    ## Base
    links ? true,
    lists ? true,
    headings ? true,
    tables ? true,
    figures ? true,
    code ? true,
    blockquotes ? true,
    time ? true,
    hr ? true,
    nav ? true,
    selection ? true,
    ## Extras
    auto-numbering ? false,
    subfigures ? false,
    listings ? false,
    tooltip-citations ? false,
    navbar ? false,
    details-cards ? false,
    big-first-letter ? false,
    ornaments ? false,
    aside ? false,
    inputs ? false,
    printing ? false,
    tabs ? false,
    ## Classes
    grid ? false,
    align ? false,
    colors ? false,
    margins ? false,
    padding ? false,
    # CSS variables
    ## Miscellaneous
    rem ? "12pt",
    width ? "50rem",
    navpos ? "absolute", # "fixed" or "absolute"
    font-p ? "1em/1.7 ${defaultFont}",
    font-h ? ".9em/1.5 ${defaultFont}",
    font-c ? ".9em/1.4 ${defaultFontCode}",
    border ? "1px solid ${cmed}",
    ornament ? "‹‹‹ ›››",
    ## Colors
    cfg ? "#433",
    cbg ? "#fff",
    cdark ? "#888",
    clight ? "#f5f6f7",
    cmed ? "#d1d1d1",
    clink ? "#07c",
    cemph ? "#088",
    cemphbg ? "#0881",
  }:
    lib.optionalString reset (
      # reset block elements
      ''
        * { box-sizing: border-box; border-spacing: 0; margin: 0; padding: 0;}
        header, footer, figure, video, details, blockquote,
        ul, ol, dl, fieldset, pre, pre > code {
        	display: block;
        	margin: .5rem 0rem 1rem;
        	width: 100%;
        	overflow: auto hidden;
        	text-align: left;
        }
        video, summary, input, select { outline: none; }
      ''
      # reset clickable things  (FF Bug: select:hover prevents usage)
      + ''
        a, button, select, summary { color: ${clink}; cursor: pointer; }
      ''
    )
    # Base Style –––––––––––––––––––––––––––––––––––––––
    + ''
      html { font-size: ${rem}; background: ${cbg}; }
      body {
      	position: relative;
      	margin: auto;
      	max-width: ${width};
      	font: ${font-p};
      	color: ${cfg};
      	padding: 3.0rem .6rem 0;
      	overflow-x: hidden;
      }
      body > footer { margin-top: 10rem; text-align: center; font-size: 90%; }
      p { margin: .6em 0; }
    ''
    # Links
    + lib.optionalString links ''
      /*
      a[href]{
         text-decoration: underline solid ${cmed};
         text-underline-position: under;
      }
      a[href^="#"] { text-decoration: none; }
      */
      a[href]{
        text-decoration: none;
      }
      a:hover, button:not([disabled]):hover, summary:hover, select:hover {
      	filter: brightness(92%);
        color: ${cemph};
        border-color: ${cemph};
      }
    ''
    # Lists
    + lib.optionalString lists ''
      ul, ol, dl { margin: 1rem 0; padding: 0 0 0 2em; }
      li:not(:last-child), dd:not(:last-child) { margin-bottom: .5rem; }
      dt { font-weight: bold; }
    ''
    # Headings
    + lib.optionalString headings ''
      h1, h2, h3, h4, h5 { margin: 1.5em 0 .5rem; font: ${font-h}; line-height: 1.2em; clear: both; }
      h1+h2, h2+h3, h3+h4, h4+h5 { margin-top: .5em; padding-top: 0; }  /* non-clashing headings */
      h1 { font-size: 2.2em; font-weight: 300; }
      h2 { font-size: 2.0em; font-weight: 300; font-variant: small-caps; }
      h3 { font-size: 1.5em; font-weight: 400; }
      h4 { font-size: 1.1em; font-weight: 700; }
      h5 { font-size: 1.2em; font-weight: 400; color: ${cfg}; }
      h6 { font-size: 1.0em; font-weight: 700; font-style: italic; display: inline; }
      h6 + p { display: inline; }
    ''
    # Tables
    + lib.optionalString tables ''
      td, th {
        padding: .5em .8em;
        text-align: right;
        border-bottom: ${border};
        white-space: nowrap;
        font-size: 95%;
      }
      thead th[colspan] { padding: .2em .8em; text-align: center; }
      thead tr:not(:only-child) td { padding: .2em .8em; }
      thead+tbody tr:first-child td { border-top: ${border};  }
      td:first-child, th:first-child { text-align: left; }
      tr:hover{ background-color: ${clight}; }
      table img { display: block; }
    ''
    # Figures
    + lib.optionalString figures ''
      img, svg { max-width: 100%; vertical-align: text-top; object-fit: cover; }
      p>img:not(:only-child) { float: right; margin: 0 0 .5em .5em; }
      figure > img { display: inline-block; width: auto; }
      figure > img:only-of-type, figure > svg:only-of-type { max-width: 100%; display: block; margin: 0 auto .4em; }
      figure > *:not(:last-child) { margin-bottom: .4rem; }
    ''
    +
    # Captions
    ''
      figcaption, caption { text-align: left; font: ${font-h}; color: ${cdark}; width: 100%; }
      figcaption > *:first-child, caption > *:first-child { display: inline-block; margin: 0; }
      table caption:last-child { caption-side: bottom; margin: .5em 0; }
    ''
    # Code
    + lib.optionalString code ''
      pre > code {
        margin: 0;
        position: relative;
        padding: .8em;
        border-left: .4rem solid ${cemph};
      }
      code, kbd, samp {
      	padding: .2em;
      	font: ${font-c};
      	background: ${clight};
      	border-radius: 4px;
      }
      kbd { border: 1px solid ${cmed}; }
    ''
    # Miscellaneous
    + lib.optionalString blockquotes ''
      blockquote { border-left: .4rem solid ${cmed}; padding: 0 0 0 1rem;  }
    ''
    + lib.optionalString time ''
      time{ color: ${cdark}; }
    ''
    + lib.optionalString hr ''
      hr { border: 0; border-top: .1rem solid ${cmed}; }
    ''
    + lib.optionalString nav ''
      nav { width: 100%; background-color: ${clight}; }
    ''
    + lib.optionalString selection ''
      ::selection, mark { background: ${clink}; color: ${cbg}; }
    ''
    # Extra Style ––––––––––––––––––––––––––––––––––––––
    # Auto Numbering: figure/tables/headings/cite
    + lib.optionalString auto-numbering ''
      article { counter-reset: h2 0 h3 0 tab 0 fig 0 lst 0 ref 0 eq 0; }
      article figure figcaption:before {
      	color: ${cemph};
      	counter-increment: fig;
      	content: "Figure " counter(fig) ": ";
      }
    ''
    # Subfigures
    + lib.optionalString subfigures ''
      figure { counter-reset: subfig 0 }
      article figure figure { counter-reset: none; }
      article figure > figure { display: inline-grid; width: auto; }
      figure > figure:not(:last-of-type) { padding-right: 1rem; }
      article figure figure figcaption:before {
      	counter-increment: subfig 1;
      	content: counter(subfig, lower-alpha) ": ";
      }
    ''
    # Listings
    + lib.optionalString listings ''
        article figure pre + figcaption:before {
        	counter-increment: lst 1;
        	content: "Listing " counter(lst) ": ";
        }

      # Tables (advanced)
      + lib.optionalString tables-advanced
        /* tables */
        figure > table:only-of-type { margin: .5em auto !important; width: fit-content; }
        article figure > table caption { display: table-caption; caption-side: bottom; }
        article figure > table + figcaption:before,
        article table caption:before {
        	color: ${cemph};
        	counter-increment: tab 1;
        	content: "Table " counter(tab) ": ";
        }
    ''
    # Headings (advanced)
    + lib.optionalString headings ''
      article h2, h3 { position: relative; }
      article h2:before,
      article h3:before {
      	display: inline-block;
      	position: relative;
      	font-size: .6em;
      	text-align: right;
      	vertical-align: baseline;
      	left: -1rem;
      	width: 2.5em;
      	margin-left: -2.5em;
      }
      article h1 { counter-set: h2; }
      article h2:before { counter-increment: h2; content: counter(h2) ". "; counter-set: h3; }
      article h3:before { counter-increment: h3; content: counter(h2) "." counter(h3) ". ";}
      @media (max-width: 60rem) { h2:before, h3:before { display: none; } }
    ''
    # Tooltip and citations
    + lib.optionalString tooltip-citations ''
      article p>cite:before {
      	padding: 0 .5em 0 0;
      	counter-increment: ref; content: " [" counter(ref) "] ";
      	vertical-align: super; font-size: .6em;
      }
      article p>cite > *:only-child { display: none; }
      article p>cite:hover > *:only-child,
      [data-tooltip]:hover:before {
      	display: inline-block; z-index: 40;
      	white-space: pre-wrap;
      	position: absolute; left: 1rem; right: 1rem;
      	padding: 1em 2em;
      	text-align: center;
      	transform:translateY( calc(-100%) );
      	content: attr(data-tooltip);
      	color: ${cbg};
      	background-color: ${cemph};
      	box-shadow: 0 2px 10px 0 black;
      }
      [data-tooltip], article p>cite:before {
      	color: ${clink};
      	border: .8rem solid transparent; margin: -.8rem;
      }
      abbr[title], [data-tooltip] { cursor: help; }
    ''
    # Navbar
    + lib.optionalString navbar ''
      nav+* { margin-top: 3rem; }
      body>nav, header nav {
      	position: ${navpos};
      	top: 0; left: 0; right: 0;
      	z-index: 41;
      	box-shadow: 0vw -50vw 0 50vw ${clight}, 0 calc(-50vw + 2px) 4px 50vw ${cdark};
      }
      nav ul { list-style-type: none; }
      nav ul:first-child { margin: 0; padding: 0; overflow: visible; }
      nav ul:first-child > li {
      	display: inline-block;
      	margin: 0;
      	padding: .8rem .6rem;
      }
      nav ul > li > ul {
      	display: none;
      	width: auto;
      	position: absolute;
      	margin: .5rem 0;
      	padding: 1rem 2rem;
      	background-color: ${clight};
      	border: ${border};
      	border-radius: 4px;
      	z-index: 42;
      }
      nav ul > li > ul > li { white-space: nowrap; }
      nav ul > li:hover > ul { display: block; }
      @media (max-width: 40rem) {
      	nav ul:first-child > li:first-child:after { content: " \25BE"; }
      	nav ul:first-child > li:not(:first-child):not(.sticky) { display: none; }
      	nav ul:first-child:hover > li:not(:first-child):not(.sticky) { display: block; float: none !important; padding: .3rem .6rem; }
      }
    ''
    # Details and cards
    + lib.optionalString details-cards ''
      summary>* { display: inline; }
      .card, details {
      	display: block;
      	margin: .5rem 0rem 1rem;
      	padding: 0 .6rem;
      	border-radius: 4px;
      	overflow: hidden;
      }
      .card, details[open] { outline: 1px solid ${cmed}; }
      .card>img:first-child { margin: -3px -.6rem; max-width: calc(100% + 1.2rem); }
      summary:hover, details[open] summary, .card>p:first-child {
      	box-shadow: inset 0 0 0 2em ${clight}, 0 -.8rem 0 .8rem ${clight};
      }
      .hint { --cmed: ${cemph}; --clight: ${cemphbg}; background-color: ${clight}; }
      .warn { --cmed: #c11; --clight: #e221; background-color: ${clight}; }
    ''
    # Big first letter
    + lib.optionalString big-first-letter ''
      article > section:first-of-type > h2:first-of-type + p:first-letter,
      article > h2:first-of-type + p:first-letter, .lettrine {
      	float: left;
      	font-size: 3.5em;
      	padding: .1em .1em 0 0;
      	line-height: .68em;
      	color: ${cemph};
      }
    ''
    # Ornaments
    + lib.optionalString ornaments ''
      section:after {
      	display: block;
      	margin: 1em 0;
      	color: ${cmed};
      	text-align: center;
      	font-size: 1.5em;
      	content: "${ornament}";
      }
    ''
    # Side menu (aside is not intended for use in a paragraph!)
    + lib.optionalString aside ''
      main aside {
      	position: absolute;
      	width: 8rem;      right: -8.6rem;
      	font-size: .8em; line-height: 1.4em;
      }
      @media (max-width: 70rem) { main aside { display: none; } }
    ''
    # Forms and inputs
    + lib.optionalString inputs ''
      textarea, input:not([type=range]), button, select {
      	font: ${font-h};
      	border-radius: 4px;
      	border: 1.5px solid ${cmed};
      	padding: .4em .8em;
        color: ${cfg};
        background-color: ${clight};
      }
      fieldset select, input:not([type=checkbox]):not([type=radio]) {
      	display: block;
      	width: 100%;
      	margin: 0 0 1rem;
      }
      button, select {
      	font-weight: bold;
      	margin: .5em;
      	border: 1.5px solid ${clink};
        color: ${clink};
      }
      button { padding: .4em 1em; font-size: 85%; letter-spacing: .1em; }
      button[disabled]{ color: ${cdark}; border-color: ${cmed}; }
      fieldset { border-radius: 4px; border: ${border}; padding: .5em 1em; }
      textarea:hover, input:not([type=checkbox]):not([type*='ra']):hover {
        border: 1.5px solid ${cemph};
      }
      textarea:focus, input:not([type=checkbox]):not([type*='ra']):focus {
      	border: 1.5px solid ${clink};
      	box-shadow: 0 0 5px ${clink};
      }
      p>button { padding: 0 .5em; margin: 0 .5em; }
      p>select { padding: 0;      margin: 0 .5em; }
    ''
    # Printing
    + lib.optionalString printing ''
      @media print {
      	@page { margin: 1.5cm 2cm; }
      	html {font-size: 9pt!important; }
      	body { max-width: 27cm; }
      	p { orphans: 2; widows: 2; }
      	caption, figcaption { page-break-before: avoid; }
      	h2, h3, h4, h5 { page-break-after: avoid;}
      	.noprint, body>nav, section:after { display: none; }
      	.row { flex-direction: row; }
      }
    ''
    # Tab boxes
    + lib.optionalString tabs ''
      .tabs {
        display: flex;
        flex-wrap: wrap;
        background: linear-gradient(0deg, ${cbg} 1rem, ${clight} 0%);
        border: ${border}; border-radius: 5px;
        padding-bottom: 0.5em;
      }
      .tabs label {
        order: 1; /*Put the labels first*/
        display: block;
        cursor: pointer;
        padding: .5rem .8rem;
        margin: .5rem 0 -1px;
        border-radius: 5px 5px 0 0;
        color: ${clink};
        background: ${clight};
      }
      .tabs label:first-of-type{ margin-left: 1rem; }
      .tabs .tab {
        order: 99; /*Put the tabs last*/
        flex-grow: 1;
        width: 100%;
        display: none;
        z-index: 10;
        padding: 0 1rem;
        background: ${cbg};
        border-top: ${border};
      }
      .tabs input[type="radio"]:not(:checked) + label:hover { filter: brightness(90%); }
      .tabs input[type="radio"] { display: none; }
      .tabs input[type="radio"]:checked + label {
        border: ${border}; border-bottom: 0px;
        background: ${cbg}; z-index: 11;
      }
      .tabs input[type="radio"]:checked + label + .tab { display: block; }

      @media (max-width: 45em) {
        .tabs .tab, .tabs label { order: initial; }
        .tabs label { width: 100%; margin: 0 0 -1px !important; }
      }
      @media print { .tabs label + .tab { display: block; } .tabs label { display: none; } }''
    # Classes (Bootstrap-compatible) –––––––––––––––––––––
    # Grid
    + lib.optionalString grid ''
      .row { display: flex; margin: .5rem -.6rem; align-items: stretch; }
      .row [class^="col"] { padding: 0 .6rem; }
      .row .col   { flex: 0 4 100%;   }
      .row .col-2 { flex: 0 2 16.66%; }
      .row .col-3 { flex: 0 3 25%;    }
      .row .col-4 { flex: 0 4 33.33%; }
      .row .col-5 { flex: 0 5 41.66%; }
      .row .col-6 { flex: 0 6 50%;    }
      @media (max-width: 40rem) { .row { flex-direction: column; } }
    ''
    # Align
    + lib.optionalString align ''
      /* align */
      .text-left   { text-align: left; }
      .text-right  { text-align: right; }
      .text-center { text-align: center; }
      .float-left  { float: left !important; }
      .float-right { float: right !important; }
      .clearfix    { clear: both; }
    ''
    # Colors
    + lib.optionalString colors ''
      .text-black    { color: #000; }
      .text-white    { color: #fff; }
      .text-primary  { color: ${cemph}; }
      .text-secondary{ color: ${cdark}; }
      .bg-white    { background-color: #fff; }
      .bg-light    { background-color: ${clight}; }
      .bg-primary  { background-color: ${cemph}; }
      .bg-secondary{ background-color: ${cmed}; }
    ''
    # Margins
    + lib.optionalString margins ''
      .mx-auto { margin-left: auto; margin-right: auto; }
      .m-0 { margin: 0 !important; }
      .m-1, .mx-1, .mr-1 { margin-right:  1.0rem !important; }
      .m-1, .mx-1, .ml-1 { margin-left:   1.0rem !important; }
      .m-1, .my-1, .mt-1 { margin-top:    1.0rem !important; }
      .m-1, .my-1, .mb-1 { margin-bottom: 1.0rem !important; }
    ''
    # Padding
    + lib.optionalString padding ''
      .p-0 { padding: 0 !important; }
      .p-1, .px-1, .pr-1 { padding-right:  1.0rem !important; }
      .p-1, .px-1, .pl-1 { padding-left:   1.0rem !important; }
      .p-1, .py-1, .pt-1 { padding-top:    1.0rem !important; }
      .p-1, .py-1, .pb-1 { padding-bottom: 1.0rem !important; }
    ''
