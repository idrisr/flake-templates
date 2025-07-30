{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      system = flake-utils.lib.system.x86_64-linux;
      compiler = "ghc984";
      renameme =
        pkgs.haskell.packages.${compiler}.callCabal2nix "" ./renameme { };
    in
    {
      packages.${system}.default = renameme;
      devShells.${system}.default = pkgs.mkShell {
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
          ];
      };
    };
}
