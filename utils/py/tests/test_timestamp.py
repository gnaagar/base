import unittest
import time
from datetime import datetime, timezone

from timestamp import parse_any_time, get_epoch_map, get_std_map, get_iso_map

class TestTimestampParsing(unittest.TestCase):
    def test_parse_date(self):
        dt = parse_any_time('2025-01-01')
        expected = datetime(2025, 1, 1, tzinfo=timezone.utc)
        self.assertEqual(dt, expected)

    def test_parse_epoch_seconds(self):
        dt = parse_any_time('1735689600')
        expected = datetime.fromtimestamp(1735689600, tz=timezone.utc)
        self.assertEqual(dt, expected)

    def test_parse_epoch_millis(self):
        dt = parse_any_time('1735689600000')
        expected = datetime.fromtimestamp(1735689600, tz=timezone.utc)
        self.assertEqual(dt, expected)

    def test_parse_epoch_micros(self):
        dt = parse_any_time('1735689612987654')
        expected = datetime(2025, 1, 1, 0, 0, 12, 987654, tzinfo=timezone.utc)
        self.assertEqual(dt, expected)

    def test_parse_with_timezone(self):
        dt = parse_any_time('2025-05-26 02:10:51 PST')
        expected = datetime(2025, 5, 26, 9, 10, 51, tzinfo=timezone.utc)
        self.assertEqual(dt, expected)

    def test_parse_none(self):
        dt = parse_any_time(None)
        now = datetime.now(timezone.utc)
        self.assertAlmostEqual(dt.timestamp(), now.timestamp(), delta=1)

    def test_parse_equality_zones(self):
        dt1 = parse_any_time('2025-05-26 15:00:00 IST')
        dt2 = parse_any_time('2025-05-26 02:30:00 PST')
        self.assertEqual(dt1, dt2)

class TestTimestampOutput(unittest.TestCase):
    def test_get_epoch_map(self):
        dt = datetime(2025, 1, 1, tzinfo=timezone.utc)
        result = get_epoch_map(dt)
        expected = {
            'epoch_s': '1735689600',
            'epoch_ms': '1735689600000',
            'epoch_us': '1735689600000000'
        }
        self.assertEqual(result, expected)

    def test_get_std_map(self):
        dt = datetime(2025, 1, 1, tzinfo=timezone.utc)
        result = get_std_map(dt)
        expected = {
            'UTC': '2025-01-01 00:00:00',
            'IST': '2025-01-01 05:30:00',
            'PST': '2024-12-31 16:00:00'
        }
        self.assertEqual(result, expected)

    def test_get_iso_map(self):
        dt = datetime(2025, 1, 1, tzinfo=timezone.utc)
        result = get_iso_map(dt)
        expected = {
            'UTC_iso': '2025-01-01T00:00:00+00:00',
            'IST_iso': '2025-01-01T05:30:00+05:30',
            'PST_iso': '2024-12-31T16:00:00-08:00'
        }
        self.assertEqual(result, expected)

    def test_get_epoch_map_with_micros(self):
        dt = datetime(2025, 1, 1, 0, 0, 12, 987654, tzinfo=timezone.utc)
        result = get_epoch_map(dt)
        expected = {
            'epoch_s': '1735689612',
            'epoch_ms': '1735689612987',
            'epoch_us': '1735689612987654'
        }
        self.assertEqual(result, expected)

if __name__ == "__main__":
    unittest.main()

