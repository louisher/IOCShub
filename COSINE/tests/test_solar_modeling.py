"""
Unit tests for COSINE/energy_hub/solar_modeling.py.

Tests cover the pure-math / NumPy functions that require no external data files
or heavy third-party libraries.  matplotlib is switched to the non-interactive
'Agg' backend so that functions that create figures do not attempt to open a
display.
"""

import math
import sys

import matplotlib
matplotlib.use("Agg")  # must be set before importing solar_modeling

import numpy as np
import pytest

# ---------------------------------------------------------------------------
# Remove any stale mock of solar_modeling that may have been installed by a
# previously-collected test file (test_load_params.py used to mock it).
# ---------------------------------------------------------------------------
sys.modules.pop("COSINE.energy_hub.solar_modeling", None)

from COSINE.energy_hub.solar_modeling import (
    ashrae_iam,
    compute_hermite_derivatives,
    getGeometry,
    getIncidenceAngle,
    getTotalRadiationTiltedSurface,
    modelica_iam,
)


# ---------------------------------------------------------------------------
# ashrae_iam
# ---------------------------------------------------------------------------
class TestAshraeIam:
    def test_zero_angle_returns_one(self):
        theta = np.array([0.0])
        result = ashrae_iam(theta, b0=0.05)
        assert pytest.approx(result[0], abs=1e-6) == 1.0

    def test_ninety_degrees_returns_zero(self):
        theta = np.array([90.0])
        result = ashrae_iam(theta, b0=0.05)
        assert result[0] == 0.0

    def test_iam_clipped_to_zero(self):
        # Very large angle drives formula negative – should be clamped to 0
        theta = np.array([85.0])
        result = ashrae_iam(theta, b0=1.0)
        assert result[0] >= 0.0

    def test_b0_zero_gives_unity_for_all_angles(self):
        theta = np.array([0.0, 30.0, 60.0])
        result = ashrae_iam(theta, b0=0.0)
        np.testing.assert_allclose(result, [1.0, 1.0, 1.0])

    def test_positive_b0_decreases_iam_with_angle(self):
        theta = np.array([0.0, 30.0, 60.0])
        iam = ashrae_iam(theta, b0=0.05)
        # IAM should be non-increasing as theta grows
        assert iam[0] >= iam[1] >= iam[2]

    def test_output_shape_matches_input(self):
        theta = np.linspace(0, 89, 50)
        result = ashrae_iam(theta, b0=0.05)
        assert result.shape == theta.shape


# ---------------------------------------------------------------------------
# modelica_iam
# ---------------------------------------------------------------------------
class TestModelicaIam:
    def test_zero_angle_returns_one(self):
        theta = np.array([0.0])
        result = modelica_iam(theta, b0=0.0, b1=0.0)
        assert pytest.approx(result[0], abs=1e-6) == 1.0

    def test_ninety_degrees_returns_zero(self):
        theta = np.array([90.0])
        result = modelica_iam(theta, b0=0.0, b1=0.0)
        assert result[0] == 0.0

    def test_output_clipped_to_nonnegative(self):
        theta = np.array([80.0])
        result = modelica_iam(theta, b0=-5.0, b1=0.0)
        assert result[0] >= 0.0

    def test_output_shape_matches_input(self):
        theta = np.linspace(0, 89, 30)
        result = modelica_iam(theta, b0=0.05, b1=0.002)
        assert result.shape == theta.shape

    def test_both_zero_coefficients_gives_one_at_small_angles(self):
        theta = np.array([10.0, 20.0, 30.0])
        result = modelica_iam(theta, b0=0.0, b1=0.0)
        np.testing.assert_allclose(result, [1.0, 1.0, 1.0])


# ---------------------------------------------------------------------------
# compute_hermite_derivatives
# ---------------------------------------------------------------------------
class TestComputeHermiteDerivatives:
    def test_output_length_matches_input(self):
        x = np.array([0.0, 1.0, 2.0, 3.0])
        y = np.array([0.0, 1.0, 4.0, 9.0])
        d = compute_hermite_derivatives(x, y)
        assert len(d) == len(x)

    def test_linear_function_constant_derivative(self):
        x = np.array([0.0, 1.0, 2.0, 3.0])
        y = 3.0 * x + 1.0
        d = compute_hermite_derivatives(x, y)
        # All internal derivatives should be ≈3
        np.testing.assert_allclose(d, 3.0, atol=1e-10)

    def test_returns_numpy_array(self):
        x = np.array([0.0, 1.0, 2.0])
        y = np.array([1.0, 2.0, 3.0])
        d = compute_hermite_derivatives(x, y)
        assert isinstance(d, np.ndarray)

    def test_mismatched_lengths_raise(self):
        with pytest.raises(AssertionError):
            compute_hermite_derivatives(np.array([0.0, 1.0]), np.array([1.0]))

    def test_non_increasing_x_raises(self):
        with pytest.raises(AssertionError):
            compute_hermite_derivatives(np.array([2.0, 1.0]), np.array([1.0, 2.0]))

    def test_monotonicity_flag_does_not_change_output_length(self):
        x = np.array([0.0, 1.0, 2.0, 3.0, 4.0])
        y = np.array([0.0, 1.0, 1.0, 2.0, 3.0])
        d = compute_hermite_derivatives(x, y, ensure_monotonicity=True)
        assert len(d) == len(x)


