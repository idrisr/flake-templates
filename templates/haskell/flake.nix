{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem
      [ "x86_64-linux" "aarch64-darwin" ]
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          project = pkgs.haskellPackages.callCabal2nix "" ./renameme { };
          renameTool = pkgs.callPackage ./rename-tool.nix { };
        in
        {
          packages.default = project;
          packages.rename = renameTool;
          checks.default = project;
          apps.rename = {
            type = "app";
            program = "${renameTool}/bin/rename-project";
          };
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
