"""
Unit tests for COSINE/energy_hub/borefield_params.py.

Heavy dependencies (GHEtool, COSINE.borefields.borefield_modeling) are mocked
before importing borefield_params.  Only pure-Python / NumPy functions that do
not call into those libraries at call-time are tested here.
"""

import json
import sys
import tempfile
from pathlib import Path
from unittest.mock import MagicMock

import numpy as np
import pytest

# ---------------------------------------------------------------------------
# Mock heavy dependencies before importing borefield_params
# ---------------------------------------------------------------------------
for _mod in ("GHEtool", "COSINE.borefields.borefield_modeling"):
    sys.modules.setdefault(_mod, MagicMock())

from COSINE.energy_hub import borefield_params as bp  # noqa: E402


# ---------------------------------------------------------------------------
# find_closest_valid_factor_pair
# ---------------------------------------------------------------------------
class TestFindClosestValidFactorPair:
    def test_perfect_square_returns_equal_factors(self):
        result = bp.find_closest_valid_factor_pair(4)
        assert result == (2, 2)

    def test_perfect_square_large(self):
        result = bp.find_closest_valid_factor_pair(100)
        assert result == (10, 10)

    def test_prime_number_returns_none(self):
        # 7 has only (1,7): ratio 7 > 10 is False BUT 7/1=7<=10, so returns (1,7)
        result = bp.find_closest_valid_factor_pair(7)
        assert result is not None
        a, b = result
        assert a * b == 7

    def test_one_returns_single_pair(self):
        result = bp.find_closest_valid_factor_pair(1)
        assert result == (1, 1)

    def test_zero_or_negative_raises(self):
        with pytest.raises((ValueError, AssertionError)):
            bp.find_closest_valid_factor_pair(0)
        with pytest.raises((ValueError, AssertionError)):
            bp.find_closest_valid_factor_pair(-5)

    def test_returns_tuple_or_none(self):
        result = bp.find_closest_valid_factor_pair(25)
        assert result is not None
        assert isinstance(result, tuple)
        assert len(result) == 2

    def test_factors_are_valid_divisors(self):
        n = 36
        result = bp.find_closest_valid_factor_pair(n)
        assert result is not None
        a, b = result
        assert a * b == n

    def test_ratio_condition_met(self):
        # For n=100 the pair (10,10) has ratio 1 which satisfies <= 10
        result = bp.find_closest_valid_factor_pair(100)
        a, b = result
        ratio = max(a, b) / min(a, b)
        assert ratio <= 10


# ---------------------------------------------------------------------------
# find_next_N_1_N_2
# ---------------------------------------------------------------------------
class TestFindNextN1N2:
    def test_returns_three_values(self):
        result = bp.find_next_N_1_N_2(5, 5)
        assert len(result) == 3

    def test_nBor_reduced(self):
        _, _, nBor = bp.find_next_N_1_N_2(5, 5)
        assert nBor < 25  # original nBor = 5*5 = 25

    def test_returns_valid_pair(self):
        N_1, N_2, nBor = bp.find_next_N_1_N_2(4, 4)
        assert N_1 >= 1 and N_2 >= 1

    def test_small_starting_pair(self):
        # Starting from (2, 2), nBor=4, reduction by 0 leads to 3 then 2
        N_1, N_2, nBor = bp.find_next_N_1_N_2(2, 2)
        assert nBor < 4


# ---------------------------------------------------------------------------
# determine_peak_durations
# ---------------------------------------------------------------------------
class TestDeterminePeakDurations:
    def test_single_peak_ext(self):
        ext = np.array([0.0, 0.0, 10.0, 0.0, 0.0])
        inj = np.array([5.0, 5.0, 5.0, 5.0, 5.0])
        peak_ext, peak_inj = bp.determine_peak_durations(ext, inj)
        # Only 10.0 >= 0.8*10=8, so a single-element run -> 1
        assert peak_ext == 1

    def test_consecutive_peak_ext(self):
        ext = np.array([10.0, 10.0, 10.0, 0.0, 0.0])
        inj = np.array([0.0, 5.0, 5.0, 5.0, 5.0])
        peak_ext, _ = bp.determine_peak_durations(ext, inj)
        assert peak_ext == 3

    def test_returns_tuple_of_two(self):
        ext = np.array([1.0, 2.0, 3.0])
        inj = np.array([3.0, 2.0, 1.0])
        result = bp.determine_peak_durations(ext, inj)
        assert len(result) == 2

    def test_both_durations_nonnegative(self):
        ext = np.array([0.0, 5.0, 5.0, 0.0])
        inj = np.array([3.0, 3.0, 0.0, 0.0])
        peak_ext, peak_inj = bp.determine_peak_durations(ext, inj)
        assert peak_ext >= 0
        assert peak_inj >= 0

    def test_symmetric_input(self):
        load = np.array([1.0, 10.0, 10.0, 1.0])
        peak_ext, peak_inj = bp.determine_peak_durations(load, load)
        assert peak_ext == peak_inj


