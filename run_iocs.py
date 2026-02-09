"""
IOCS (Integrated Optimal Control and Sizing) Runner Script
This script performs iterative optimization of component sizes and operational control
for energy systems using TACO and Gurobi.
Author: Louis Hermans
Contact: Please contact Louis Hermans if you have any questions about this script.
Description:
    The script performs integrated optimal component sizing by iterating between:
    1. Operational optimization (OCP - Optimal Control Problem) using TACO
    2. Size optimization of system components using Gurobi
    The process continues until convergence (relative difference < 1%) or maximum
    iterations (4) are reached.
Main Features:
    - Reads base model mop file
    - Creates iteration-specific directories
    - Manages TACO server connection for operational optimization
    - Performs size optimization for energy system components
    - Calculates CAPEX, OPEX, and maintenance costs
    - Tracks computational performance metrics
    - Exports results to Excel overview file
    - Supports custom run identifiers for parallel execution
Command Line Arguments:
    base_model_name (str): Name of the base MOP model file (required, no flag)
    --run_identifier (str): Optional identifier to distinguish different runs (default: "")
Key Variables:
    - devices_info: Dictionary containing device specifications, sizes, and costs
    - operational_variables: Dictionary of operational metrics (electricity offtake/injection, heating/cooling)
    - computational_times: Dictionary tracking execution times for each optimization phase
    - TACO_server: Configuration dictionary for remote TACO server connection
Required Files:
    - {base_model_name}.mop: Base model definition file
    - IterationOverviewTemplate.xlsx: Excel template for results
    - input_data/: Directory containing:
        * weather_params.json: Weather data configuration
        * economic_params.json: Economic parameters (interest rate, prices, etc.)
        * devices.json: Device specifications and feasibility
Output:
    Creates a model directory containing:
    - IterationOverview.xlsx: Consolidated results across iterations
    - Iteration{n}/ subdirectories with iteration-specific files
    - devices_info.json: Device configurations for each iteration
    - MOP files and optimization results
Notes:
    - DO NOT MODIFY CODE BELOW SETUP SECTION UNLESS YOU KNOW WHAT YOU ARE DOING
    - Requires SSH access to TACO server with proper credentials
    - Uses NPV (Net Present Value) calculations for economic analysis
"""

import os
import sys
from pathlib import Path
import json

# Load runtime configuration from external file (make this file user-specific)
# config files live in ./config_input_data next to run_iocs.py
config_dir = Path(__file__).parent / "config_input_data"
config_path = config_dir / "cosine_config.json"
if not config_path.exists():
    raise FileNotFoundError(
        f"Missing configuration file: {config_path}. Create it with at least the key 'path_iocs'."
    )
with config_path.open("r", encoding="utf-8") as _f:
    _cfg = json.load(_f)

path_iocs = _cfg.get("path_iocs")
if not path_iocs:
    raise KeyError(f"'path_iocs' not defined in {config_path}")
path_iocs = str(Path(path_iocs).expanduser())
if path_iocs not in sys.path:
    sys.path.append(path_iocs)
import shutil
from pathlib import Path
import load_params
import optim_model
import TACO_functions as tf
from matplotlib import pyplot as plt
from time import perf_counter

import argparse
from openpyxl import load_workbook
from openpyxl.utils import get_column_letter
import helper_functions as hf


# Read first argument without flag
parser = argparse.ArgumentParser(description="Script for iocs ")
parser.add_argument("base_model_name", help="Name of the base mop (no flag needed)")
parser.add_argument("--run_identifier", help="Run identifier (optional)", default="")
args = parser.parse_args()
base_model_name = args.base_model_name
run_identifier = args.run_identifier
model_name = base_model_name + run_identifier

### Load TACO server configuration
path_taco_config = config_dir / "taco_server.json"  # Load from config_input_data
TACO_server = hf.load_json_file_as_dict(path_taco_config)
# Format the path with user and model name
TACO_server["path_ocp_on_server"] = TACO_server["path_ocp_on_server"].format(
    user=TACO_server["user"],
    model_name=model_name
)


########################################################################################################
# DO NOT CHANGE ANYTHING IN THE CODE BELOW THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING !!!!!!!
########################################################################################################

print(
    "############################################################################################################"
)
print(f"Running IOCS for {model_name} using model {base_model_name}")
print(
    "############################################################################################################"
)

# Sizing variables, Here the intial values as the names in the MOP file and the excel row should be filled in
# If an X is placed in the excel_row, it means that the variable is not written in excel, but only in the MOP file.
# The variable Size is the size of the device that is used to calculate the CAPEX using the variable inv_cost

# Operational variables
operational_variables = {
    "elec_offtake": {"excel_row": 17},
    "elec_injection": {"excel_row": 18},
    "hea_discmf": {"excel_row": 19},
    "coo_discmf": {"excel_row": 20},
}

