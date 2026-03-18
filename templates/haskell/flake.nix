{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        renameme =
          pkgs.haskellPackages.callCabal2nix "" ./renameme { };
      in
      {
        packages.default = renameme;
        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs.haskellPackages; [
              fourmolu
              cabal-fmt
              implicit-hie
              ghcid
              cabal2nix
              ghc
              pkgs.ghciwatch
              cabal-install
              haskell-language-server
            ];
        };
      }
    );
}
