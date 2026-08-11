"""
Unit tests for COSINE/energy_hub/clustering_medoid.py.

k_medoids (which in turn imports gurobipy) is mocked because the clustering
integer-programme solver is not available in the test environment.  Only the
deterministic helper function _distances is tested here.
"""

import sys
from unittest.mock import MagicMock

import numpy as np
import pytest

# ---------------------------------------------------------------------------
# Mock k_medoids (and gurobipy which it imports) before loading the module
# ---------------------------------------------------------------------------
sys.modules.setdefault("gurobipy", MagicMock())
sys.modules.setdefault("COSINE.energy_hub.k_medoids", MagicMock())

from COSINE.energy_hub.clustering_medoid import _distances  # noqa: E402


# ---------------------------------------------------------------------------
# _distances
# ---------------------------------------------------------------------------

class TestDistances:
    def test_output_shape_is_square(self):
        values = np.array([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])  # shape (2, 3)
        d = _distances(values)
        assert d.shape == (3, 3)

    def test_diagonal_is_zero(self):
        values = np.random.rand(4, 5)
        d = _distances(values)
        assert np.allclose(np.diag(d), 0.0)

    def test_matrix_is_symmetric(self):
        values = np.random.rand(3, 4)
        d = _distances(values)
        assert np.allclose(d, d.T)

    def test_all_entries_nonnegative(self):
        values = np.random.rand(3, 5)
        d = _distances(values)
        assert np.all(d >= 0)

    def test_identical_columns_have_zero_distance(self):
        col = np.array([1.0, 2.0, 3.0])
        # values shape: (n_vars, n_days). Day 0 == Day 1.
        values = np.column_stack([col, col, col + 1.0])  # shape (3, 3)
        # values[:, 0] == values[:, 1]  → distance should be 0
        d = _distances(values)
        assert pytest.approx(d[0, 1]) == 0.0

    def test_known_euclidean_distance(self):
        # Two 1-D points: [0] and [3] → distance = 3
        values = np.array([[0.0, 3.0]])  # shape (1, 2)
        d = _distances(values, norm=2)
        assert pytest.approx(d[0, 1]) == 3.0
        assert pytest.approx(d[1, 0]) == 3.0

    def test_norm_1_gives_manhattan_distance(self):
        # Two 2-D points: [0,0] and [1,1] → L1 = 2
        values = np.array([[0.0, 1.0], [0.0, 1.0]])  # shape (2, 2)
        d = _distances(values, norm=1)
        assert pytest.approx(d[0, 1]) == 2.0

    def test_single_column_zero_distance(self):
        values = np.array([[1.0], [2.0]])  # only 1 column
        d = _distances(values)
        assert d.shape == (1, 1)
        assert d[0, 0] == 0.0