computational_times = {
    "write_inputs_time": {"value": 0, "excel_row": 29},
    "load_params_time": {"value": 0, "excel_row": 30},
    "size_optim_time": {"value": 0, "excel_row": 31},
    "ocp_compilation_time": {"value": 0, "excel_row": 32},
    "ocp_optimization_time": {"value": 0, "excel_row": 33},
    "total_iteration_time": {"value": 0, "excel_row": 34},
}


##########################################################################
##### SET UP #############################################################
##########################################################################

### Create and initialize a directory to store all results ###
pwd = Path.cwd()
model_directory = pwd / model_name
path_base_mop_file = pwd / f"{base_model_name}.mop"
path_mop_file = model_directory / f"{model_name}.mop"

# Delete directory if it exists
if model_directory.exists():
    if model_directory.is_dir():
        shutil.rmtree(model_directory)
    else:
        model_directory.unlink()
# Create the model directory
model_directory.mkdir(parents=True)

### Add the mop file to the model directory ###
shutil.copy(path_base_mop_file, path_mop_file)
hf.change_model_name_in_mop(
    path_mop_file=path_mop_file, old_name=base_model_name, new_name=model_name
)  # Replace the base model name in the MOP file

###  Add overview excel file and input_data folder to the model directory ###
shutil.copy(
    "IterationOverviewTemplate.xlsx", model_directory / "IterationOverview.xlsx"
)

path_input_data = model_directory / "input_data"
shutil.copytree(
    pwd / "input_data", path_input_data, symlinks=False, dirs_exist_ok=True
)  # Symlinks=False is needed to copy actual files, not symlinks, dirs_exist_ok=True allows to overwrite existing files

if not path_input_data.exists() or not path_input_data.is_dir():
    raise FileNotFoundError(f"Failed to create input_data folder at {path_input_data}")


### Read the weather data and change the weather file in the MOP file ###
path_weather_params = path_input_data / "weather_params.json"
weather_params = hf.load_json_file_as_dict(path_weather_params)
hf.change_weather_file_in_mop(
    path_mop_file=path_mop_file, weather_file_name=weather_params["weather_file_name"]
)

### Read the economical constants into a dictionary ###
path_economic_constants = path_input_data / "economic_params.json"
economic_constants = hf.load_json_file_as_dict(path_economic_constants)
INTEREST_RATE = economic_constants["INTEREST_RATE"]
OBSERVATION_TIME = economic_constants["OBSERVATION_TIME"]
ELEC_PRICE_OFFTAKE = economic_constants["ELEC_PRICE_OFFTAKE"]
ELEC_PRICE_INJECTION = economic_constants["ELEC_PRICE_INJECTION"]


### Create the devices_info dictionary from devices.json ###
path_devices_json = path_input_data / "devices.json"
devices_info = hf.load_json_file_as_dict(path_devices_json)
# Set the sizes of non-feasible devices to 0-equivalent
devices_info = hf.set_sizes_of_non_feasible_devices_to_zero(devices_info)
# Add NPV of rel inv cost to devices_info
devices_info = hf.add_NPV_of_rel_inv_cost_to_devices_info(
    devices_info, INTEREST_RATE, OBSERVATION_TIME
)

##########################################################################
##### OCP WITH INITIAL SIZES #############################################
##########################################################################
start_time_iteration = perf_counter()

# Create a subdirectory for the 0th iteration
iteration = 0
iteration_directory = model_directory / f"Iteration{iteration}"
iteration_directory.mkdir(parents=True, exist_ok=True)
# Define the mop file for the iteration
path_iteration_mop = iteration_directory / f"{model_name}.mop"
# Copy the initial mop file to the 0th iteration directory, make sure the
shutil.copy(path_mop_file, path_iteration_mop)

# Set the sizes in the iteration MOP file
hf.set_size_parameters_in_mop(path_iteration_mop, devices_info)
capex, devices_info = hf.calculate_capex(devices_info, INTEREST_RATE, OBSERVATION_TIME)
# Run the OCP
ocp_compilation_time, ocp_optimization_time = tf.run_operational_optimization(
    iteration_directory, path_iteration_mop, model_name, TACO_server
)

# Read the OCP results and write value in operational_variables dictionary
operational_variables = hf.read_oper_variables_from_results(
    iteration_directory, operational_variables
)
opex, maintCost, devices_info = hf.calculate_opex_and_maintCost(
    operational_variables,
    devices_info,
    INTEREST_RATE,
    OBSERVATION_TIME,
    ELEC_PRICE_OFFTAKE,
    ELEC_PRICE_INJECTION,
)

end_time_iteration = perf_counter()
total_iteration_time = end_time_iteration - start_time_iteration

# Update the computational times
load_params_time = 0  # Load parameters time is not needed in the first iteration
write_inputs_time = 0  # Write inputs time is not needed in the first iteration
size_optim_time = 0  # Size optimization time is not needed in the first iteration
computational_times = hf.update_computational_times(
    computational_times,
    write_inputs_time,
    load_params_time,
    size_optim_time,
    ocp_compilation_time,
    ocp_optimization_time,
    total_iteration_time,
)

