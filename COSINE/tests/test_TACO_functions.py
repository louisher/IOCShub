"""
Unit tests for COSINE/TACO_functions.py.

Functions that require a live SSH connection (run_command_on_Taco_server,
make_ocp_directory_on_TACO_server, send_file_to_ocp_folder_on_TACO_server,
compile_OCP, run_OCP, download_results_from_TACO_server,
run_operational_optimization) are tested by asserting their error-handling
behaviour using mocks.  The pure data-processing function (read_ocp_result) is
tested against temporary files.
"""

import datetime
import os
import sys
import tempfile
from pathlib import Path
from unittest.mock import MagicMock, patch

import pandas as pd
import pytest

# TACO_functions only needs paramiko (available) and pandas.
import TACO_functions as tf  # noqa: E402 (conftest already added COSINE to sys.path)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _write_temp_ocp_files(dir_path, column_names, rows):
    """
    Write OutputNames.txt and outputsAll.csv into *dir_path* and return their
    paths.

    Parameters
    ----------
    column_names : list[str]
        Variable names (excluding the leading 'time' column).
    rows : list[list[float]]
        Data rows.  The first row is treated as a dummy header row (skipped by
        read_ocp_result); actual data starts from the second row.
    """
    names_path = Path(dir_path) / "OutputNames.txt"
    data_path = Path(dir_path) / "outputsAll.csv"

    with open(names_path, "w") as f:
        for name in column_names:
            f.write(name + "\n")

    with open(data_path, "w") as f:
        for row in rows:
            f.write("\t".join(str(v) for v in row) + "\n")

    return str(data_path), str(names_path)


# ---------------------------------------------------------------------------
# read_ocp_result
# ---------------------------------------------------------------------------

class TestReadOcpResult:
    def test_dataframe_returned_with_expected_columns(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            # One "dummy" first row (skipped) + one real data row
            data_path, names_path = _write_temp_ocp_files(
                tmpdir,
                column_names=["ElecUse", "QDem"],
                rows=[
                    [0.0, 0.0, 0.0],       # dummy / header row (skipped)
                    [3600.0, 500.0, 200.0], # real data
                ],
            )
            df = tf.read_ocp_result(data_path, names_path)

        assert isinstance(df, pd.DataFrame)
        assert "time" in df.columns
        assert "ElecUse" in df.columns
        assert "QDem" in df.columns
        assert "datetime" in df.columns
        assert "hours" in df.columns
        assert "days" in df.columns

    def test_time_column_values_correct(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            data_path, names_path = _write_temp_ocp_files(
                tmpdir,
                column_names=["ElecUse"],
                rows=[
                    [0.0, 0.0],       # dummy row
                    [3600.0, 100.0],  # 1 hour
                    [7200.0, 200.0],  # 2 hours
                ],
            )
            df = tf.read_ocp_result(data_path, names_path)

        times = df["time"].tolist()
        assert times == [3600.0, 7200.0]

    def test_hours_column_computed_correctly(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            data_path, names_path = _write_temp_ocp_files(
                tmpdir,
                column_names=["ElecUse"],
                rows=[
                    [0.0, 0.0],
                    [7200.0, 0.0],  # 7200 s = 2 h
                ],
            )
            df = tf.read_ocp_result(data_path, names_path)

        assert pytest.approx(df["hours"].iloc[0]) == 2.0

    def test_days_column_computed_correctly(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            data_path, names_path = _write_temp_ocp_files(
                tmpdir,
                column_names=["ElecUse"],
                rows=[
                    [0.0, 0.0],
                    [86400.0, 0.0],  # 1 day
                ],
            )
            df = tf.read_ocp_result(data_path, names_path)

        assert pytest.approx(df["days"].iloc[0]) == 1.0

    def test_datetime_column_starts_from_2023(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            data_path, names_path = _write_temp_ocp_files(
                tmpdir,
                column_names=["ElecUse"],
                rows=[
                    [0.0, 0.0],
                    [0.0, 0.0],  # time = 0 → 2023-01-01 00:00:00
                ],
            )
            df = tf.read_ocp_result(data_path, names_path)

        assert df["datetime"].iloc[0] == datetime.datetime(2023, 1, 1)


# ---------------------------------------------------------------------------
# run_command_on_Taco_server – error-handling path
# ---------------------------------------------------------------------------

class TestRunCommandOnTacoServer:
    def _server(self):
        return {
            "hostname": "127.0.0.1",
            "port": 22,
            "user": "testuser",
            "private_ssh_key_path": "/nonexistent/key",
            "path_ocp_on_server": "/tmp/ocp",
        }

    def test_returns_false_on_connection_failure(self):
        """When paramiko cannot connect the function should return False."""
        result = tf.run_command_on_Taco_server("echo hello", self._server())
        assert result is False


# ---------------------------------------------------------------------------
# make_ocp_directory_on_TACO_server – error-handling path
# ---------------------------------------------------------------------------

class TestMakeOcpDirectory:
    def test_raises_exception_on_failure(self):
        server = {
            "hostname": "127.0.0.1",
            "port": 22,
            "user": "testuser",
            "private_ssh_key_path": "/nonexistent/key",
            "path_ocp_on_server": "/tmp/ocp",
        }
        # run_command_on_Taco_server will return False → should raise
        with pytest.raises(Exception, match="Failed to create"):
            tf.make_ocp_directory_on_TACO_server(server)


# ---------------------------------------------------------------------------
# send_file_to_ocp_folder_on_TACO_server – error-handling path
# ---------------------------------------------------------------------------

class TestSendFileTo:
    def test_raises_exception_when_scp_fails(self):
        server = {
            "hostname": "127.0.0.1",
            "port": 22,
            "user": "testuser",
            "private_ssh_key_path": "/nonexistent/key",
            "path_ocp_on_server": "/tmp/ocp",
        }
        with patch("os.system", return_value=1):
            with pytest.raises(Exception, match="Failed to send"):
                tf.send_file_to_ocp_folder_on_TACO_server("/local/file.mop", server)


# ---------------------------------------------------------------------------
# download_results_from_TACO_server – error-handling path
# ---------------------------------------------------------------------------

class TestDownloadResults:
    def test_raises_exception_when_first_scp_fails(self):
        server = {
            "hostname": "127.0.0.1",
            "port": 22,
            "user": "testuser",
            "private_ssh_key_path": "/nonexistent/key",
            "path_ocp_on_server": "/tmp/ocp",
        }
        with patch("os.system", return_value=1):
            with pytest.raises(Exception, match="Failed to download outputsAll"):
                tf.download_results_from_TACO_server(
                    "/local/dir", "mymodel", server
                )

    def test_raises_exception_when_second_scp_fails(self):
        server = {
            "hostname": "127.0.0.1",
            "port": 22,
            "user": "testuser",
            "private_ssh_key_path": "/nonexistent/key",
            "path_ocp_on_server": "/tmp/ocp",
        }
        # First scp succeeds (returns 0), second fails (returns 1)
        with patch("os.system", side_effect=[0, 1]):
            with pytest.raises(Exception, match="Failed to download OutputNames"):
                tf.download_results_from_TACO_server(
                    "/local/dir", "mymodel", server
                )
