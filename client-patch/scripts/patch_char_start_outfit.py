#!/usr/bin/env python3
"""Patch CharStartOutfit.dbc and CharBaseInfo.dbc for AICraft custom race/class combos."""

from __future__ import annotations

import struct
import sys
from pathlib import Path

RACE_DWARF = 3
CLASS_SHAMAN = 7
CLASS_DRUID = 11

# Visible dwarf leather gear (from dwarf rogue/hunter) plus druid staff.
DWARF_DRUID_SLOTS = [
    (35, 472, 17),      # staff
    (49, 9906, 4),      # chest
    (48, 9913, 7),      # legs
    (159, 18084, 0),    # water
    (4536, 6410, 0),    # food
    (47, 9915, 8),      # boots
    (6948, 6418, 0),    # hearthstone
]

# Dwarf shaman uses dwarf-visible leather gear until custom mail display IDs exist.
DWARF_SHAMAN_SLOTS = [
    (36, 5194, 21),     # mace
    (117, 2473, 0),     # drink
    (159, 18084, 0),    # water
    (148, 9976, 4),     # chest
    (147, 9975, 7),     # legs
    (129, 9977, 8),     # boots
    (6948, 6418, 0),    # hearthstone
]


def read_dbc(path: Path) -> tuple[bytearray, int, int, int]:
    data = bytearray(path.read_bytes())
    magic, rec_count, _field_count, rec_size, str_size = struct.unpack_from("<4s4I", data, 0)
    if magic != b"WDBC":
        raise ValueError(f"{path} is not a WDBC file")
    return data, rec_count, rec_size, str_size


def write_dbc(path: Path, data: bytearray) -> None:
    path.write_bytes(data)


def records_end(rec_count: int, rec_size: int, str_size: int) -> int:
    return 20 + rec_count * rec_size + str_size


def find_record(
    data: bytearray, rec_count: int, rec_size: int, race: int, cls: int, sex: int
) -> int | None:
    for index in range(rec_count):
        offset = 20 + index * rec_size
        record_race, record_class, record_sex, _outfit = struct.unpack_from(
            "<BBBB", data, offset + 4
        )
        if record_race == race and record_class == cls and record_sex == sex:
            return offset
    return None


def pad_slots(slots: list[tuple[int, int, int]]) -> list[tuple[int, int, int]]:
    padded = list(slots)
    while len(padded) < 12:
        padded.append((0, 0, 0))
    return padded[:12]


def set_slots(data: bytearray, offset: int, slots: list[tuple[int, int, int]]) -> None:
    for index, (item_id, display_id, inventory_type) in enumerate(slots):
        struct.pack_into("<I", data, offset + 8 + index * 4, item_id)
        struct.pack_into("<I", data, offset + 56 + index * 4, display_id)
        struct.pack_into("<I", data, offset + 104 + index * 4, inventory_type)


def clear_slots(data: bytearray, offset: int) -> None:
    set_slots(data, offset, [(0, 0, 0)] * 12)


def write_record_header(
    data: bytearray,
    offset: int,
    entry_id: int,
    race: int,
    cls: int,
    sex: int,
    outfit: int = 0,
) -> None:
    struct.pack_into("<IBBBB", data, offset, entry_id, race, cls, sex, outfit)


def add_record(
    data: bytearray,
    rec_count: int,
    rec_size: int,
    str_size: int,
    entry_id: int,
    race: int,
    cls: int,
    sex: int,
    slots: list[tuple[int, int, int]],
    outfit: int = 0,
) -> int:
    insert_at = 20 + rec_count * rec_size
    new_record = bytearray(rec_size)
    write_record_header(new_record, 0, entry_id, race, cls, sex, outfit)
    set_slots(new_record, 0, pad_slots(slots))
    data[insert_at:insert_at] = new_record
    rec_count += 1
    struct.pack_into("<I", data, 4, rec_count)
    return rec_count


def next_entry_id(data: bytearray, rec_count: int, rec_size: int) -> int:
    max_id = 0
    for index in range(rec_count):
        offset = 20 + index * rec_size
        entry_id = struct.unpack_from("<I", data, offset)[0]
        max_id = max(max_id, entry_id)
    return max_id + 1


def patch_char_start_outfit(path: Path) -> None:
    data, rec_count, rec_size, str_size = read_dbc(path)

    for sex in (0, 1):
        offset = find_record(data, rec_count, rec_size, RACE_DWARF, CLASS_DRUID, sex)
        if offset is None:
            raise RuntimeError(f"missing dwarf druid entry for sex={sex}")
        clear_slots(data, offset)
        set_slots(data, offset, pad_slots(DWARF_DRUID_SLOTS))

    for sex in (0, 1):
        offset = find_record(data, rec_count, rec_size, RACE_DWARF, CLASS_SHAMAN, sex)
        if offset is None:
            entry_id = next_entry_id(data, rec_count, rec_size)
            rec_count = add_record(
                data,
                rec_count,
                rec_size,
                str_size,
                entry_id,
                RACE_DWARF,
                CLASS_SHAMAN,
                sex,
                DWARF_SHAMAN_SLOTS,
            )
        else:
            clear_slots(data, offset)
            set_slots(data, offset, pad_slots(DWARF_SHAMAN_SLOTS))

    write_dbc(path, data)


def patch_char_base_info(path: Path) -> None:
    data, rec_count, rec_size, _str_size = read_dbc(path)
    for index in range(rec_count):
        offset = 20 + index * rec_size
        race, cls = struct.unpack_from("<BB", data, offset)
        if race == RACE_DWARF and cls == CLASS_SHAMAN:
            return

    insert_at = 20 + rec_count * rec_size
    data[insert_at:insert_at] = struct.pack("<BB", RACE_DWARF, CLASS_SHAMAN)
    struct.pack_into("<I", data, 4, rec_count + 1)
    write_dbc(path, data)


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print(f"Usage: {argv[0]} <DBFilesClient directory>", file=sys.stderr)
        return 1

    dbc_dir = Path(argv[1])
    patch_char_start_outfit(dbc_dir / "CharStartOutfit.dbc")
    patch_char_base_info(dbc_dir / "CharBaseInfo.dbc")
    print("Patched CharStartOutfit.dbc and CharBaseInfo.dbc")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
