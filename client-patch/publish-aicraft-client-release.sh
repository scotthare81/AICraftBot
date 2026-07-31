#!/usr/bin/env bash
# Publish AICraft Client Patch v0.1.1 to scotthare81/AICraft-Client
#
# Run from anywhere after cloning AICraftBot:
#   git clone https://github.com/scotthare81/AICraftBot.git
#   cd AICraftBot
#   ./client-patch/publish-aicraft-client-release.sh

set -euo pipefail

VERSION="v0.1.1"
TAG="client-v0.1.1"
REPO="scotthare81/AICraft-Client"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZIP="${ROOT}/releases/AICraft-Client-${VERSION}.zip"
SHA="${ZIP}.sha256"

if [[ ! -f "${ZIP}" ]]; then
  echo "Missing release zip: ${ZIP}" >&2
  echo "Run this script from the AICraftBot repo:" >&2
  echo "  git clone https://github.com/scotthare81/AICraftBot.git && cd AICraftBot" >&2
  echo "  ./client-patch/publish-aicraft-client-release.sh" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required. Install from https://cli.github.com/" >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Run 'gh auth login' first." >&2
  exit 1
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

echo "Cloning ${REPO}..."
git clone "https://github.com/${REPO}.git" "${WORKDIR}/repo"
cd "${WORKDIR}/repo"

DEFAULT_BRANCH="$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | cut -d/ -f2 || echo main)"
git checkout "${DEFAULT_BRANCH}"
git pull origin "${DEFAULT_BRANCH}"

mkdir -p release
cp -a "${ROOT}/scripts" "${ROOT}/source" "${ROOT}/Data" .
cp "${ROOT}/release/README.txt" ./release/README.txt

cat > README.md << 'EOF'
# AICraft Client

Official client downloads for AICraft.

## Installation

1. Download the latest release.
2. Extract the contents of the ZIP into your World of Warcraft folder.
3. Confirm that the file is located at `World of Warcraft/Data/patch-3.MPQ`.
4. If prompted, overwrite the existing `patch-3.MPQ`.
5. Start World of Warcraft.

Compatible with:
- World of Warcraft 1.12.1 (Build 5875)

This patch includes:
- Dwarf Druids
- Dwarf Shamans
- Troll Druids
- Custom race/class support
- Correct character creation outfits
- AICraft client-side DBC changes

## Building the patch

```bash
./scripts/build_patch.sh
```

Requirements: Python 3 and [mpqcli](https://github.com/TheGrayDot/mpqcli/releases).
EOF

git add -A
if git diff --cached --quiet; then
  echo "No changes to commit in ${REPO}."
else
  git commit -m "Release ${VERSION}: fix dwarf druid and dwarf shaman creation outfits"
  git push origin "${DEFAULT_BRANCH}"
  echo "Pushed patch sources to https://github.com/${REPO}/tree/${DEFAULT_BRANCH}"
fi

if gh release view "${TAG}" --repo "${REPO}" >/dev/null 2>&1; then
  echo "Release ${TAG} already exists on ${REPO}. Uploading assets..."
  gh release upload "${TAG}" --repo "${REPO}" --clobber "${ZIP}" "${SHA}"
else
  gh release create "${TAG}" \
    --repo "${REPO}" \
    --title "AICraft Client Patch ${VERSION}" \
    --notes "## AICraft Client Patch ${VERSION}

Fixes dwarf druid and dwarf shaman starter gear on the character creation screen.

### Installation
1. Close World of Warcraft
2. Download and extract the ZIP into your World of Warcraft folder
3. Confirm \`World of Warcraft/Data/patch-3.MPQ\` exists
4. Replace existing patch-3.MPQ if prompted
5. Start World of Warcraft" \
    "${ZIP}" "${SHA}"
fi

echo ""
echo "Done! Release: https://github.com/${REPO}/releases/tag/${TAG}"
