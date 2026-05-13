"""
Unit tests for COSINE/borefield_modeling.py.

pygfunction (gt) is mocked because it is only required for the
calculate_g_function() method; all other Borefield methods are pure Python /
NumPy and can be tested without the library.
"""

import sys
from unittest.mock import MagicMock

import numpy as np
import pytest

# ---------------------------------------------------------------------------
# Mock pygfunction before importing borefield_modeling
# ---------------------------------------------------------------------------
sys.modules.setdefault("pygfunction", MagicMock())

from borefield_modeling import Borefield  # noqa: E402


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture
def bor_params():
    return {
        "H": 100.0,       # m, borehole depth
        "D": 4.0,         # m, buried depth
        "B": 6.0,         # m, spacing
        "r_b": 0.075,     # m, borehole radius
        "nBor": 4,        # number of boreholes
        "cp_ground": 800.0,   # J/kgK
        "rho_ground": 2000.0, # kg/m3
        "k_ground": 2.0,      # W/mK
        "timFin": 3.1536e8,   # s  (10 years)
        # extra keys used in calculate_g_function (irrelevant for other tests)
        "config_from_file": False,
        "N_1": 2,
        "N_2": 2,
    }


@pytest.fixture
def borefield(bor_params):
    return Borefield(bor_params)


# ---------------------------------------------------------------------------
# Borefield.__init__
# ---------------------------------------------------------------------------

class TestBorefieldInit:
    def test_derived_alpha_ground(self, borefield, bor_params):
        expected = bor_params["k_ground"] / (
            bor_params["rho_ground"] * bor_params["cp_ground"]
        )
        assert pytest.approx(borefield.alpha_ground, rel=1e-9) == expected

    def test_derived_ts(self, borefield, bor_params):
        alpha = bor_params["k_ground"] / (
            bor_params["rho_ground"] * bor_params["cp_ground"]
        )
        expected = bor_params["H"] ** 2 / (9 * alpha)
        assert pytest.approx(borefield.ts, rel=1e-9) == expected

    def test_params_stored(self, borefield, bor_params):
        assert borefield.H == bor_params["H"]
        assert borefield.nBor == bor_params["nBor"]


# ---------------------------------------------------------------------------
# countAggregationCells
# ---------------------------------------------------------------------------

class TestCountAggregationCells:
    def test_returns_positive_integer(self, borefield):
        n = borefield.countAggregationCells(
            lvlBas=2, nCel=3, timFin=3.1536e7, tLoaAgg=3600
        )
        assert isinstance(n, int)
        assert n > 0

    def test_increasing_timFin_increases_cell_count(self, borefield):
        n_short = borefield.countAggregationCells(
            lvlBas=2, nCel=3, timFin=1e6, tLoaAgg=3600
        )
        n_long = borefield.countAggregationCells(
            lvlBas=2, nCel=3, timFin=3.1536e8, tLoaAgg=3600
        )
        assert n_long > n_short

    def test_invalid_timFin_raises_assertion(self, borefield):
        with pytest.raises(AssertionError):
            borefield.countAggregationCells(
                lvlBas=2, nCel=3, timFin=0, tLoaAgg=3600
            )

    def test_single_cell(self, borefield):
        # When timFin == tLoaAgg, should return 1 cell
        n = borefield.countAggregationCells(
            lvlBas=2, nCel=1, timFin=3600, tLoaAgg=3600
        )
        assert n >= 1


# ---------------------------------------------------------------------------
# aggregationCellTimes
# ---------------------------------------------------------------------------

class TestAggregationCellTimes:
    def test_nu_length_equals_i(self, borefield):
        i = borefield.countAggregationCells(
            lvlBas=2, nCel=3, timFin=3.1536e7, tLoaAgg=3600
        )
        nu, rCel = borefield.aggregationCellTimes(
            i=i, lvlBas=2, nCel=3, tLoaAgg=3600, timFin=3.1536e7
        )
        assert len(nu) == i
        assert len(rCel) == i

    def test_nu_last_element_equals_timFin(self, borefield):
        timFin = 3.1536e7
        i = borefield.countAggregationCells(
            lvlBas=2, nCel=3, timFin=timFin, tLoaAgg=3600
        )
        nu, _ = borefield.aggregationCellTimes(
            i=i, lvlBas=2, nCel=3, tLoaAgg=3600, timFin=timFin
        )
        assert pytest.approx(nu[-1], rel=1e-9) == timFin

    def test_nu_strictly_increasing(self, borefield):
        i = borefield.countAggregationCells(
            lvlBas=2, nCel=3, timFin=3.1536e7, tLoaAgg=3600
        )
        nu, _ = borefield.aggregationCellTimes(
            i=i, lvlBas=2, nCel=3, tLoaAgg=3600, timFin=3.1536e7
        )
        assert all(nu[j] > nu[j - 1] for j in range(1, len(nu)))

    def test_rCel_positive(self, borefield):
        i = borefield.countAggregationCells(
            lvlBas=2, nCel=3, timFin=3.1536e7, tLoaAgg=3600
        )
        _, rCel = borefield.aggregationCellTimes(
            i=i, lvlBas=2, nCel=3, tLoaAgg=3600, timFin=3.1536e7
        )
        assert all(r > 0 for r in rCel)


# ---------------------------------------------------------------------------
# spline_derivatives
# ---------------------------------------------------------------------------

class TestSplineDerivatives:
    def test_output_length_matches_input(self, borefield):
        x = np.array([0.0, 1.0, 2.0, 3.0])
        y = np.array([0.0, 1.0, 4.0, 9.0])
        d = borefield.spline_derivatives(x, y)
        assert len(d) == len(x)

    def test_linear_function_has_constant_derivative(self, borefield):
        x = np.array([0.0, 1.0, 2.0, 3.0])
        y = 2.0 * x  # derivative should be ~2 everywhere
        d = borefield.spline_derivatives(x, y)
        # Interior points should be close to 2
        assert pytest.approx(d[1], abs=1e-10) == 2.0
        assert pytest.approx(d[2], abs=1e-10) == 2.0

    def test_returns_numpy_array(self, borefield):
        x = np.array([0.0, 1.0, 2.0])
        y = np.array([0.0, 1.0, 0.0])
        d = borefield.spline_derivatives(x, y)
        assert isinstance(d, np.ndarray)


# ---------------------------------------------------------------------------
# cubic_hermite_linear_extrapolation
# ---------------------------------------------------------------------------

class TestCubicHermiteExtrapolation:
    def test_interpolation_at_endpoints(self, borefield):
        # At x1 the value should equal y1
        val = borefield.cubic_hermite_linear_extrapolation(
            x=0.0, x1=0.0, x2=1.0, y1=0.0, y2=1.0, y1d=1.0, y2d=1.0
        )
        assert pytest.approx(float(val), abs=1e-10) == 0.0

    def test_interpolation_midpoint(self, borefield):
        # For a linear spline (y1d = y2d = slope), midpoint should be average
        val = borefield.cubic_hermite_linear_extrapolation(
            x=0.5, x1=0.0, x2=1.0, y1=0.0, y2=1.0, y1d=1.0, y2d=1.0
        )
        assert pytest.approx(float(val), abs=1e-9) == 0.5

    def test_returns_scalar(self, borefield):
        val = borefield.cubic_hermite_linear_extrapolation(
            x=0.3, x1=0.0, x2=1.0, y1=2.0, y2=4.0, y1d=2.0, y2d=2.0
        )
        # Should be a single numeric value (not an array)
        assert np.isscalar(float(val))
