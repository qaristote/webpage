{
  description = "Source code of Quentin Aristote's personal webpage.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    data = {
      url = "github:qaristote/info";
      inputs = {
        nixpkgs.follows = "";
        flake-utils.follows = "";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, data }:
    {
      lib = import ./lib { inherit (nixpkgs) lib; };
    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages.webpage = import ./default.nix {
          inherit pkgs;
          inherit (self.lib.pp) html;
          data = data.formatWith."${system}" self.lib.pp.html;
        };
        defaultPackage = packages.webpage;
      });
}
