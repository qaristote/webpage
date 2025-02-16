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
    nixpkgs = {};
  };

  outputs = {
    flake-parts,
    my-nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      lib,
      ...
    }: {
      imports = builtins.attrValues {inherit (my-nixpkgs.flakeModules) personal;};

      flake.lib = import ./lib {inherit lib;};

      perSystem = {
        self',
        pkgs,
        system,
        ...
      }: {
        packages = let
          pkgs' = pkgs.extend (
            _: _: {
              uncss = inputs.uncss.packages."${system}".default;
              line-awesome-css = my-nixpkgs.packages."${system}".static_css_lineAwesome;
            }
          );
          html = self.lib.pp.html;
        in {
          default = self'.packages.webpage;
          webpage = import ./default.nix {
            inherit html;
            pkgs = pkgs';
            data = inputs.data.lib.formatWith {
              inherit pkgs;
              markup = html;
            };
          };
        };
      };
    });
}
