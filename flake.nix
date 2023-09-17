{
  description = "Source code of Quentin Aristote's personal webpage.";

  inputs = {
    data.url = "github:qaristote/info";
    devenv.url = "github:cachix/devenv";
    my-nixpkgs.url = "github:qaristote/my-nixpkgs";
    uncss = {
      url = "github:qaristote/uncss";
      inputs = {
        nixpkgs.follows = "/nixpkgs";
      };
    };
    nixpkgs = {};
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-trusted-substituters = "https://devenv.cachix.org";
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
      imports = builtins.attrValues {inherit (my-nixpkgs.flakeModules) personal devenv;};

      flake.lib = import ./lib {inherit lib;};

      perSystem = {
        self',
        pkgs,
        system,
        ...
      }: {
        packages = let
          pkgsLocal = import ./pkgs {inherit pkgs;};
          pkgs' = pkgs.extend (
            _: _:
              pkgsLocal // {uncss = inputs.uncss.packages."${system}".default;}
          );
          html = self.lib.pp.html;
        in
          pkgsLocal
          // {
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
        devenv.shells.default = {
          languages.nix.enable = true;
          packages = [pkgs.miniserve];
        };
      };
    });
}
