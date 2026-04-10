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
        src = pkgs.lib.cleanSourceWith {
          src = ./.;
          filter = path: type:
            let
              baseName = builtins.baseNameOf path;
            in
            !(pkgs.lib.elem baseName [
              ".direnv"
              ".git"
              ".ipython"
              "result"
            ]);
        };

        package = python.pkgs.buildPythonPackage {
          pname = "python-package-template";
          version = "0.1.0";
          pyproject = true;
          inherit src;

          build-system = with python.pkgs; [
            hatchling
          ];

          nativeCheckInputs = with python.pkgs; [
            pytestCheckHook
          ];

          pythonImportsCheck = [
            "python_package"
          ];

          meta = {
            description = "A Nix-first Python package template";
            license = pkgs.lib.licenses.mit;
          };
        };

        renameTool = pkgs.writeShellApplication {
          name = "rename-project";
          runtimeInputs = [ python ];
          text = ''
            exec ${python}/bin/python ${./scripts/rename-project.py} "$@"
          '';
        };

        tooling = with python.pkgs; [
          build
          hatchling
          mypy
          pytest
          pytest-cov
          ruff
          twine
        ];
      in
      {
        packages.default = package;
        packages.rename = renameTool;

        apps.rename = {
          type = "app";
          program = "${renameTool}/bin/rename-project";
          meta = {
            description = "Rename python template placeholders";
          };
        };

        checks = {
          package = package;

          ruff = pkgs.runCommand "ruff-check" {
            nativeBuildInputs = with python.pkgs; [ ruff ];
            inherit src;
          } ''
            cd "$src"
            ruff check --no-cache src tests
            touch "$out"
          '';

          mypy = pkgs.runCommand "mypy-check" {
            nativeBuildInputs = [
              python
              python.pkgs.mypy
            ];
            inherit src;
          } ''
            cd "$src"
            mypy src tests
            touch "$out"
          '';

          dist = pkgs.runCommand "dist-check" {
            nativeBuildInputs = [
              python
              python.pkgs.build
              python.pkgs.hatchling
              python.pkgs.twine
            ];
            inherit src;
          } ''
            cp -r "$src" source
            chmod -R u+w source
            cd source
            pyproject-build --no-isolation --sdist --wheel --outdir dist
            twine check --strict dist/*
            mkdir -p "$out"
            cp -r dist "$out"/
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = [
            package
            python
          ] ++ tooling;

          shellHook = ''
            export IPYTHONDIR="$PWD/.ipython"
            export PYTHONPATH="$PWD/src${PYTHONPATH:+:$PYTHONPATH}"
          '';
        };
      }
    );
}
