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
