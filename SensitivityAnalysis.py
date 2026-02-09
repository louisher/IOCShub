import os
import sys


import shutil
from pathlib import Path
from matplotlib import pyplot as plt
from time import perf_counter
import json
import argparse
import itertools
import pandas as pd
import datetime
import numpy as np


def create_directory(path):
    """Create a directory by removing it first if it already exists"""
    try:
        if path.exists():
            print(f"Deleting existing directory: {path}")
            shutil.rmtree(path)

        path.mkdir(parents=True, exist_ok=False)
        print(f"Created directory: {path}")
        return True

    except Exception as e:
        print(f"An error occurred while creating the directory: {e}")
        return False


def run_command(command, dir):
    """Run a command in the provided directory"""

    try:
        print(f"Running command in {dir}: {command}")
        os.system(f"cd {dir} && {command}")
        return True
    except Exception as e:
        print(f"An error occurred while running the command: {e}")
        return False


def change_model_name_in_mop(path_mop_file, old_name, new_name):
    """
    Updates the model name in a MOP file by replacing all occurrences of the old model name
    with a new model name in lines that start with 'optimization' or 'end'.
    Args:
        path_mop_file (str): The file path to the MOP file to be modified.
        old_name (str): The current model name to be replaced.
        new_name (str): The new model name to use as a replacement.
    Notes:
        - Only lines containing 'optimization {old_name}' or 'end {old_name}' are modified.
        - The file is read and written in-place.
    """

    # This functions changes the name of the mop file in the beginning and end of the mop file
    with open(path_mop_file, "r") as file:
        lines = file.readlines()
    for i, line in enumerate(lines):
        if f"optimization {old_name}" in line or f"end {old_name}" in line:
            lines[i] = line.replace(old_name, new_name)

    with open(path_mop_file, "w") as file:
        file.writelines(lines)


def change_hasBat_in_mop(path_mop_file, hasBat):
    """
    Updates the 'hasBat' parameter in a MOP file.
    This function searches for the line containing 'enerHub.hasBat=' and replaces it with a new line
    that sets 'hasBat' to the provided boolean value.
    Parameters:
        path_mop_file (str): The file path to the MOP file to be updated.
        hasBat (bool): The boolean value to set for 'hasBat'.
    Returns:
        None
    """

    with open(path_mop_file, "r") as file:
        lines = file.readlines()
    for i, line in enumerate(lines):
        if "enerHub.hasBat=" in line:
            lines[i] = f"\t\t\t\t\t\t\t\t\tenerHub.hasBat={str(hasBat).lower()},\n"

    with open(path_mop_file, "w") as file:
        file.writelines(lines)


def set_json_paths_in_mop(path_mop_file, devices_json, economic_params_json):
    """
    Updates the specified MOP file by setting the paths for devices and economic parameters JSON files.
    This function searches for specific lines in the MOP file that contain
    'priceSim.path_economic_params_json=' and 'enerHub.path_devices_json='.
    When found, it replaces these lines with new lines that set the paths to the provided JSON files.
    Parameters:
        path_mop_file (str): The file path to the MOP file to be updated.
        devices_json (str): The file path to the devices JSON file.
        economic_params_json (str): The file path to the economic parameters JSON file.
    Returns:
        None
    """

    with open(path_mop_file, "r") as file:
        lines = file.readlines()
    for i, line in enumerate(lines):
        if "priceSim.path_economic_params_json=" in line:
            lines[i] = (
                f'\t\t\t\t\t\t\t\t\tpriceSim.path_economic_params_json="{economic_params_json}",\n'
            )

        if "path_devices_json=" in line:
            lines[i] = (
                f'\t\t\t\t\t\t\t\t\tenerHub.path_devices_json="{devices_json}",\n'
            )

    with open(path_mop_file, "w") as file:
        file.writelines(lines)


def change_inv_values_in_json(path_json_file, inv_values):
    """
    Updates the investment cost values in a JSON file based on the provided dictionary.
    Args:
        path_json_file (str): The file path to the JSON file to be modified.
        inv_values (dict): A dictionary containing the investment cost values to be updated.
                           Keys should match the keys in the JSON file.
    Notes:
        - The function reads the JSON file, updates the specified keys with new values,
          and writes the changes back to the same file.
        - If a key from inv_values does not exist in the JSON file, it is ignored.
    """

    # This function changes the inv_cost values in the input_data/parameters.json file
    with open(path_json_file, "r") as file:
        data = json.load(file)

    for key, value in inv_values.items():
        if key in data:
            data[key]["inv_cost"] = value

    with open(path_json_file, "w") as file:
        json.dump(data, file, indent=4)


