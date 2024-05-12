{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      hooks = {
        nixfmt.enable = true;
        deadnix.enable = true;
        beautysh.enable = true;
      };

      system = flake-utils.lib.system.x86_64-linux;
      compiler = "ghc948";
      hPkgs = pkgs.haskell.packages."${compiler}";
      dTools = with pkgs; [ zlib ];
      hTools = with hPkgs; [
        ghc
        ghcid
        fourmolu
        hlint
        hoogle
        implicit-hie
        retrie
        cabal-install
      ];
      tools = dTools ++ hTools;
      renameme = pkgs.haskell.packages.ghc948.callCabal2nix "" ./renameme { };

    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = tools;
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath tools;
      };

      packages.${system}.default = renameme;

      checks.${system} = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          inherit hooks;
        };
      };
    };
}
