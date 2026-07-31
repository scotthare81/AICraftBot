# AICraft Client Patch (patch-3.MPQ)

Client-side DBC patch for AICraft custom race/class combinations.

## Installation

1. Copy `Data/patch-3.MPQ` into your World of Warcraft `Data` folder.
2. Overwrite the existing `patch-3.MPQ` when prompted.
3. Restart the WoW client.

Compatible with World of Warcraft 1.12.1 (Build 5875).

## What this patch fixes

- **Dwarf Druid** — character creation now shows dwarf leather gear and a staff instead of night elf display IDs that rendered invisible on dwarves.
- **Dwarf Shaman** — adds missing `CharBaseInfo` and `CharStartOutfit` entries so dwarf shamans show starter gear on the creation screen.

## Building from source

```bash
cd client-patch
./scripts/build_patch.sh
```

Requirements: Python 3 and [mpqcli](https://github.com/TheGrayDot/mpqcli/releases).

The build script applies `scripts/patch_char_start_outfit.py` to the DBC files in `source/DBFilesClient/` and outputs `Data/patch-3.MPQ`.