# ---------------------------------------------------------------------------
# getGeometry
# ---------------------------------------------------------------------------
class TestGetGeometry:
    """Tests for the sun-position geometry function."""

    def _run(self, **kwargs):
        defaults = dict(
            initialTime=0,
            timeDiscretization=3600,
            timesteps=8760,
            timeZone=1,
            location=(50.76, 6.07),
            altitude=0,
        )
        defaults.update(kwargs)
        return getGeometry(**defaults)

    def test_returns_five_arrays(self):
        result = self._run()
        assert len(result) == 5

    def test_output_arrays_have_correct_length(self):
        n = 100
        omega, delta, thetaZ, airmass, Gon = self._run(timesteps=n)
        for arr in (omega, delta, thetaZ, airmass, Gon):
            assert len(arr) == n

    def test_omega_within_bounds(self):
        omega, *_ = self._run()
        assert np.all(omega >= -180) and np.all(omega <= 180)

    def test_declination_within_bounds(self):
        _, delta, *_ = self._run()
        # Declination: −23.45 <= delta <= 23.45 (with a small tolerance)
        assert np.all(delta >= -24) and np.all(delta <= 24)

    def test_zenith_angle_nonnegative(self):
        _, _, thetaZ, *_ = self._run()
        assert np.all(thetaZ >= 0)

    def test_airmass_positive(self):
        _, _, _, airmass, _ = self._run()
        assert np.all(airmass > 0)

    def test_Gon_positive(self):
        *_, Gon = self._run()
        assert np.all(Gon > 0)


# ---------------------------------------------------------------------------
# getIncidenceAngle
# ---------------------------------------------------------------------------
class TestGetIncidenceAngle:
    def _geometry(self, n=8760):
        return getGeometry(0, 3600, n, timeZone=1, location=(50.76, 6.07), altitude=0)

    def test_returns_two_arrays(self):
        omega, delta, *_ = self._geometry()
        result = getIncidenceAngle(35, 0, 50.76, omega, delta)
        assert len(result) == 2

    def test_cosTheta_nonnegative(self):
        omega, delta, *_ = self._geometry()
        cosTheta, theta = getIncidenceAngle(35, 0, 50.76, omega, delta)
        assert np.all(cosTheta >= 0)

    def test_theta_nonnegative(self):
        omega, delta, *_ = self._geometry()
        _, theta = getIncidenceAngle(35, 0, 50.76, omega, delta)
        assert np.all(theta >= 0)

    def test_horizontal_surface_incidence_equals_zenith(self):
        """For a horizontal surface (beta=0), incidence angle equals zenith angle."""
        omega, delta, thetaZ, *_ = self._geometry(n=24)
        _, theta = getIncidenceAngle(0, 0, 50.76, omega, delta)
        np.testing.assert_allclose(theta, thetaZ, atol=1e-8)


# ---------------------------------------------------------------------------
# getTotalRadiationTiltedSurface
# ---------------------------------------------------------------------------
class TestGetTotalRadiationTiltedSurface:
    def _inputs(self, n=8760):
        geo = getGeometry(0, 3600, n)
        omega, delta, thetaZ, airmass, Gon = geo
        _, theta = getIncidenceAngle(35, 0, 50.76, omega, delta)
        beam = np.maximum(0, np.random.default_rng(0).normal(200, 100, n))
        diffuse = np.maximum(0, np.random.default_rng(1).normal(100, 50, n))
        return theta, thetaZ, beam, diffuse, airmass, Gon

    def test_returns_four_arrays(self):
        theta, thetaZ, beam, diffuse, airmass, Gon = self._inputs(100)
        result = getTotalRadiationTiltedSurface(
            theta, thetaZ, beam, diffuse, airmass, Gon, beta=35, albedo=0.2
        )
        assert len(result) == 4

    def test_direct_component_nonnegative(self):
        theta, thetaZ, beam, diffuse, airmass, Gon = self._inputs(100)
        _, direct, _, _ = getTotalRadiationTiltedSurface(
            theta, thetaZ, beam, diffuse, airmass, Gon, beta=35, albedo=0.2
        )
        assert np.all(direct >= 0)

    def test_zero_irradiance_gives_zero_total(self):
        n = 50
        geo = getGeometry(0, 3600, n)
        omega, delta, thetaZ, airmass, Gon = geo
        _, theta = getIncidenceAngle(35, 0, 50.76, omega, delta)
        zeros = np.zeros(n)
        total, direct, diffuse, reflected = getTotalRadiationTiltedSurface(
            theta, thetaZ, zeros, zeros, airmass, Gon, beta=35, albedo=0.2
        )
        np.testing.assert_allclose(total, 0.0, atol=1e-10)
        np.testing.assert_allclose(direct, 0.0, atol=1e-10)
