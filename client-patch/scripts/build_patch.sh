#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="${ROOT_DIR}/source/DBFilesClient"
OUTPUT_MPQ="${ROOT_DIR}/Data/patch-3.MPQ"
PATCH_SCRIPT="${ROOT_DIR}/scripts/patch_char_start_outfit.py"

if command -v mpqcli >/dev/null 2>&1; then
  MPQCLI="mpqcli"
else
  echo "mpqcli is required. Install from https://github.com/TheGrayDot/mpqcli/releases" >&2
  exit 1
fi

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

mkdir -p "${WORK_DIR}/DBFilesClient" "${ROOT_DIR}/Data"
cp -a "${SOURCE_DIR}/." "${WORK_DIR}/DBFilesClient/"

python3 "${PATCH_SCRIPT}" "${WORK_DIR}/DBFilesClient"

rm -f "${OUTPUT_MPQ}"
"${MPQCLI}" create -g wow-vanilla "${WORK_DIR}/DBFilesClient" -p DBFilesClient -o "${OUTPUT_MPQ}"

echo "Built ${OUTPUT_MPQ}"
