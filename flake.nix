{
  description = "Source code of Quentin Aristote's personal webpage.";

  inputs = {
    data = {
      url = "github:qaristote/info";
      inputs = {
        nixpkgs.follows = "/nixpkgs";
        flake-utils.follows = "/flake-utils";
      };
    };
    uncss = {
      url = "github:qaristote/uncss";
      inputs = {
        nixpkgs.follows = "/nixpkgs";
        flake-utils.follows = "/flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, data, uncss }:
    {
      lib = import ./lib { inherit (nixpkgs) lib; };
      overlays = {
        default = final: prev: {
          personal.webpage = self.packages."${final.system}".webpage;
        };
        deps = final: prev: import ./pkgs { pkgs = final; };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.deps
            (final: prev: { uncss = uncss.packages."${system}".default; })
          ];
        };
      in {
        packages = import ./pkgs { inherit pkgs system; } // {
          webpage = import ./default.nix {
            inherit pkgs;
            inherit (self.lib.pp) html;
            data = data.formatWith."${system}" self.lib.pp.html;
          };
        };
        defaultPackage = self.packages."${system}".webpage;
        devShell = pkgs.mkShell { packages = with pkgs; [ nixfmt miniserve ]; };
      });
}
