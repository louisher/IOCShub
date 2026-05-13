"""
Unit tests for COSINE/energy_hub/eff_tables.py.

The eff class reads CSV efficiency/COP tables and interpolates values.
Tests use temporary CSV files that replicate the format of the real tables.
"""

import os
import sys
import tempfile

import numpy as np
import pandas as pd
import pytest

from eff_tables import eff  # noqa: E402 (conftest already added energy_hub to sys.path)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _write_eff_table(tmpdir, tsource_vals, tsink_vals, eff_vals):
    """
    Write a minimal efficiency table CSV in the format expected by eff.read_table.

    The CSV format mirrors the real tables:
        Tsource,Tsink,eff
        <Tsource values in first len(tsource) rows>
        <Tsink values in next len(tsink) rows>
        <eff values (len(tsink)*len(tsource) rows)>

    In the actual files, the Tsource, Tsink, and eff columns are written such
    that NaN-padding is used for rows that don't have a value.  To keep things
    simple here we use the dropna() behaviour: all three columns have the same
    values where they have data, and NaN elsewhere.
    """
    n_source = len(tsource_vals)
    n_sink = len(tsink_vals)
    n_eff = n_sink * n_source  # total eff values

    max_rows = max(n_source, n_sink, n_eff)

    tsource_col = list(tsource_vals) + [np.nan] * (max_rows - n_source)
    tsink_col = list(tsink_vals) + [np.nan] * (max_rows - n_sink)
    eff_col = list(eff_vals) + [np.nan] * (max_rows - n_eff)

    df = pd.DataFrame({"Tsource": tsource_col, "Tsink": tsink_col, "eff": eff_col})
    path = os.path.join(tmpdir, "test_table.csv")
    df.to_csv(path, index=False)
    return path


# ---------------------------------------------------------------------------
# eff.read_table
# ---------------------------------------------------------------------------

class TestReadTable:
    def test_returns_dict_with_expected_keys(self):
        tsource = [0.0, 10.0, 20.0]
        tsink = [30.0, 40.0, 50.0]
        eff_vals = [3.0, 3.5, 4.0, 2.5, 3.0, 3.5, 2.0, 2.5, 3.0]
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _write_eff_table(tmpdir, tsource, tsink, eff_vals)
            table = eff(path).read_table(path)

        assert "Tsource" in table
        assert "Tsink" in table
        assert "eff" in table

    def test_array_shapes_correct(self):
        tsource = [0.0, 10.0]
        tsink = [30.0, 40.0, 50.0]
        eff_vals = [3.0, 3.5, 2.5, 3.0, 2.0, 2.5]  # 3 sink × 2 source = 6 values
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _write_eff_table(tmpdir, tsource, tsink, eff_vals)
            table = eff(path).read_table(path)

        assert len(table["Tsource"]) == 2
        assert len(table["Tsink"]) == 3
        assert table["eff"].shape == (3, 2)  # (n_sink, n_source)


# ---------------------------------------------------------------------------
# eff.create_interpolator
# ---------------------------------------------------------------------------

class TestCreateInterpolator:
    def _table(self):
        tsource = np.array([0.0, 10.0, 20.0])
        tsink = np.array([30.0, 40.0, 50.0])
        eff_array = np.array([
            [3.0, 3.5, 4.0],  # tsink=30, tsource=0,10,20
            [2.5, 3.0, 3.5],  # tsink=40
            [2.0, 2.5, 3.0],  # tsink=50
        ])
        return {"Tsource": tsource, "Tsink": tsink, "eff": eff_array}

    def test_interpolator_is_callable(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "dummy.csv")
            # Path is needed for construction but won't be used here
            obj = eff(path)
        interp = obj.create_interpolator(self._table())
        assert callable(interp)

    def test_interpolator_returns_value_at_known_point(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "dummy.csv")
            obj = eff(path)
        interp = obj.create_interpolator(self._table())
        # At (tsink=30, tsource=0) the value should be 3.0
        result = interp(np.array([[30.0, 0.0]]))[0]
        assert pytest.approx(float(result), abs=1e-9) == 3.0


# ---------------------------------------------------------------------------
# eff.get_eff
# ---------------------------------------------------------------------------

class TestGetEff:
    def _write_simple_table(self, tmpdir):
        tsource = [0.0, 10.0, 20.0]
        tsink = [30.0, 40.0, 50.0]
        eff_vals = [3.0, 3.5, 4.0, 2.5, 3.0, 3.5, 2.0, 2.5, 3.0]
        return _write_eff_table(tmpdir, tsource, tsink, eff_vals)

    def test_get_eff_returns_clamped_value(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._write_simple_table(tmpdir)
            result = eff(path).get_eff(Tsink=30.0, Tsource=0.0)
        assert 1 <= result <= 15

    def test_get_eff_at_known_point(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._write_simple_table(tmpdir)
            result = eff(path).get_eff(Tsink=30.0, Tsource=0.0)
        assert pytest.approx(float(result), abs=1e-9) == 3.0

    def test_get_eff_clamping_minimum(self):
        """Values below 1 (eff_min) should be clamped to 1."""
        tsource = [0.0, 10.0]
        tsink = [30.0, 40.0]
        # All eff values set to 0.5 (below minimum of 1)
        low_eff_vals = [0.5, 0.5, 0.5, 0.5]
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _write_eff_table(tmpdir, tsource, tsink, low_eff_vals)
            result = eff(path).get_eff(Tsink=35.0, Tsource=5.0)
        assert result >= 1.0

    def test_get_eff_clamping_maximum(self):
        """Values above 15 (eff_max) should be clamped to 15."""
        tsource = [0.0, 10.0]
        tsink = [30.0, 40.0]
        high_eff_vals = [20.0, 20.0, 20.0, 20.0]
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _write_eff_table(tmpdir, tsource, tsink, high_eff_vals)
            result = eff(path).get_eff(Tsink=35.0, Tsource=5.0)
        assert result <= 15.0
