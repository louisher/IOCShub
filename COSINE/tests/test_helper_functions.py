"""
Unit tests for COSINE/helper_functions.py.

Heavy third-party dependencies that are not required to test the pure helper
functions are mocked at sys.modules level *before* importing helper_functions.
"""

import json
import math
import os
import sys
import tempfile
from unittest.mock import MagicMock

import numpy as np
import pandas as pd
import pytest

# ---------------------------------------------------------------------------
# Mock optional heavy dependencies so helper_functions can be imported
# ---------------------------------------------------------------------------
for _mod in ("load_params", "optim_model", "borefield_params", "eff_tables"):
    sys.modules.setdefault(_mod, MagicMock())

import helper_functions as hf  # noqa: E402  (must come after mocks)


# ---------------------------------------------------------------------------
# Helpers / fixtures
# ---------------------------------------------------------------------------

def _simple_devices_info():
    """Return a minimal devices_info dict that mirrors the real structure."""
    return {
        "GSHP": {
            "feasible": True,
            "size_parameters": {
                "Size": {"value": 44.0, "name_in_mop": "enerHub.Size_GsHp=", "excel_row": 4}
            },
            "inv_cost": 250,
            "life_time": 20,
            "cost_om": 0.03,
        },
        "ASHP": {
            "feasible": True,
            "size_parameters": {
                "Size": {"value": 28.0, "name_in_mop": "enerHub.Size_AsHp=", "excel_row": 3}
            },
            "inv_cost": 900,
            "life_time": 20,
            "cost_om": 0.03,
        },
    }


# ---------------------------------------------------------------------------
# calculate_NPV_factor_inv_costs
# ---------------------------------------------------------------------------

class TestCalculateNPVFactor:
    def test_basic_case(self):
        """NPV factor with known parameters should be > 1 (replacements add cost)."""
        factor = hf.calculate_NPV_factor_inv_costs(
            interest_rate=0.05, life_time=20, observation_time=40
        )
        assert factor > 1.0

    def test_no_replacement_within_observation_period(self):
        """When life_time >= observation_time there are no replacement costs."""
        factor_long = hf.calculate_NPV_factor_inv_costs(
            interest_rate=0.05, life_time=40, observation_time=40
        )
        factor_no_replace = hf.calculate_NPV_factor_inv_costs(
            interest_rate=0.05, life_time=100, observation_time=40
        )
        # Both should be around 1 (initial investment only) minus residual value
        assert 0 < factor_long < 2
        assert 0 < factor_no_replace < 2

    def test_zero_interest_rate_raises(self):
        with pytest.raises(ValueError):
            hf.calculate_NPV_factor_inv_costs(
                interest_rate=-0.01, life_time=20, observation_time=40
            )

    def test_zero_life_time_raises(self):
        with pytest.raises(ValueError):
            hf.calculate_NPV_factor_inv_costs(
                interest_rate=0.05, life_time=0, observation_time=40
            )

    def test_zero_observation_time_raises(self):
        with pytest.raises(ValueError):
            hf.calculate_NPV_factor_inv_costs(
                interest_rate=0.05, life_time=20, observation_time=0
            )

    def test_returns_float(self):
        result = hf.calculate_NPV_factor_inv_costs(
            interest_rate=0.05, life_time=20, observation_time=40
        )
        assert isinstance(result, float)


# ---------------------------------------------------------------------------
# update_computational_times
# ---------------------------------------------------------------------------

