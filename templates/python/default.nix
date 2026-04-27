{ lib, python3, src }:

python3.pkgs.buildPythonPackage {
  pname = "python-package-template";
  version = "0.1.0";
  pyproject = true;
  inherit src;

  build-system = with python3.pkgs; [
    hatchling
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "python_package"
  ];

  meta = {
    description = "A Nix-first Python package template";
    license = lib.licenses.mit;
  };
}