# Write results in the overview sheet
hf.update_overview_sheet(
    model_directory / "IterationOverview.xlsx",
    devices_info,
    operational_variables,
    capex,
    opex,
    maintCost,
    computational_times,
    iteration,
)

# Save the devices_info to a JSON file in the iteration directory
hf.save_devices_info_to_json(devices_info, iteration_directory)


### Iterations
# Change working directory to the model directory
os.chdir(model_directory)

rel_dif = 1
TCO_current = capex + opex + maintCost
while iteration < 4 and rel_dif > 0.01:
    start_time_iteration = perf_counter()
    iteration += 1
    # Make the iteration directory
    previous_iteration_directory = model_directory / f"Iteration{iteration-1}"
    iteration_directory = model_directory / f"Iteration{iteration}"
    path_previous_iteration_mop = previous_iteration_directory / f"{model_name}.mop"
    path_iteration_mop = iteration_directory / f"{model_name}.mop"

    iteration_directory.mkdir(parents=True)

    ## Size optimization
    # Set the input data for the size optimization
    write_inputs_time = hf.write_input_profiles(
        path_results=previous_iteration_directory,
        path_input_data=path_input_data,
    )

    # Run the size optimization
    sizing_result_dict, load_params_time, size_optim_time = hf.run_size_optim()
    # Print the sizing results
    hf.print_sizing_result_overview(sizing_result_dict)
    # Save the sizing results in the iteration directory
    hf.save_sizing_result_dict_to_json(sizing_result_dict, iteration_directory)
    # Update the sizes in devices_info
    devices_info = hf.read_optimal_sizes(sizing_result_dict, devices_info)
    capex, devices_info = hf.calculate_capex(
        devices_info, INTEREST_RATE, OBSERVATION_TIME
    )
    ## Operational optimization
    # Copy the MOP file from the previous iteration to the current iteration
    shutil.copy(path_previous_iteration_mop, path_iteration_mop)

    # Set the sizes in the MOP file
    hf.set_size_parameters_in_mop(path_iteration_mop, devices_info)
    # Run the OCP
    ocp_compilation_time, ocp_optimization_time = tf.run_operational_optimization(
        iteration_directory, path_iteration_mop, model_name, TACO_server
    )
    # Read the OCP results and write value in operational_variables dictionary
    operational_variables = hf.read_oper_variables_from_results(
        iteration_directory, operational_variables
    )
    opex, maintCost, devices_info = hf.calculate_opex_and_maintCost(
        operational_variables,
        devices_info,
        INTEREST_RATE,
        OBSERVATION_TIME,
        ELEC_PRICE_OFFTAKE,
        ELEC_PRICE_INJECTION,
    )

    end_time_iteration = perf_counter()
    total_iteration_time = end_time_iteration - start_time_iteration
    # Update the computational times
    computational_times = hf.update_computational_times(
        computational_times,
        write_inputs_time,
        load_params_time,
        size_optim_time,
        ocp_compilation_time,
        ocp_optimization_time,
        total_iteration_time,
    )

    # Write results in the overview sheet
    hf.update_overview_sheet(
        model_directory / "IterationOverview.xlsx",
        devices_info,
        operational_variables,
        capex,
        opex,
        maintCost,
        computational_times,
        iteration,
    )

    # Save the devices_info to a JSON file in the iteration directory
    hf.save_devices_info_to_json(devices_info, iteration_directory)

    TCO_old = TCO_current
    TCO_current = capex + opex + maintCost
    rel_dif = abs((TCO_old - TCO_current) / TCO_old)


# # Load parameters
# param, devs, dem, result_dict = load_params.load_params()

# # Run optimization
# start_optim = perf_counter()
# result_dict = optim_model.run_optim(devs, param, dem, result_dict)
# end_optim = perf_counter()
# print("Optimization time: ", end_optim - start_optim)

# # Post processing
# # General
# print("---------- General Results ----------")
# table = [
#     ["tac", result_dict["tac"], "euro"],
#     ["co2", result_dict["co2"], "tonCO2/year"],
#     ["CAPEX initial", result_dict["CAPEX_initial"], "euro"],
#     ["CAPEX annualized", result_dict["CAPEX_annual"], "euro/year"],
#     ["OPEX yearly total", result_dict["OPEX_yearly"], "euro/year"],
#     ["OPEX yearly energy and CO2", result_dict["OPEX_yearly_energy"], "euro/year"],
#     ["OPEX yearly maintenance", result_dict["OPEX_yearly_maint"], "euro/year"],
#     ["Electricity offtake", result_dict["from_el_grid_total"], "MWh/year"],
#     ["Electricity injection", result_dict["to_el_grid_total"], "MWh/year"],
# ]

# print(tabulate(table, headers=["KPI", "Value", "Unit"], tablefmt="grid"))

# # Devices

# for dev in result_dict["installed_devices"]:
#     print("---------- Results", dev, "----------")

#     for key in result_dict[dev]:
#         print(key, ": ", result_dict[dev][key])
