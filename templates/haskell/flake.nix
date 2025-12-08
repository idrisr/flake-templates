{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        compiler = "ghc984";
        renameme =
          pkgs.haskell.packages.${compiler}.callCabal2nix "" ./renameme { };
      in
      {
        packages.default = renameme;
        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs.haskell.packages."${compiler}"; [
              fourmolu
              cabal-fmt
              implicit-hie
              ghcid
              cabal2nix
              ghc
              pkgs.ghciwatch
              cabal-install
              pkgs.haskell-language-server
            ];
        };
      }
    );
}