def change_economic_params_in_json(path_json_file, economic_params):

    # This function changes the economic parameters in the input_data/parameters.json file
    with open(path_json_file, "r") as file:
        data = json.load(file)
    for key, value in economic_params.items():
        if key in data:
            data[key] = value
    with open(path_json_file, "w") as file:
        json.dump(data, file, indent=4)


def read_ocp_result(path_outputsAll, path_OutputNames):
    # fmt: off
    column_names = pd.read_csv(path_OutputNames, header=None)
    column_names = column_names[0].tolist()
    column_names = ["time"] + column_names  # Assuming your time column is named "time"

    df = pd.read_csv(
        path_outputsAll,
        comment="#",
        skiprows=0,
        sep="\t",
        header=None,
        names=column_names,
    )
    df = df.iloc[1:]
    df = df.astype(float)

    start_date = datetime.datetime(2023, 1, 1)  # Set your desired start date
    df["datetime"] = [start_date + datetime.timedelta(seconds=time) for time in df["time"]]
    df["hours"] = [datetime.timedelta(seconds=time).total_seconds() / 3600 for time in df["time"]]
    df["days"] = [datetime.timedelta(seconds=time).total_seconds() / 86400 for time in df["time"]]
    # fmt: on
    return df


# Read first argument without flag
parser = argparse.ArgumentParser(description="Script for sensitivity analysis")
parser.add_argument("model_name", help="Name of the model (no flag needed)")
parser.add_argument("--id", help="Run identifier", default="")
parser.add_argument("--weather", help="Weather identifier", default="")
parser.add_argument("-w", "--warm-start", action="store_true", help="Enable warm start")
args = parser.parse_args()

model_name = args.model_name
run_identifier = args.id
weather_id = args.weather
WARM_START = args.warm_start

# Define paths
pwd = Path.cwd()
run_dir = pwd / f"Run_{run_identifier}_{weather_id}"
Compiled_models_dir = run_dir / "CompiledModels"
MopFiles_dir = pwd / "MopFiles"

# Create directories
create_directory(run_dir)
create_directory(Compiled_models_dir)


# inv_sweep = {
#     "GSHP": [125, 250, 375],
#     "Borefield": [30, 40, 60],
#     "ASHP": [450, 900, 1350],
# }  # inv_cost values to sweep
# fill in keys as in json file
inv_sweep = {
    "GSHP": [250],
    "Borefield": [40],
    "ASHP": [900],
    # "ASCHI": [900, 450], # Set equal to ASHP later
    "STC": [400],
    "PVT": [500],
    "PV": [200],
    "TES": [1000],
    "BAT": [500],
}  # inv_cost values to sweep
# Fill in economic parameters to sweep as in json file
economic_sweep = {
    "ELEC_PRICE_OFFTAKE": [300],
    "ELEC_PRICE_INJECTION": [35],
}  # economic parameters to sweep


HP_combinations = [
    (250, 20, 450, 400, 500, 200, 1000, 500, 300, 35),
    (250, 20, 900, 400, 500, 200, 1000, 500, 300, 35),
    (250, 20, 1350, 400, 500, 200, 1000, 500, 300, 35),
    (250, 40, 450, 400, 500, 200, 1000, 500, 300, 35),
    (250, 40, 900, 400, 500, 200, 1000, 500, 300, 35),
    (250, 40, 1350, 400, 500, 200, 1000, 500, 300, 35),
    (250, 60, 450, 400, 500, 200, 1000, 500, 300, 35),
    (250, 60, 900, 400, 500, 200, 1000, 500, 300, 35),
    (250, 60, 1350, 400, 500, 200, 1000, 500, 300, 35),
]

