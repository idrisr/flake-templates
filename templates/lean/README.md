Quick start (inside `nix develop` or `direnv`):

just

Manual steps:

just rename
lake update
lake exe cache get
lake build

Notes:
- Use the Nix-provided `elan` from the dev shell. If you run a system `elan` outside Nix, you can hit loader/`libstdc++` errors.
- If you see loader errors, remove the toolchain under `~/.elan` and re-run the commands using the Nix `elan`.
- `lake exe Main` builds native code for all of Mathlib and is slow the first time. For fast runs, use `just run` (bytecode).
