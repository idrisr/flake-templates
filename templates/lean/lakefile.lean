import Lake
open Lake DSL

package Renameme

require mathlib from git
    "https://github.com/leanprover-community/mathlib4" @ "v4.26.0"

@[default_target]
lean_lib Renameme

lean_exe Main where
  root := `Main
