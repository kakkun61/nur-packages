{
  description = "wd";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      treefmt-nix,
      flake-parts,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [ treefmt-nix.flakeModule ];
        flake = { };
        systems = nixpkgs.lib.systems.flakeExposed;
        perSystem =
          { config, pkgs, ... }:
          {
            legacyPackages = import ./default.nix {
              inherit pkgs;
            };
            packages = nixpkgs.lib.filterAttrs (
              _: v: nixpkgs.lib.isDerivation v
            ) self.legacyPackages.${pkgs.system};
            devShells.default = pkgs.mkShell { };
            treefmt = {
              programs.nixfmt.enable = true;
            };
          };
      }
    );
}
