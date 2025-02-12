{ pkgs, ... }: {
  packages = [ pkgs.codespell pkgs.python312Packages.pygments ];
  env.LATEXINDENT_CONFIG = "indentconfig.yaml";
  languages.texlive = {
    enable = true;
    base = pkgs.texliveFull;
  };
  scripts.linkpdf.exec = ''
    ln $DEVENV_ROOT/doc/00-main.pdf ~/documents/papers/MYPDF.pdf
  '';

}
