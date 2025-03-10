{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      system = flake-utils.lib.system.x86_64-linux;
      renameme = pkgs.stdenvNoCC.mkDerivation {
        name = "template-example-doc";
        pname = "template-example-doc";
        src = ./.;
        nativeBuildInputs =
          [ pkgs.texliveFull pkgs.python312Packages.pygments ];
        buildPhase = ''
          cp "$src/00-main.tex" .
          cp "$src/preamble.tex" .
          cp -r "$src/figures" .
          latexmk -verbose -file-line-error -shell-escape -pdf -interaction=nonstopmode 00-main.tex
        '';
        installPhase = ''
          mkdir -p $out
          mv 00-main.pdf $out/
        '';
      };

    in { packages.${system}.default = renameme; };
}
