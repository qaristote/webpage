{
  description = "Source code of Quentin Aristote's personal webpage.";

  inputs = {
    data.url = "github:qaristote/info";
    my-nixpkgs.url = "github:qaristote/my-nixpkgs";
    uncss = {
      url = "github:qaristote/uncss";
      inputs = {
        nixpkgs.follows = "/nixpkgs";
      };
    };
    nixpkgs = { };
  };

  outputs =
    {
      flake-parts,
      my-nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        imports = builtins.attrValues { inherit (my-nixpkgs.flakeModules) personal; };

        flake.lib = import ./lib { inherit lib; };

        perSystem =
          {
            self',
            pkgs,
            system,
            ...
          }:
          let
            pkgs' = pkgs.extend (
              _: _: {
                uncss = inputs.uncss.packages."${system}".default;
                line-awesome-css = my-nixpkgs.packages."${system}".static_css_lineAwesome;
              }
            );
          in
          {
            packages = {
              default = self'.packages.webpage;
              webpage = pkgs'.callPackage ./default.nix {
                nixpkgsSrc = inputs.nixpkgs.outPath;
                src = pkgs'.callPackage ./src.nix { };
                data = inputs.data.packages."${system}".src;
              };
            };
          };
      }
    );
}
