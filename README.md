# Flake templates

Nix flake templates for starting development projects.

## Templates

| Template | Description |
| --- | --- |
| [`arxiv`](templates/arxiv) | Build an existing arXiv LaTeX project. |
| [`basic`](templates/basic) | A bare-bones flake to customize. |
| [`haskell`](templates/haskell) | A Haskell project. |
| [`latex`](templates/latex) | A LaTeX document project. |
| [`lean`](templates/lean) | A Lean 4 development environment. |
| [`python`](templates/python) | A Python package with development tools and checks. |
| [`qemuvm`](templates/qemuvm) | A QEMU-based NixOS virtual machine. |

## Usage

Install [Nix](https://nix.dev/install-nix) with the `nix-command` and `flakes`
experimental features enabled. If needed, add this to `~/.config/nix/nix.conf`:

```ini
experimental-features = nix-command flakes
```

Create a project from a named template:

```sh
nix flake new my-project -t github:idrisr/flake-templates#python
cd my-project
```

Or initialize a template in the current directory:

```sh
nix flake init -t github:idrisr/flake-templates#python
```

Replace `python` with any template name above. This repository does not define a
default template, so choose one explicitly with `-t`.

For templates that provide a development shell, enter it with:

```sh
nix develop
```

Available commands and supported platforms vary by template; see its `flake.nix`
and README, where provided.

To list the published templates:

```sh
nix flake show github:idrisr/flake-templates
```
