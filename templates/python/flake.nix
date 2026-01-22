{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = ps: with ps; [
          ipython
          numpy
          torch
        ];
        pythonEnv = python.withPackages pythonPackages;

        devTools = with pkgs; [
          pyright
          ruff
          python3Packages.black
          python3Packages.mypy
          python3Packages.isort
        ];
      in
      {
        packages.default = pythonEnv;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
          ] ++ devTools;
          shellHook = ''
            export IPYTHONDIR="$PWD/.ipython"
          '';
        };
      }
    );
}
