{
  description = "DevShell for LaTeX + Pygments";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "latex-shell";
        packages = [ pkgs.texliveFull pkgs.python312Packages.pygments ];
        shellHook = ''
          export LATEXINDENT_CONFIG=indentconfig.yaml
        '';
      };
    };
}
