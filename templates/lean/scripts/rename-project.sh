#!/usr/bin/env bash
set -euo pipefail

old_name="Renameme"

printf "Enter project name (Lean identifier, e.g. MyProject): "
read -r new_name

if [[ -z "${new_name}" ]]; then
  echo "Error: name cannot be empty." >&2
  exit 1
fi

if [[ "${new_name}" == "${old_name}" ]]; then
  echo "Nothing to do: name is already ${old_name}."
  exit 0
fi

if [[ ! "${new_name}" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
  echo "Error: '${new_name}' is not a valid Lean identifier." >&2
  exit 1
fi

if [[ -e "${new_name}" || -e "${new_name}.lean" ]]; then
  echo "Error: '${new_name}' already exists in this directory." >&2
  exit 1
fi

# Rename module root directory and file if present.
if [[ -d "${old_name}" ]]; then
  mv "${old_name}" "${new_name}"
fi

if [[ -f "${old_name}.lean" ]]; then
  mv "${old_name}.lean" "${new_name}.lean"
fi

# Replace occurrences in project files, excluding build/direnv artifacts.
mapfile -t files < <(
  rg --files \
    -g '!.git/**' \
    -g '!.lake/**' \
    -g '!.direnv/**'
)

for f in "${files[@]}"; do
  if rg -q "${old_name}" "${f}"; then
    perl -pi -e "s/\\b\\Q${old_name}\\E\\b/${new_name}/g" "${f}"
  fi
done

echo "Renamed ${old_name} -> ${new_name}."
echo "Next: run 'lake update' and 'lake exe cache get'."
