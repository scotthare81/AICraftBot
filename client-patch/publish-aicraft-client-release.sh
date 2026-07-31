#!/usr/bin/env bash
# Publish AICraft Client Patch v0.1.1 to the official AICraft-Client repo.
# Run this locally with your GitHub credentials (not available to the cloud agent).

set -euo pipefail

VERSION="v0.1.1"
TAG="client-v0.1.1"
REPO="scotthare81/AICraft-Client"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZIP="${ROOT}/releases/AICraft-Client-${VERSION}.zip"
SHA="${ZIP}.sha256"

if [[ ! -f "${ZIP}" ]]; then
  echo "Missing release zip: ${ZIP}" >&2
  exit 1
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

git clone "https://github.com/${REPO}.git" "${WORKDIR}/repo"
cd "${WORKDIR}/repo"
git checkout -b "release/${TAG}"

cp -a "${ROOT}/scripts" "${ROOT}/source" "${ROOT}/Data" .
cp "${ROOT}/release/README.txt" ./release/README.txt 2>/dev/null || true

cat > README.md << 'EOF'
# AICraft Client

Official client downloads for AICraft.

## Installation

1. Download the latest release.
2. Extract the contents of the ZIP into your World of Warcraft folder.
3. Confirm that the file is located at `World of Warcraft/Data/patch-3.MPQ`.
4. If prompted, overwrite the existing `patch-3.MPQ`.
5. Start World of Warcraft.

Compatible with World of Warcraft 1.12.1 (Build 5875).

This patch includes Dwarf Druids, Dwarf Shamans, Troll Druids, custom race/class support, and correct character creation outfits.

## Building the patch

```bash
./scripts/build_patch.sh
```
EOF

git add -A
git commit -m "Release ${VERSION}: fix dwarf druid and dwarf shaman creation outfits"
git push -u origin "release/${TAG}"

gh release create "${TAG}" \
  --repo "${REPO}" \
  --title "AICraft Client Patch ${VERSION}" \
  --notes "## AICraft Client Patch ${VERSION}

Fixes dwarf druid and dwarf shaman starter gear on the character creation screen.

### Installation
1. Close World of Warcraft
2. Extract the ZIP into your World of Warcraft folder
3. Confirm \`World of Warcraft/Data/patch-3.MPQ\` exists
4. Replace existing patch-3.MPQ if prompted
5. Start World of Warcraft" \
  "${ZIP}" "${SHA}"

echo "Published ${TAG} to https://github.com/${REPO}/releases/tag/${TAG}"
