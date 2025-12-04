#!/usr/bin/env python3
import os
import sys
import re
import argparse
from pathlib import Path
from bench.data import DataTable, MdFormat, TermColor

TMPBUF_VAR = "t"
tb = os.environ.get(TMPBUF_VAR)
if not tb:
    print(TermColor.colorize(f'Env var "{TMPBUF_VAR}" is not set', 'red'))
    sys.exit(1)

tb_path = Path(tb)
tb_path.mkdir(parents=True, exist_ok=True)


def get_file_size(fpath):
    p = Path(fpath)
    if not p.is_file():
        return 0
    return p.stat().st_size


def list_all_files():
    return sorted([f.name for f in tb_path.iterdir() if f.is_file()])


def get_stats(fname, preview_len=50):
    fpath = tb_path / fname
    size = get_file_size(fpath)
    if size == 0:
        return (0, "")

    try:
        with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
            chunk = f.read(preview_len * 2)
        collapsed = re.sub(r"\s+", " ", chunk).strip()
        preview = collapsed[:preview_len - 2] + ".." if len(collapsed) > preview_len else collapsed
        return (size, preview)
    except Exception:
        return (0, "")

def human_readable_bytes(num_bytes: int) -> str:
    units = ["B", "KB", "MB", "GB", "TB", "PB"]
    size = float(num_bytes)
    idx = 0

    while size >= 1000 and idx < len(units) - 1:
        size /= 1000
        idx += 1

    if idx == 0:
        text = f"{int(size)}"
    else:
        text = f"{size:.2f}"

    # pad so that every entry has up to 6 chars before the space
    # (3 digits + dot + 2 decimals or fewer)
    return f"{text:>6} {units[idx]}"

def tb_stats():
    table = DataTable(['File', 'Bytes', 'Preview'])
    ctable = []
    for fname in list_all_files():
        size, preview = get_stats(fname)
        table.append([fname, human_readable_bytes(size), preview])
        ctable.append(['cyan', 'yellow', 'white'])
    print(MdFormat.render(table, color_table=ctable))


def tb_non_empty():
    used = [f for f in list_all_files() if get_file_size(tb_path / f) > 0]
    if used:
        open_editor(used)
    else:
        print("No non-empty files to open.")
        sys.exit(1)


def next_free_name():
    existing = set(list_all_files())

    # a–z
    for c in "abcdefghijklmnopqrstuvwxyz":
        if c not in existing:
            return c

    # a1–z1, a2–z2...
    n = 1
    while True:
        for c in "abcdefghijklmnopqrstuvwxyz":
            cand = f"{c}{n}"
            if cand not in existing:
                return cand
        n += 1


def open_editor(files, cd_to_base=True):
    if not files:
        print("No files to open.")
        sys.exit(1)

    editor = os.environ.get("EDITOR")
    cmd = [editor]
    if cd_to_base:
        cmd.append(f"+cd {tb_path}")
    cmd += [str(tb_path / f) for f in files]
    os.execvp(editor, cmd)


def main():
    parser = argparse.ArgumentParser(
        description="Buffer manager utility.",
        usage="tb [-l|--list] [-u|--used] [-f|--free] [filename]"
    )

    group = parser.add_mutually_exclusive_group()
    group.add_argument("-l", "--list", action="store_true", help="Show file list with stats")
    group.add_argument("-u", "--used", action="store_true", help="Open all non-empty files")
    group.add_argument("-f", "--free", action="store_true", help="Print first available free name")

    parser.add_argument("file", nargs="?", help="Open or create file")

    args = parser.parse_args()

    if args.list:
        tb_stats()
    elif args.used:
        tb_non_empty()
    elif args.free:
        print(next_free_name())
    elif args.file is None:
        open_editor([next_free_name()])
    else:
        open_editor([args.file])


if __name__ == "__main__":
    main()
