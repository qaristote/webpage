{ lib }:

{
  pp.html = import ./html.nix { inherit lib; };
}
