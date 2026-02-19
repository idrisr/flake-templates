{
  description = "DevShell for LaTeX + Pygments";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem
      [ "aarch64-darwin" "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          packages = {
            default = pkgs.callPackage ./. { };
          };

          checks = {
            default = self.packages.${system}.default;
          };

          devShells = {
            default = pkgs.mkShell {
              name = "latex-shell";
              packages = with pkgs; [
                texliveFull
                python312Packages.pygments
              ];
              shellHook = ''
                export LATEXINDENT_CONFIG=indentconfig.yaml
              '';
            };
          };
        });
}
