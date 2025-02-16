{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.my-nixpkgs.devenvModules.personal];
  languages.nix.enable = true;
  packages = [pkgs.miniserve];
}
