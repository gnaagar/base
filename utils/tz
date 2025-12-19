#!/usr/bin/env python3

import argparse
import sys
from datetime import datetime, timezone, timedelta
from typing import List
from zoneinfo import ZoneInfo

ZONES = {
    "UTC": "UTC",
    "IST": "Asia/Kolkata", 
    "PST": "America/Los_Angeles"
}

DATETIME_INPUT_FORMATS = [
    "%Y-%m-%d %H:%M:%S",
    "%Y-%m-%d %H:%M:%S.%f",
    "%Y-%m-%dT%H:%M:%S",
    "%Y-%m-%dT%H:%M:%S.%f",
    "%Y-%m-%dT%H:%M:%S%z",
    "%Y-%m-%d"
]

def parse_any_time(value: str) -> datetime:
    if not value:
        return datetime.now(tz=timezone.utc)
    
    value = value.strip()

    # --- epoch detection (non-ambiguous) ---
    if value.isdigit():
        n = int(value)
        L = len(value)

        if L <= 10:  # seconds
            return datetime.fromtimestamp(n, tz=timezone.utc)

        elif L <= 13:  # milliseconds
            sec, ms = divmod(n, 1_000)
            return (
                datetime.fromtimestamp(sec, tz=timezone.utc)
                + timedelta(milliseconds=ms)
            )

        else:  # microseconds
            sec, us = divmod(n, 1_000_000)
            return (
                datetime.fromtimestamp(sec, tz=timezone.utc)
                + timedelta(microseconds=us)
            )
    
    # Extract timezone if present (if last part matches known zones)
    parts = value.split()
    tz = ZoneInfo("UTC")

    if parts:
        tz_key = parts[-1].upper()
        if tz_key in ZONES:
            tz = ZoneInfo(ZONES[tz_key])
            value = " ".join(parts[:-1])

    for fmt in DATETIME_INPUT_FORMATS:
        try:
            dt = datetime.strptime(value, fmt)

            # Attach timezone explicitly (DO NOT use astimezone yet)
            dt = dt.replace(tzinfo=tz)

            # Normalize if desired (optional but recommended)
            return dt.astimezone(timezone.utc)

        except ValueError:
            continue

    raise ValueError(f"Could not parse datetime input: '{value}'.")

def get_epoch_map(dt: datetime) -> dict[str, str]:
    val_map = {}
    val_map["epoch_s"] = int(dt.timestamp())
    val_map["epoch_ms"] = val_map["epoch_s"] * 1_000 + dt.microsecond // 1_000
    val_map["epoch_us"] = val_map["epoch_s"] * 1_000_000 + dt.microsecond
    
    epoch_map = {}
    for k,v in val_map.items():
        epoch_map[k] = str(v)
    return epoch_map

def get_std_map(dt: datetime) -> dict[str, str]:
    std_map = {}
    for z,zone_id in ZONES.items():
        tz = ZoneInfo(zone_id)
        std_map[z] = dt.astimezone(tz).strftime('%Y-%m-%d %H:%M:%S')
    return std_map

def get_iso_map(dt: datetime) -> dict[str, str]:
    iso_map = {}
    for z,zone_id in ZONES.items():
        tz = ZoneInfo(zone_id)
        z_iso = z + "_iso"
        iso_map[z_iso] = dt.astimezone(tz).isoformat()
    return iso_map

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Parse epoch (s/ms/us) or date strings and normalize time"
    )
    ap.add_argument(
        "time",
        nargs='?',
        default=None,
        help="epoch seconds, milliseconds, microseconds, or date string",
    )
    args = ap.parse_args()

    try:
        dt = parse_any_time(args.time)
    except Exception as e:
        print(f"error: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Print outputs
    for k, v in get_std_map(dt).items():
        print(f"{k:10}= {v}")
    print()
    for k, v in get_iso_map(dt).items():
        print(f"{k:10}= {v}")
    print()
    for k, v in get_epoch_map(dt).items():
        print(f"{k:10}= {v}")
    print()
    
if __name__ == "__main__":
    main()
