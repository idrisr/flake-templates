{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      compiler = "ghc948";
      pkgs = import nixpkgs { system = system; };
      hPkgs = pkgs.haskell.packages."${compiler}";
      dTools = with pkgs; [ zlib ];
      hTools = with hPkgs; [
        ghc
        ghcid
        fourmolu
        hlint
        hoogle
        haskell-language-server
        implicit-hie
        retrie
        cabal-install
      ];
      tools = dTools ++ hTools;
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = tools;
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath tools;
      };
    };
}
