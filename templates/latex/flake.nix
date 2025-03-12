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
        src = ./src;
        nativeBuildInputs = with pkgs; [
          texliveFull
          python312Packages.pygments
        ];
        buildPhase = ''
          latexmk 00-main.tex
        '';
        installPhase = ''
          mkdir -p $out
          mv build/00-main.pdf $out/
        '';
      };

    in { packages.${system}.default = renameme; };
}