class TestUpdateComputationalTimes:
    def _base_dict(self):
        return {
            "write_inputs_time": {"value": 0, "excel_row": 29},
            "load_params_time": {"value": 0, "excel_row": 30},
            "size_optim_time": {"value": 0, "excel_row": 31},
            "ocp_compilation_time": {"value": 0, "excel_row": 32},
            "ocp_optimization_time": {"value": 0, "excel_row": 33},
            "total_iteration_time": {"value": 0, "excel_row": 34},
        }

    def test_values_updated_correctly(self):
        ct = self._base_dict()
        result = hf.update_computational_times(ct, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
        assert result["write_inputs_time"]["value"] == 1.0
        assert result["load_params_time"]["value"] == 2.0
        assert result["size_optim_time"]["value"] == 3.0
        assert result["ocp_compilation_time"]["value"] == 4.0
        assert result["ocp_optimization_time"]["value"] == 5.0
        assert result["total_iteration_time"]["value"] == 6.0

    def test_returns_same_dict(self):
        ct = self._base_dict()
        result = hf.update_computational_times(ct, 0, 0, 0, 0, 0, 0)
        assert result is ct  # should modify in place and return

    def test_non_dict_raises_type_error(self):
        with pytest.raises(TypeError):
            hf.update_computational_times("not_a_dict", 0, 0, 0, 0, 0, 0)

    def test_missing_key_raises_key_error(self):
        with pytest.raises(KeyError):
            hf.update_computational_times({"bad_key": {"value": 0}}, 1, 2, 3, 4, 5, 6)


# ---------------------------------------------------------------------------
# read_elec_use
# ---------------------------------------------------------------------------

class TestReadElecUse:
    def test_positive_values_only_offtake(self):
        df = pd.DataFrame({"ElecUse": [1000.0, 2000.0, 3000.0]})  # W
        offtake, injection = hf.read_elec_use(df)
        # sum = 6000 W = 6 kW, / 1e3 -> 0.006 MWh
        assert pytest.approx(offtake, rel=1e-6) == 6000.0 / 1e6
        assert injection == 0.0

    def test_negative_values_only_injection(self):
        df = pd.DataFrame({"ElecUse": [-1000.0, -2000.0]})
        offtake, injection = hf.read_elec_use(df)
        assert offtake == 0.0
        assert pytest.approx(injection, rel=1e-6) == 3000.0 / 1e6

    def test_mixed_values(self):
        df = pd.DataFrame({"ElecUse": [1000.0, -500.0]})
        offtake, injection = hf.read_elec_use(df)
        assert pytest.approx(offtake, rel=1e-6) == 1000.0 / 1e6
        assert pytest.approx(injection, rel=1e-6) == 500.0 / 1e6

    def test_non_dataframe_raises_type_error(self):
        with pytest.raises(TypeError):
            hf.read_elec_use([1, 2, 3])

    def test_missing_column_raises_key_error(self):
        df = pd.DataFrame({"WrongCol": [1.0]})
        with pytest.raises(KeyError):
            hf.read_elec_use(df)


# ---------------------------------------------------------------------------
# read_discomfort
# ---------------------------------------------------------------------------

class TestReadDiscomfort:
    def test_basic_values(self):
        df = pd.DataFrame({"DiscmfHea": [1.0, 2.0], "DiscmfCoo": [0.5, 1.5]})
        hea, coo = hf.read_discomfort(df)
        assert pytest.approx(hea) == 3.0
        assert pytest.approx(coo) == 2.0

    def test_zero_discomfort(self):
        df = pd.DataFrame({"DiscmfHea": [0.0, 0.0], "DiscmfCoo": [0.0, 0.0]})
        hea, coo = hf.read_discomfort(df)
        assert hea == 0.0
        assert coo == 0.0

    def test_non_dataframe_raises_type_error(self):
        with pytest.raises(TypeError):
            hf.read_discomfort({"DiscmfHea": [1]})

    def test_missing_column_raises_key_error(self):
        df = pd.DataFrame({"DiscmfHea": [1.0]})
        with pytest.raises(KeyError):
            hf.read_discomfort(df)


# ---------------------------------------------------------------------------
# convert_numpy_to_list_sizing_result_dict
# ---------------------------------------------------------------------------

class TestConvertNumpyToList:
    def test_array_converted(self):
        obj = {"a": np.array([1, 2, 3])}
        result = hf.convert_numpy_to_list_sizing_result_dict(obj)
        assert isinstance(result["a"], list)
        assert result["a"] == [1, 2, 3]

    def test_nested_dict(self):
        obj = {"outer": {"inner": np.array([4.0, 5.0])}}
        result = hf.convert_numpy_to_list_sizing_result_dict(obj)
        assert result["outer"]["inner"] == [4.0, 5.0]

    def test_list_of_arrays(self):
        obj = [np.array([1, 2]), np.array([3, 4])]
        result = hf.convert_numpy_to_list_sizing_result_dict(obj)
        assert result == [[1, 2], [3, 4]]

    def test_scalar_unchanged(self):
        assert hf.convert_numpy_to_list_sizing_result_dict(42) == 42
        assert hf.convert_numpy_to_list_sizing_result_dict("hello") == "hello"


# ---------------------------------------------------------------------------
# set_sizes_of_non_feasible_devices_to_zero
# ---------------------------------------------------------------------------

class TestSetSizesOfNonFeasibleDevices:
    def _devices_with_infeasible_ashp(self):
        return {
            "ASHP": {
                "feasible": False,
                "size_parameters": {"Size": {"value": 50.0}},
            },
            "GSHP": {
                "feasible": True,
                "size_parameters": {"Size": {"value": 40.0}},
            },
        }

    def test_infeasible_device_size_set_to_small_value(self):
        devices = self._devices_with_infeasible_ashp()
        result = hf.set_sizes_of_non_feasible_devices_to_zero(devices)
        assert result["ASHP"]["size_parameters"]["Size"]["value"] == 0.01

    def test_feasible_device_size_unchanged(self):
        devices = self._devices_with_infeasible_ashp()
        result = hf.set_sizes_of_non_feasible_devices_to_zero(devices)
        assert result["GSHP"]["size_parameters"]["Size"]["value"] == 40.0

    def test_infeasible_borefield(self):
        devices = {
            "Borefield": {
                "feasible": False,
                "size_parameters": {
                    "Size": {"value": 1000},
                    "depth": {"value": 100},
                    "nBor": {"value": 10},
                },
            }
        }
        result = hf.set_sizes_of_non_feasible_devices_to_zero(devices)
        assert result["Borefield"]["size_parameters"]["Size"]["value"] == 0
        assert result["Borefield"]["size_parameters"]["depth"]["value"] == 1
        assert result["Borefield"]["size_parameters"]["nBor"]["value"] == 1

    def test_infeasible_bat(self):
        devices = {
            "BAT": {
                "feasible": False,
                "size_parameters": {
                    "Size": {"value": 5.0},
                    "hasBat": {"value": "true"},
                    "PCha_max": {"value": 2.5},
                },
            }
        }
        result = hf.set_sizes_of_non_feasible_devices_to_zero(devices)
        assert result["BAT"]["size_parameters"]["hasBat"]["value"] == "false"
        assert result["BAT"]["size_parameters"]["PCha_max"]["value"] == 0.01


# ---------------------------------------------------------------------------
# add_NPV_of_rel_inv_cost_to_devices_info
# ---------------------------------------------------------------------------

class TestAddNPVToDevicesInfo:
    def test_npv_inv_cost_added(self):
        devices = {
            "GSHP": {"life_time": 20, "inv_cost": 250},
            "ASHP": {"life_time": 20, "inv_cost": 900},
        }
        result = hf.add_NPV_of_rel_inv_cost_to_devices_info(devices, 0.05, 40)
        assert "NPV_inv_cost" in result["GSHP"]
        assert "NPV_inv_cost" in result["ASHP"]
        assert result["GSHP"]["NPV_inv_cost"] > 0
        assert result["ASHP"]["NPV_inv_cost"] > result["GSHP"]["NPV_inv_cost"]

    def test_missing_key_raises(self):
        with pytest.raises(KeyError):
            hf.add_NPV_of_rel_inv_cost_to_devices_info(
                {"DEV": {"life_time": 20}}, 0.05, 40  # missing inv_cost
            )


# ---------------------------------------------------------------------------
# calculate_capex
# ---------------------------------------------------------------------------

class TestCalculateCapex:
    def _devices(self):
        d = _simple_devices_info()
        # Pre-populate NPV_inv_cost as add_NPV_of_rel_inv_cost_to_devices_info would
        d["GSHP"]["NPV_inv_cost"] = 250 * 1.5  # simplified
        d["ASHP"]["NPV_inv_cost"] = 900 * 1.5
        return d

    def test_capex_computed(self):
        devices = self._devices()
        capex, updated = hf.calculate_capex(devices, 0.05, 40)
        expected = (250 * 1.5 * 44.0) + (900 * 1.5 * 28.0)
        assert pytest.approx(capex, rel=1e-6) == expected

    def test_capex_stored_per_device(self):
        devices = self._devices()
        _, updated = hf.calculate_capex(devices, 0.05, 40)
        assert "capex" in updated["GSHP"]
        assert "capex" in updated["ASHP"]


# ---------------------------------------------------------------------------
# calculate_opex_and_maintCost
# ---------------------------------------------------------------------------

class TestCalculateOpexAndMaintCost:
    def _op_vars(self, offtake=10.0, injection=2.0):
        return {
            "elec_offtake": {"value": offtake},
            "elec_injection": {"value": injection},
        }

    def _devices(self):
        d = _simple_devices_info()
        return d

    def test_returns_three_values(self):
        result = hf.calculate_opex_and_maintCost(
            self._op_vars(), self._devices(), 0.05, 40, 300, 35
        )
        assert len(result) == 3

    def test_opex_positive_when_more_offtake_than_injection(self):
        opex, maint, _ = hf.calculate_opex_and_maintCost(
            self._op_vars(offtake=10, injection=0),
            self._devices(),
            0.05,
            40,
            300,
            35,
        )
        assert opex > 0

    def test_negative_interest_rate_raises(self):
        with pytest.raises(ValueError):
            hf.calculate_opex_and_maintCost(
                self._op_vars(), self._devices(), -0.05, 40, 300, 35
            )

    def test_zero_observation_time_raises(self):
        with pytest.raises(ValueError):
            hf.calculate_opex_and_maintCost(
                self._op_vars(), self._devices(), 0.05, 0, 300, 35
            )

    def test_maint_cost_nonnegative(self):
        _, maint, _ = hf.calculate_opex_and_maintCost(
            self._op_vars(), self._devices(), 0.05, 40, 300, 35
        )
        assert maint >= 0


# ---------------------------------------------------------------------------
# load_json_file_as_dict
# ---------------------------------------------------------------------------

class TestLoadJsonFileAsDict:
    def test_valid_json_loaded(self):
        data = {"key": "value", "number": 42}
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        ) as f:
            json.dump(data, f)
            tmp_path = f.name
        try:
            result = hf.load_json_file_as_dict(tmp_path)
            assert result == data
        finally:
            os.unlink(tmp_path)

    def test_missing_file_raises_file_not_found(self):
        with pytest.raises(FileNotFoundError):
            hf.load_json_file_as_dict("/nonexistent/path/file.json")

    def test_invalid_json_raises_decode_error(self):
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        ) as f:
            f.write("{ this is not valid JSON }")
            tmp_path = f.name
        try:
            with pytest.raises(json.JSONDecodeError):
                hf.load_json_file_as_dict(tmp_path)
        finally:
            os.unlink(tmp_path)


