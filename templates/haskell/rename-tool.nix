{ writeShellApplication
, bash
, coreutils
, ripgrep
, perl
}:

writeShellApplication {
  name = "rename-project";
  runtimeInputs = [ bash coreutils ripgrep perl ];
  text = ''
    exec bash "${./scripts/rename-project.sh}" "$@"
  '';
}
