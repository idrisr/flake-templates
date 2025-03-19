{ stdenvNoCC, texliveFull, python312Packages }:
stdenvNoCC.mkDerivation {
  name = "template-example-doc";
  pname = "template-example-doc";
  src = ./src;
  nativeBuildInputs = [ texliveFull python312Packages.pygments ];
  buildPhase = ''
    latexmk 00-main.tex
  '';
  installPhase = ''
    mkdir -p $out
    mv build/00-main.pdf $out/
  '';
}