# ---------------------------------------------------------------------------
# change_model_name_in_mop
# ---------------------------------------------------------------------------

class TestChangeModelNameInMop:
    def _write_mop(self, content):
        f = tempfile.NamedTemporaryFile(
            mode="w", suffix=".mop", delete=False
        )
        f.write(content)
        f.close()
        return f.name

    def test_replaces_optimization_line(self):
        content = "optimization OldModel\n\tsome content\nend OldModel\n"
        path = self._write_mop(content)
        try:
            hf.change_model_name_in_mop(path, "OldModel", "NewModel")
            with open(path) as f:
                lines = f.readlines()
            assert "optimization NewModel" in lines[0]
            assert "end NewModel" in lines[2]
        finally:
            os.unlink(path)

    def test_non_matching_lines_unchanged(self):
        content = "some random line\noptimization OldModel\n"
        path = self._write_mop(content)
        try:
            hf.change_model_name_in_mop(path, "OldModel", "NewModel")
            with open(path) as f:
                lines = f.readlines()
            assert "some random line" in lines[0]
        finally:
            os.unlink(path)

    def test_missing_file_raises(self):
        with pytest.raises(FileNotFoundError):
            hf.change_model_name_in_mop("/no/such/file.mop", "old", "new")


# ---------------------------------------------------------------------------
# change_weather_file_in_mop
# ---------------------------------------------------------------------------

