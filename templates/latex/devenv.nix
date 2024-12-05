{ pkgs, ... }: {
  packages = [ pkgs.codespell pkgs.python312Packages.pygments ];
  env.LATEXINDENT_CONFIG = "indentconfig.yaml";
  languages.texlive = {
    enable = true;
    base = pkgs.texliveFull;
  };
}
