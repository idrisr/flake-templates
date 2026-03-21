#!/usr/bin/env bash
set -euo pipefail

old_name="renameme"

if [[ ! -d "${old_name}" ]]; then
  echo "Error: expected directory '${old_name}' in project root." >&2
  exit 1
fi

if [[ ! -f "${old_name}/${old_name}.cabal" ]]; then
  echo "Error: expected cabal file '${old_name}/${old_name}.cabal'." >&2
  exit 1
fi

printf "Enter project name (Cabal package, e.g. my-project): "
read -r new_name

if [[ -z "${new_name}" ]]; then
  echo "Error: name cannot be empty." >&2
  exit 1
fi

if [[ "${new_name}" == "${old_name}" ]]; then
  echo "Nothing to do: name is already ${old_name}."
  exit 0
fi

if [[ ! "${new_name}" =~ ^[a-z][a-z0-9-]*$ ]]; then
  echo "Error: '${new_name}' is not a valid Cabal package name." >&2
  echo "Use lowercase letters, numbers, and hyphens (start with a letter)." >&2
  exit 1
fi

if [[ -e "${new_name}" ]]; then
  echo "Error: '${new_name}' already exists in this directory." >&2
  exit 1
fi

if [[ -e "${old_name}/${new_name}.cabal" ]]; then
  echo "Error: '${old_name}/${new_name}.cabal' already exists." >&2
  exit 1
fi

mv "${old_name}/${old_name}.cabal" "${old_name}/${new_name}.cabal"

mapfile -t files < <(
  rg --files \
    -g '!.git/**' \
    -g '!.direnv/**' \
    -g '!dist-newstyle/**' \
    -g '!tmp/**' \
    -g '!scripts/rename-project.sh'
)

for file in "${files[@]}"; do
  if rg -q --fixed-strings "${old_name}" "${file}"; then
    perl -pi -e "s/\\b\\Q${old_name}\\E\\b/${new_name}/g" "${file}"
  fi
done

mv "${old_name}" "${new_name}"

mapfile -t remaining < <(
  rg --files-with-matches --fixed-strings "${old_name}" \
    -g '!.git/**' \
    -g '!.direnv/**' \
    -g '!dist-newstyle/**' \
    -g '!tmp/**' \
    -g '!scripts/rename-project.sh' \
    || true
)

if (( ${#remaining[@]} > 0 )); then
  echo "Warning: some '${old_name}' placeholders remain:" >&2
  printf "  %s\n" "${remaining[@]}" >&2
  exit 1
fi

echo "Renamed ${old_name} -> ${new_name}."