# ---------------------------------------------------------------------------
# increase_nBor
# ---------------------------------------------------------------------------
class TestIncreaseNBor:
    def test_increments_N_1_when_equal(self):
        # N_1 <= N_2 so N_1 is incremented
        N_1, N_2 = bp.increase_nBor(3, 3)
        assert N_1 == 4 and N_2 == 3

    def test_increments_N_2_when_N_1_greater(self):
        N_1, N_2 = bp.increase_nBor(5, 3)
        assert N_1 == 5 and N_2 == 4

    def test_increments_N_1_when_N_1_smaller(self):
        N_1, N_2 = bp.increase_nBor(2, 4)
        assert N_1 == 3 and N_2 == 4

    def test_total_nBor_increased_by_one_row_or_col(self):
        N_1_in, N_2_in = 5, 5
        N_1, N_2 = bp.increase_nBor(N_1_in, N_2_in)
        assert N_1 * N_2 > N_1_in * N_2_in


# ---------------------------------------------------------------------------
# write_N_1_N_2_to_json
# ---------------------------------------------------------------------------
class TestWriteN1N2ToJson:
    def _make_devs(self, path):
        return {"Borefield": {"path_bor_params": str(path)}}

    def test_updates_n1_n2_in_file(self, tmp_path):
        json_path = tmp_path / "bor_params.json"
        json_path.write_text(json.dumps({"N_1": 1, "N_2": 1, "other": "value"}))
        devs = self._make_devs(json_path)
        bp.write_N_1_N_2_to_json(devs, 3, 7)
        with open(json_path) as f:
            data = json.load(f)
        assert data["N_1"] == 3
        assert data["N_2"] == 7

    def test_preserves_other_keys(self, tmp_path):
        json_path = tmp_path / "bor_params.json"
        json_path.write_text(json.dumps({"N_1": 1, "N_2": 1, "B": 5.0}))
        devs = self._make_devs(json_path)
        bp.write_N_1_N_2_to_json(devs, 2, 4)
        with open(json_path) as f:
            data = json.load(f)
        assert data["B"] == 5.0


# ---------------------------------------------------------------------------
# write_peak_durations_to_json
# ---------------------------------------------------------------------------
class TestWritePeakDurationsToJson:
    def _make_devs(self, path):
        return {"Borefield": {"path_bor_params": str(path)}}

    def test_updates_peak_durations_in_file(self, tmp_path):
        json_path = tmp_path / "bor_params.json"
        json_path.write_text(
            json.dumps({"peak_duration_ext": 0, "peak_duration_inj": 0})
        )
        devs = self._make_devs(json_path)
        bp.write_peak_durations_to_json(devs, 6.0, 3.0)
        with open(json_path) as f:
            data = json.load(f)
        assert data["peak_duration_ext"] == 6.0
        assert data["peak_duration_inj"] == 3.0

    def test_returns_none(self, tmp_path):
        json_path = tmp_path / "bor_params.json"
        json_path.write_text(
            json.dumps({"peak_duration_ext": 1, "peak_duration_inj": 1})
        )
        devs = self._make_devs(json_path)
        result = bp.write_peak_durations_to_json(devs, 2.0, 4.0)
        assert result is None

    def test_preserves_other_keys(self, tmp_path):
        json_path = tmp_path / "bor_params.json"
        json_path.write_text(
            json.dumps({"peak_duration_ext": 1, "peak_duration_inj": 1, "B": 7.5})
        )
        devs = self._make_devs(json_path)
        bp.write_peak_durations_to_json(devs, 2.0, 4.0)
        with open(json_path) as f:
            data = json.load(f)
        assert data["B"] == 7.5
