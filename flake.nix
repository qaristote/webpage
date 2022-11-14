{
  description = "Source code of Quentin Aristote's personal webpage.";

  inputs.data = {
    url = "github:qaristote/info";
    inputs = {
      nixpkgs.follows = "/nixpkgs";
      flake-utils.follows = "/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, data }:
    {
      lib = import ./lib { inherit (nixpkgs) lib; };
      overlays.default = final: prev: import ./pkgs { pkgs = final; };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in {
        packages = import ./pkgs { inherit pkgs; } // {
          webpage = import ./default.nix {
            inherit pkgs;
            inherit (self.lib.pp) html;
            data = data.formatWith."${system}" self.lib.pp.html;
          };
        };
        defaultPackage = self.packages."${system}".webpage;
      });
}
