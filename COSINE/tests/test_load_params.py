"""
Unit tests for COSINE/energy_hub/load_params.py.

Heavy dependencies (GHEtool, borefield_params, clustering_medoid,
solar_modeling, Borefield, matplotlib) are mocked before importing
load_params.  Only the two pure-computation helper functions
(calc_annual_investment and calc_monthly_dem) are tested here.
"""

import sys
from unittest.mock import MagicMock

import matplotlib
matplotlib.use("Agg")  # non-interactive backend; must come before the import below

import numpy as np
import pytest

# ---------------------------------------------------------------------------
# Remove any stale mocks that may have been installed by previously-collected
# test files (e.g. test_helper_functions.py mocks load_params).  We need the
# *real* load_params module here.
# ---------------------------------------------------------------------------
for _mod in (
    "COSINE.energy_hub.load_params",
    "COSINE.energy_hub.solar_modeling",
):
    sys.modules.pop(_mod, None)

# ---------------------------------------------------------------------------
# Mock only the truly unavailable heavy dependencies
# ---------------------------------------------------------------------------
for _mod in (
    "GHEtool",
    "COSINE.borefields.borefield_modeling",
    "COSINE.energy_hub.borefield_params",
    "COSINE.energy_hub.clustering_medoid",
    "pygfunction",
):
    sys.modules.setdefault(_mod, MagicMock())

from COSINE.energy_hub.load_params import calc_annual_investment, calc_monthly_dem  # noqa: E402


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def _make_param(observation_time=20, interest_rate=0.05):
    return {
        "observation_time": observation_time,
        "interest_rate": interest_rate,
    }


def _make_devs(life_time=20):
    return {
        "HP": {"life_time": life_time, "invest": 1000},
        "PV": {"life_time": 25, "invest": 2000},
    }


# ---------------------------------------------------------------------------
# calc_annual_investment
# ---------------------------------------------------------------------------
class TestCalcAnnualInvestment:
    def test_returns_devs_and_param(self):
        devs = _make_devs()
        param = _make_param()
        result = calc_annual_investment(devs, param)
        assert len(result) == 2

    def test_ann_factor_added_to_each_device(self):
        devs = _make_devs()
        param = _make_param()
        devs_out, _ = calc_annual_investment(devs, param)
        for dev in devs_out:
            assert "ann_factor" in devs_out[dev]

    def test_crf_stored_in_param(self):
        devs = _make_devs()
        param = _make_param()
        _, param_out = calc_annual_investment(devs, param)
        assert "CRF" in param_out

    def test_ann_factor_positive(self):
        devs = _make_devs()
        param = _make_param(observation_time=20, interest_rate=0.05)
        devs_out, _ = calc_annual_investment(devs, param)
        for dev in devs_out:
            assert devs_out[dev]["ann_factor"] > 0

    def test_higher_interest_rate_increases_ann_factor(self):
        devs_lo = _make_devs()
        devs_hi = _make_devs()
        _, param_lo = calc_annual_investment(devs_lo, _make_param(interest_rate=0.02))
        _, param_hi = calc_annual_investment(devs_hi, _make_param(interest_rate=0.10))
        assert param_hi["CRF"] > param_lo["CRF"]

    def test_device_with_lifetime_exceeding_observation_time(self):
        # When life_time > observation_time a simpler annuity formula is used
        devs = {"LongDev": {"life_time": 40, "invest": 5000}}
        param = _make_param(observation_time=20, interest_rate=0.05)
        devs_out, _ = calc_annual_investment(devs, param)
        assert "ann_factor" in devs_out["LongDev"]
        assert devs_out["LongDev"]["ann_factor"] > 0

    def test_crf_formula_sanity(self):
        """CRF = q^n * r / (q^n - 1) with q=1+r, n=observation_time."""
        import math
        param = _make_param(observation_time=10, interest_rate=0.05)
        devs = _make_devs(life_time=10)
        _, param_out = calc_annual_investment(devs, param)
        r = 0.05
        q = 1.05
        expected_crf = (q**10 * r) / (q**10 - 1)
        assert pytest.approx(param_out["CRF"], rel=1e-6) == expected_crf


# ---------------------------------------------------------------------------
# calc_monthly_dem
# ---------------------------------------------------------------------------
class TestCalcMonthlyDem:
    """calc_monthly_dem aggregates 8760-hour demand arrays into monthly sums."""

    def _make_dem(self, value=1.0):
        """Return a dem_uncl dict with constant hourly load."""
        arr = np.full(8760, value)
        return {"heat": arr, "cool": arr, "power": arr}

    def test_returns_dict(self):
        dem = self._make_dem()
        result = calc_monthly_dem(dem, {}, {})
        assert isinstance(result, dict)

    def test_monthly_dem_key_present(self):
        dem = self._make_dem()
        result = calc_monthly_dem(dem, {}, {})
        assert "monthly_dem" in result

    def test_twelve_months_per_carrier(self):
        dem = self._make_dem()
        result = calc_monthly_dem(dem, {}, {})
        for carrier in ("heat", "cool", "power"):
            assert len(result["monthly_dem"][carrier]) == 12

    def test_year_sum_matches_manual_sum(self):
        value = 2.0  # W per hour
        dem = self._make_dem(value)
        result = calc_monthly_dem(dem, {}, {})
        # year_sum is stored in kWh (divided by 1000)
        expected = int(np.sum(np.full(8760, value)) / 1000)
        assert result["year_sum"]["heat"] == expected

    def test_year_peak_matches_max(self):
        dem = self._make_dem(5.0)
        result = calc_monthly_dem(dem, {}, {})
        assert result["year_peak"]["heat"] == 5

    def test_all_month_labels_present(self):
        dem = self._make_dem()
        result = calc_monthly_dem(dem, {}, {})
        expected_months = (
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
        )
        for label in expected_months:
            assert label in result["monthly_dem"]["heat"]

    def test_monthly_sums_add_up_to_annual_sum(self):
        dem = self._make_dem(3.0)
        result = calc_monthly_dem(dem, {}, {})
        monthly_total = sum(result["monthly_dem"]["power"].values())
        # year_sum is in MWh (kWh/1000 → MWh/1000); monthly values are in kWh
        annual_kwh = np.sum(np.full(8760, 3.0)) / 1000
        assert pytest.approx(monthly_total, rel=1e-6) == annual_kwh

    def test_result_dict_modified_in_place(self):
        dem = self._make_dem()
        result_dict = {"existing_key": 42}
        out = calc_monthly_dem(dem, {}, result_dict)
        assert out["existing_key"] == 42