class TestChangeWeatherFileInMop:
    def _write_mop(self, content):
        f = tempfile.NamedTemporaryFile(
            mode="w", suffix=".mop", delete=False
        )
        f.write(content)
        f.close()
        return f.name

    def test_weather_file_replaced(self):
        content = (
            "before\n"
            '\t\t\t\t\t\t\t\t\tsim.filNam=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/weatherdata//old.mos"),\n'
            "after\n"
        )
        path = self._write_mop(content)
        try:
            hf.change_weather_file_in_mop(path, "new_weather.mos")
            with open(path) as f:
                text = f.read()
            assert "new_weather.mos" in text
            assert "old.mos" not in text
        finally:
            os.unlink(path)

    def test_missing_weather_line_raises_value_error(self):
        content = "no weather line here\n"
        path = self._write_mop(content)
        try:
            with pytest.raises(ValueError):
                hf.change_weather_file_in_mop(path, "weather.mos")
        finally:
            os.unlink(path)

    def test_missing_file_raises(self):
        with pytest.raises(FileNotFoundError):
            hf.change_weather_file_in_mop("/no/such/file.mop", "weather.mos")


# ---------------------------------------------------------------------------
# set_size_parameters_in_mop
# ---------------------------------------------------------------------------

class TestSetSizeParametersInMop:
    def _write_mop(self, content):
        f = tempfile.NamedTemporaryFile(mode="w", suffix=".mop", delete=False)
        f.write(content)
        f.close()
        return f.name

    def test_size_parameter_updated(self):
        content = "\t\t\t\t\t\t\t\t\tenerHub.Size_GsHp=44.0,\n"
        devices_info = {
            "GSHP": {
                "size_parameters": {
                    "Size": {"name_in_mop": "enerHub.Size_GsHp=", "value": 55.0}
                }
            }
        }
        path = self._write_mop(content)
        try:
            hf.set_size_parameters_in_mop(path, devices_info)
            with open(path) as f:
                text = f.read()
            assert "55.0" in text
        finally:
            os.unlink(path)

    def test_missing_file_raises(self):
        with pytest.raises(FileNotFoundError):
            hf.set_size_parameters_in_mop(
                "/no/such/file.mop",
                {"DEV": {"size_parameters": {"Size": {"name_in_mop": "x=", "value": 1}}}},
            )
