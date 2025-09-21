{ pkgs, stdenvNoCC, python312Packages }:
let
  mytex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      biblatex
      cm-super
      enumitem
      glossaries
      latex-bin
      latexmk
      minted
      pdfcol
      rsfs
      scheme-small
      tcolorbox
      tikzfill
      titlesec
      upquote
      xcolor
      ;
  };
in

stdenvNoCC.mkDerivation {
  name = throw "change name";
  pname = throw "change name";
  src = ./src;
  nativeBuildInputs = [ mytex python312Packages.pygments pkgs.biber ];
  buildPhase = ''
    latexmk 00-main.tex
  '';
  installPhase = ''
    mkdir -p $out
    mv build/00-main.pdf $out/
  '';
}