ELEC_combinations = [
    (250, 40, 900, 400, 500, 200, 1000, 500, 200, 20),
    (250, 40, 900, 400, 500, 200, 1000, 500, 200, 35),
    (250, 40, 900, 400, 500, 200, 1000, 500, 200, 50),
    (250, 40, 900, 400, 500, 200, 1000, 500, 300, 20),
    (250, 40, 900, 400, 500, 200, 1000, 500, 300, 35),
    (250, 40, 900, 400, 500, 200, 1000, 500, 300, 50),
    (250, 40, 900, 400, 500, 200, 1000, 500, 400, 20),
    (250, 40, 900, 400, 500, 200, 1000, 500, 400, 35),
    (250, 40, 900, 400, 500, 200, 1000, 500, 400, 50),
]

STC_combinations = [
    (250, 40, 900, 200, 500, 200, 1000, 500, 300, 35),
    (250, 40, 900, 300, 500, 200, 1000, 500, 300, 35),
    (250, 40, 900, 400, 500, 200, 1000, 500, 300, 35),
]

PVT_combinations = [
    (250, 40, 900, 400, 200, 200, 1000, 500, 300, 35),
    (250, 40, 900, 400, 350, 200, 1000, 500, 300, 35),
    (250, 40, 900, 400, 500, 200, 1000, 500, 300, 35),
]

BAT_combinations = [
    (250, 40, 900, 400, 500, 200, 1000, 200, 300, 35),
    (250, 40, 900, 400, 500, 200, 1000, 350, 300, 35),
    (250, 40, 900, 400, 500, 200, 1000, 500, 300, 35),
]


runs = {}
runs["A"] = [
    STC_combinations[0],
    STC_combinations[1],
    HP_combinations[0],
    HP_combinations[1],
    HP_combinations[2],
]
runs["B"] = [
    PVT_combinations[0],
    PVT_combinations[1],
    HP_combinations[6],
    HP_combinations[7],
    HP_combinations[8],
]
runs["C"] = [
    BAT_combinations[0],
    BAT_combinations[1],
    HP_combinations[3],
    HP_combinations[5],
]
runs["D"] = [
    ELEC_combinations[0],
    ELEC_combinations[1],
    ELEC_combinations[2],
    ELEC_combinations[3],
]
runs["E"] = [
    ELEC_combinations[5],
    ELEC_combinations[6],
    ELEC_combinations[7],
    ELEC_combinations[8],
]


# Get all keys and their value lists from inv_sweep
keys = list(inv_sweep.keys())
values = [inv_sweep[key] for key in keys]
# Add economic_sweep to the sweep
keys += list(economic_sweep.keys())
values += [economic_sweep[key] for key in economic_sweep.keys()]


nBor = 6  # Starting number of boreholes
hasBat = True  # Starting value for hasBat
first_opt = True
# Iterate over all combinations
for combination in runs[run_identifier]:
    Borefield_ok = False
    while not Borefield_ok:
        Q_GSHP_max = (
            nBor * 0.2 * 4180 * 5 * 0.95 / 1e3
        )  # Maximum GSHP power based on nBor 0.2kg/s per borehole, 5K temp difference, 5% margin
        # Define directorries
        if first_opt:
            previous_optimization_dir = None
        else:
            previous_optimization_dir = optimization_dir

        current_base_model = model_name + f"_nBor{nBor}"
        current_model = model_name + f"_Run_{run_identifier}_nBor{nBor}"
        current_compiled_model_dir = Compiled_models_dir / current_model
        optimization_dir = current_compiled_model_dir / current_model
        current_input_data_dir = current_compiled_model_dir / "input_data"
        current_devices_json = current_input_data_dir / "devices.json"
        current_economic_params_json = current_input_data_dir / "economic_params.json"

        if (
            not current_compiled_model_dir.is_dir()
        ):  # check if the model witht the required nBor is already compiled
            print(f"Compiled model folder does not exist: {current_compiled_model_dir}")
            print(f"Creating and compiling model: {current_model}")
            create_directory(current_compiled_model_dir)

            # Copy the mop-file
            shutil.copy(
                MopFiles_dir / f"{current_base_model}.mop",
                current_compiled_model_dir / f"{current_model}.mop",
            )
            # Change the model name in the mop-file
            change_model_name_in_mop(
                current_compiled_model_dir / f"{current_model}.mop",
                current_base_model,
                current_model,
            )
            set_json_paths_in_mop(
                current_compiled_model_dir / f"{current_model}.mop",
                current_devices_json,
                current_economic_params_json,
            )
            if hasBat:
                change_hasBat_in_mop(
                    current_compiled_model_dir / f"{current_model}.mop", hasBat
                )

            # Copy the input_data folder
            shutil.copytree(
                pwd / "input_data",
                current_input_data_dir,
                symlinks=False,
                dirs_exist_ok=True,
            )

            # Compile the model
            run_command(
                f"taco {current_model} && make package", current_compiled_model_dir
            )

        case_name = (
            model_name
            + "_"
            + "_".join(f"{key}{val}" for key, val in zip(keys, combination))
        )

        # Create a new directory for the case
        case_dir = run_dir / case_name
        create_directory(case_dir)

        # Set the inv_cost values in devices.json
        raw_inv_values = {
            key: val for key, val in zip(keys, combination) if key in inv_sweep
        }

        # Rebuild with ASCHI inserted right after ASHP
        inv_values = {}
        for k, v in raw_inv_values.items():
            inv_values[k] = v
            if k == "ASHP":
                inv_values["ASCHI"] = v  # insert directly after ASHP
        change_inv_values_in_json(current_devices_json, inv_values)

        # Set the economic parameters in economic_params.json
        economic_params = {
            key: val for key, val in zip(keys, combination) if key in economic_sweep
        }
        change_economic_params_in_json(current_economic_params_json, economic_params)

        # Run optimization
        path_outputsAll = optimization_dir / "outputsAll.csv"
        path_OutputNames = optimization_dir / "OutputNames.txt"
        path_outputsAllMat = optimization_dir / "outputsAll.mat"
        # Copy the MPCState of previous opt if not first_opt and if the previous optimisation was in a different compilation folder
        if not first_opt and (previous_optimization_dir != optimization_dir):
            if (optimization_dir / "MPCState").exists():
                shutil.rmtree(optimization_dir / "MPCState")
            shutil.copytree(
                previous_optimization_dir / "MPCState", optimization_dir / "MPCState"
            )

        start_time = perf_counter()
        print(f"Running optimization for case: {case_name}")
        if WARM_START:
            run_command(
                "time ./test.sh -f -w -i10000 --acceptSolverMismatch | tee optimizationLog.txt",
                optimization_dir,
            )
        else:
            run_command(
                "time ./test.sh -f -i10000 --acceptSolverMismatch | tee optimizationLog.txt",
                optimization_dir,
            )
        end_time = perf_counter()
        optimization_time = end_time - start_time
        print(f"Optimization completed in {optimization_time:.2f} seconds.")
        first_opt = False

        # Read the result to check if borefield is not at limits
        df_result = read_ocp_result(path_outputsAll, path_OutputNames)
        borefield_depth = df_result["BorSize"].iloc[-1]
        GsHpSize = df_result["GsHpSize"].iloc[-1]
        if borefield_depth <= 55.0:
            if nBor > 2:
                nBor -= 2
                print(
                    f"Warning: Borefield depth is close to lower limit (depth - {borefield_depth} m). Decreasing the number of boreholes to {nBor}."
                )
                Borefield_ok = False
            else:
                print(
                    f"Warning: Borefield depth is close to lower limit (depth - {borefield_depth} m). Number of boreholes is already at minimum."
                )
                Borefield_ok = True
        elif borefield_depth >= 295.0 or GsHpSize >= Q_GSHP_max:
            if nBor < 10:
                nBor += 2
                print(
                    f"Warning: Borefield depth is close to upper limit (depth - {borefield_depth} m). Increasing the number of boreholes to {nBor}."
                )
                Borefield_ok = False
            else:
                print(
                    f"Warning: Borefield depth is close to upper limit (depth - {borefield_depth} m). Number of boreholes is already at maximum."
                )
                Borefield_ok = True
        else:
            Borefield_ok = True

        if Borefield_ok:
            # Copy results to case directory
            shutil.copy(path_outputsAll, case_dir / "outputsAll.csv")
            shutil.copy(path_outputsAllMat, case_dir / "outputsAll.mat")
            shutil.copy(path_OutputNames, case_dir / "OutputNames.txt")
            shutil.copy(
                optimization_dir / "optimizationLog.txt",
                case_dir / "optimizationLog.txt",
            )
