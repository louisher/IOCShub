from openpyxl import load_workbook
from openpyxl.utils import get_column_letter
import os
import math
import shutil
import pandas as pd
import datetime
import numpy as np
from time import perf_counter
import json
from tabulate import tabulate

import load_params
import optim_model
import borefield_params
import eff_tables


def copy_file(src: str, dst: str) -> None:
    """Copies a file from src to dst."""
    shutil.copy(src, dst)


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


def load_json_file_as_dict(path):
    """
    Loads a JSON file and returns its content as a dictionary.

    Args:
        path (str): Path to the JSON file.

    Returns:
        dict: The content of the JSON file as a dictionary.
    """
    with open(path, "r", encoding="utf-8") as file:
        data = json.load(file)

    return data


def change_weather_file_in_mop(path_mop_file, weather_file_name):
    """
    Updates the weather file name in a Modelica .mop file.
    This function searches for the line containing 'sim.filNam=' in the specified .mop file
    and replaces it with a new line that sets the weather file to the provided weather_file_name.
    The new weather file path is constructed using the Modelica resource loading convention.
    Args:
        path_mop_file (str): The file path to the .mop file to be modified.
        weather_file_name (str): The name of the new weather file to reference in the .mop file.
    Returns:
        None
    Side Effects:
        Modifies the specified .mop file in place, updating the weather file reference.
    """

    with open(path_mop_file, "r") as file:
        lines = file.readlines()
    for i, line in enumerate(lines):
        if "sim.filNam=" in line:
            lines[i] = (
                f'\t\t\t\t\t\t\t\t\tsim.filNam=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/weatherdata//{weather_file_name}"),\n'
            )
            break
    with open(path_mop_file, "w") as file:
        file.writelines(lines)


def set_size_parameters_in_mop(path_mop_file, devices_info):
    """
    Updates size parameter values in a MOP file based on the provided devices_info dictionary.
    Args:
        path_mop_file (str): The file path to the MOP file to be updated.
        devices_info (dict): A nested dictionary containing device names as keys. Each device contains a "size_parameters" dictionary,
            where each key is a size variable and its value is a dictionary with:
                - "name_in_mop" (str): The variable name as it appears in the MOP file.
                - "value" (any): The new value to set for the variable.
    The function reads the MOP file, searches for lines containing variable names specified in devices_info,
    and replaces those lines with updated values. The modified content is then written back to the file.
    """

    with open(path_mop_file, "r") as file:
        lines = file.readlines()
    for i, line in enumerate(lines):
        for device, device_info in devices_info.items():
            for size_variable, variable_info in device_info["size_parameters"].items():
                if variable_info["name_in_mop"] in line:
                    lines[i] = (
                        f"\t\t\t\t\t\t\t\t\t{variable_info['name_in_mop']}{variable_info['value']},\n"
                    )
    with open(path_mop_file, "w") as file:
        file.writelines(lines)


def update_computational_times(
    computational_times,
    write_inputs_time,
    load_params_time,
    size_optim_time,
    ocp_compilation_time,
    ocp_optimization_time,
    total_iteration_time,
):
    # Write the computational times to the dictionary
    computational_times["write_inputs_time"]["value"] = write_inputs_time
    computational_times["load_params_time"]["value"] = load_params_time
    computational_times["size_optim_time"]["value"] = size_optim_time
    computational_times["ocp_compilation_time"]["value"] = ocp_compilation_time
    computational_times["ocp_optimization_time"]["value"] = ocp_optimization_time
    computational_times["total_iteration_time"]["value"] = total_iteration_time

    return computational_times


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


def read_elec_use(df):
    elec_use = df["ElecUse"].to_numpy() / 1e3  # convert to kW
    elec_use_offtake = np.where(elec_use >= 0, elec_use, 0)
    elec_use_injection = np.where(elec_use < 0, -elec_use, 0)
    TotalOfftake = np.sum(elec_use_offtake) / 1e3  # convert to MWh
    TotalInjection = np.sum(elec_use_injection) / 1e3  # convert to MWh

    return TotalOfftake, TotalInjection


def read_discomfort(df):
    hea_discomfort = df["DiscmfHea"].to_numpy()
    coo_discomfort = df["DiscmfCoo"].to_numpy()
    TotHeaDiscmf = np.sum(hea_discomfort)  # Kh
    TotCooDiscmf = np.sum(coo_discomfort)  # Kh
    return TotHeaDiscmf, TotCooDiscmf


def read_oper_variables_from_results(iteration_directory, operational_variables):
    # Read the results
    # Discomfort in KH, electricity offtake and injection in MWh
    df = read_ocp_result(
        f"{iteration_directory}/outputsAll.csv",
        f"{iteration_directory}/OutputNames.txt",
    )
    (
        operational_variables["elec_offtake"]["value"],
        operational_variables["elec_injection"]["value"],
    ) = read_elec_use(df)
    (
        operational_variables["hea_discmf"]["value"],
        operational_variables["coo_discmf"]["value"],
    ) = read_discomfort(df)
    return operational_variables


def update_overview_sheet(
    path_overview_sheet,
    devices_info,
    operational_variables,
    capex,
    opex,
    maintCost,
    computational_times,
    iteration,
):
    wb = load_workbook(path_overview_sheet)
    sheet = wb["Overview"]

    first_iteration_column = 3  # C
    col_letter = get_column_letter(first_iteration_column + iteration)
    for device, device_info in devices_info.items():
        for variable, variable_info in device_info["size_parameters"].items():
            if (
                variable_info["excel_row"] == "X"
            ):  # These variables are not written to the overview sheet
                continue
            cell = col_letter + str(variable_info["excel_row"])
            sheet[cell] = variable_info["value"]
    for variable, value in operational_variables.items():
        cell = col_letter + str(operational_variables[variable]["excel_row"])
        sheet[cell] = operational_variables[variable]["value"]

    # Fill in capex and opex
    row_capex = 22
    cell = col_letter + str(row_capex)
    sheet[cell] = capex
    row_opex = 23
    cell = col_letter + str(row_opex)
    sheet[cell] = opex
    row_maintCost = 24
    cell = col_letter + str(row_maintCost)
    sheet[cell] = maintCost
    row_TCO = 25
    cell = col_letter + str(row_TCO)
    sheet[cell] = capex + opex + maintCost

    # write the computational times to the overview sheet
    for time_key, time_info in computational_times.items():
        row = time_info["excel_row"]
        cell = col_letter + str(row)
        sheet[cell] = time_info["value"]

    wb.save(path_overview_sheet)


def convert_numpy_to_list_sizing_result_dict(obj):
    """
    Recursively converts all numpy arrays in a dictionary (or list) to lists.

    Args:
        obj (dict, list, or other): The object to process.

    Returns:
        The processed object with numpy arrays converted to lists.
    """
    if isinstance(obj, dict):  # If the object is a dictionary
        return {
            key: convert_numpy_to_list_sizing_result_dict(value)
            for key, value in obj.items()
        }
    elif isinstance(obj, list):  # If the object is a list
        return [convert_numpy_to_list_sizing_result_dict(item) for item in obj]
    elif isinstance(obj, np.ndarray):  # If the object is a numpy array
        return obj.tolist()
    else:  # Return the object as-is for all other types
        return obj


def save_sizing_result_dict_to_json(result_dict, iteration_directory):
    """
    Saves a sizing result dictionary to a JSON file.

    Args:
        result_dict (dict): The sizing result dictionary to save.
        path (str): The path to save the JSON file.

    Returns:
        None
    """
    result_dict = convert_numpy_to_list_sizing_result_dict(result_dict)

    # Save results as a JSON file
    with open(iteration_directory / "sizing_result_dict.json", "w") as file:
        json.dump(result_dict, file, indent=4)


def save_devices_info_to_json(devices_info, iteration_directory):
    """
    Saves the devices_info dictionary to a JSON file.

    Args:
        devices_info (dict): The devices_info dictionary to save.
        iteration_directory (str): The directory where the JSON file will be saved.

    Returns:
        None
    """
    # Save devices_info as a JSON file
    with open(iteration_directory / "devices_info.json", "w") as file:
        json.dump(devices_info, file, indent=4)


def run_size_optim():

    # Load parameters
    start = perf_counter()
    param, devs, dem, result_dict = load_params.load_params()
    end = perf_counter()
    load_params_time = end - start

    # Run optimization
    start = perf_counter()

    Borefield_sizing_finished = False
    while not Borefield_sizing_finished:
        result_dict = optim_model.run_optim(devs, param, dem, result_dict)
        if result_dict["Borefield"]["cap"] == 0:
            Borefield_sizing_finished = True
        elif (
            result_dict["Borefield"]["nBor"] == 2
            and not result_dict["Borefield"]["Sized_to_max"]
        ):
            Borefield_sizing_finished = True
        elif (
            result_dict["Borefield"]["Sized_to_min"] == False
            and result_dict["Borefield"]["depth"] > 100
            and not result_dict["Borefield"]["Sized_to_max"]
        ):  # If we do not size to minimum a depth above 100m is preferred, the number of boreholes should be decreased if necessary
            Borefield_sizing_finished = True
        elif result_dict["Borefield"]["Sized_to_max"] == True:
            N_1 = devs["Borefield"]["bor_params"]["N_1"]
            N_2 = devs["Borefield"]["bor_params"]["N_2"]
            N_1, N_2 = borefield_params.increase_nBor(N_1, N_2)
            borefield_params.write_N_1_N_2_to_json(devs, N_1, N_2)
            devs = borefield_params.set_general_parameters(devs)
            devs = borefield_params.set_calculation_parameters(devs)
            print(
                f"Sized to maximum allowable borefield size: increasing nBor to {N_1*N_2} ({N_1}x{N_2})"
            )
        else:
            N_1 = devs["Borefield"]["bor_params"]["N_1"]
            N_2 = devs["Borefield"]["bor_params"]["N_2"]
            N_1, N_2, nBor = borefield_params.find_next_N_1_N_2(N_1, N_2)
            borefield_params.write_N_1_N_2_to_json(devs, N_1, N_2)
            devs = borefield_params.set_general_parameters(devs)
            devs = borefield_params.set_calculation_parameters(devs)
            print(
                f"Sized to minimum allowable borefield size: decrasing nBor to {N_1*N_2} ({N_1}x{N_2})"
            )
    end = perf_counter()

    size_optim_time = end - start
    print(f"Size optimization time: {size_optim_time} s")

    return result_dict, load_params_time, size_optim_time


def print_sizing_result_overview(result_dict):
    # General
    print("---------- General Results ----------")
    table = [
        ["tac", result_dict["tac"], "euro"],
        ["co2", result_dict["co2"], "tonCO2/year"],
        ["CAPEX initial", result_dict["CAPEX_initial"], "euro"],
        ["CAPEX annualized", result_dict["CAPEX_annual"], "euro/year"],
        ["OPEX yearly total", result_dict["OPEX_yearly"], "euro/year"],
        ["OPEX yearly energy and CO2", result_dict["OPEX_yearly_energy"], "euro/year"],
        ["OPEX yearly maintenance", result_dict["OPEX_yearly_maint"], "euro/year"],
        ["Electricity offtake", result_dict["from_el_grid_total"], "MWh/year"],
        ["Electricity injection", result_dict["to_el_grid_total"], "MWh/year"],
    ]

    print(tabulate(table, headers=["KPI", "Value", "Unit"], tablefmt="grid"))

    # Devices
    for dev in result_dict["installed_devices"]:
        print("---------- Results", dev, "----------")

        for key in result_dict[dev]:
            print(key, ": ", result_dict[dev][key])


def read_optimal_sizes(result_dict, devices_info):
    # fmt: off

    # !!!!!!!!!!!!!!!!!!!! if you change this function also check the function set_sizes_of_non_feasible_devices_to_zero
    for device, device_info in devices_info.items():
        if device in ["ASHP", "GSHP", "PV", "STC", "PVT", "ASCHI"]:
            if result_dict[device]["cap"] > 0.01:
                devices_info[device]["size_parameters"]["Size"]["value"] = result_dict[device]["cap"]
            else:
                devices_info[device]["size_parameters"]["Size"]["value"] = 0.01 # small value to avoid division by zero
        if device in ["Borefield"]:
            devices_info[device]["size_parameters"]["Size"]["value"] = result_dict[device]["cap"]
            devices_info[device]["size_parameters"]["TBorMin"]["value"] = result_dict[device]["Tf_min"] + 273.15 # K
            devices_info[device]["size_parameters"]["rCel"]["value"] = result_dict[device]["rCel"]
            devices_info[device]["size_parameters"]["kappa"]["value"] = result_dict[device]["kappa"]
            if result_dict[device]["cap"] == 0:
                devices_info[device]["size_parameters"]["depth"]["value"] = 1 # small value to avoid division by zero
                devices_info[device]["size_parameters"]["nBor"]["value"] = int(1)
            else:
                devices_info[device]["size_parameters"]["depth"]["value"] = result_dict[device]["depth"]
                devices_info[device]["size_parameters"]["nBor"]["value"] = int(result_dict[device]["nBor"])
            
        if device in ["TES", "CTES"]:
            if result_dict[device]["volume"] > 0.01:
                devices_info[device]["size_parameters"]["Size"]["value"] = result_dict[device]["volume"]
            else:
                devices_info[device]["size_parameters"]["Size"]["value"] = 0.01
        if device in ["BAT"]:
            if result_dict[device]["cap"] > 0.01:
                devices_info[device]["size_parameters"]["Size"]["value"] = result_dict[device]["cap"]
                devices_info[device]["size_parameters"]["hasBat"]["value"] = "true"
                devices_info[device]["size_parameters"]["PCha_max"]["value"] = result_dict[device]["cap"]/2 # Set the max charging power to half of the battery capacity
            else:
                devices_info[device]["size_parameters"]["Size"]["value"] = 0.01
                devices_info[device]["size_parameters"]["hasBat"]["value"] = "false"
                devices_info[device]["size_parameters"]["PCha_max"]["value"] = 0.01
    # fmt: on
    return devices_info


def set_sizes_of_non_feasible_devices_to_zero(devices_info):
    """
    Set the sizes of non-feasible devices to zero in the devices_info dictionary.
    Args:
        devices_info (dict): The dictionary containing device size variables.
    Returns:
        dict: The updated devices_info dictionary with non-feasible devices set to zero.
    """
    for device, device_info in devices_info.items():

        if not device_info["feasible"]:
            if device in ["ASHP", "GSHP", "PV", "STC", "PVT", "TES", "CTES", "ASCHI"]:
                devices_info[device]["size_parameters"]["Size"][
                    "value"
                ] = 0.01  # small value to avoid division by zero
            if device in ["Borefield"]:
                devices_info[device]["size_parameters"]["Size"]["value"] = 0
                devices_info[device]["size_parameters"]["depth"]["value"] = 1
                devices_info[device]["size_parameters"]["nBor"]["value"] = int(1)
            if device in ["BAT"]:
                devices_info[device]["size_parameters"]["Size"]["value"] = 0.01
                devices_info[device]["size_parameters"]["hasBat"]["value"] = "false"
                devices_info[device]["size_parameters"]["PCha_max"]["value"] = 0.01

    return devices_info


def write_input_profiles(path_results, path_input_data):
    start = perf_counter()
    # Read data
    path_outputsAll = path_results / "outputsAll.csv"
    path_OutputNames = path_results / "OutputNames.txt"
    df = read_ocp_result(path_outputsAll, path_OutputNames)

    # Load demand profiles
    QDem = (df["QDem"]) / 1e3  # convert to kW
    QDemHea = np.where(QDem >= 0, QDem, 0)
    QDemCoo = np.where(QDem < -0.01, -QDem, 0)
    ElecDem = df["PDem"].to_numpy() / 1e3  # convert to kW

    QBor = df["QBor"].to_numpy()
    inj = np.where(QBor > 0, QBor, 0) / 1e3  # convert to kW
    ext = np.where(QBor < 0, -QBor, 0) / 1e3  # convert to kW

    # Calculate COPs
    TSup = df["T_COP_Sup"].to_numpy()
    Tair = df["T_COP_Air"].to_numpy()
    TBor = df["T_COP_Bor"].to_numpy()
    ASHP_table_path = path_input_data / "COPTables" / "COPTable_VitoCal200A.csv"
    GSHP_table_path = path_input_data / "COPTables" / "COPTable_VitoCal300G_BWS_A21.csv"
    CHI_table_path = path_input_data / "COPTables" / "EERTable_Galetti_MPE013H0AA.csv"

    cop_gshp = eff_tables.eff(eff_table_path=GSHP_table_path)
    cop_ashp = eff_tables.eff(eff_table_path=ASHP_table_path)
    eer_chi = eff_tables.eff(eff_table_path=CHI_table_path)

    print("Calculating COPs and EERs...")
    COP_ASHP = np.zeros(len(TSup))
    COP_GSHP = np.zeros(len(TSup))
    EER_CHI = np.zeros(len(TSup))

    for i in range(len(TSup)):
        COP_ASHP[i] = cop_ashp.get_eff(Tsink=TSup[i], Tsource=Tair[i])
        COP_GSHP[i] = cop_gshp.get_eff(Tsink=TSup[i], Tsource=TBor[i])
        EER_CHI[i] = eer_chi.get_eff(Tsink=Tair[i], Tsource=TSup[i])
    print("COPs and EERs calculated!")

    path_input_profiles = path_input_data / "Profiles"
    np.savetxt(path_input_profiles / "heating_demand.txt", QDemHea, fmt="%.1f")
    np.savetxt(path_input_profiles / "cooling_demand.txt", QDemCoo, fmt="%.1f")
    np.savetxt(path_input_profiles / "electricity_demand.txt", ElecDem, fmt="%.1f")
    np.savetxt(path_input_profiles / "COP_ASHP.txt", COP_ASHP, fmt="%.1f")
    np.savetxt(path_input_profiles / "COP_GSHP.txt", COP_GSHP, fmt="%.1f")
    np.savetxt(path_input_profiles / "EER_ASCHI.txt", EER_CHI, fmt="%.1f")
    np.savetxt(path_input_profiles / "initial_borefield_ext.txt", ext, fmt="%.1f")
    np.savetxt(path_input_profiles / "initial_borefield_inj.txt", inj, fmt="%.1f")

    end = perf_counter()
    write_inputs_time = end - start
    print(f"Write input profiles time: {write_inputs_time} s")

    return write_inputs_time


def calculate_NPV_factor_inv_costs(interest_rate, life_time, observation_time):
    """
    Calculate the NPV factor for investment costs.

    Args:
        interest_rate: The interest rate.
        lifetime : The lifetime of the investment in years.
        observation_time: The observation time in years.

    Returns:
        float: The NPV factor.
    """
    q = 1 + interest_rate

    # Number of replacements
    n = int(math.floor(observation_time / life_time))
    # Investment for replacements
    invest_replacements = sum((q ** (-i * life_time)) for i in range(1, n + 1))
    # Residual value of final replacement
    res_value = (
        ((n + 1) * life_time - observation_time)
        / life_time
        * (q ** (-observation_time))
    )
    # NPV factor
    NPV_factor = 1 + invest_replacements - res_value

    return NPV_factor


def add_NPV_of_rel_inv_cost_to_devices_info(
    devices_info, interest_rate, observation_time
):
    """
    Adds the Net Present Value (NPV) of relative investment costs to each device in the devices_info dictionary.
    For each device, this function calculates the NPV factor for investment costs based on the given interest rate,
    device lifetime, and observation time. It then computes the NPV-adjusted investment cost per unit (including
    replacements and residual value) and adds it to the device's information under the key 'NPV_inv_cost'.
    Args:
        devices_info (dict): Dictionary containing device information. Each key is a device name, and each value is a
            dictionary with at least 'life_time' and 'inv_cost' keys.
        interest_rate (float): The interest rate used for NPV calculation (as a decimal, e.g., 0.05 for 5%).
        observation_time (int or float): The total observation period (in years).
    Returns:
        dict: The updated devices_info dictionary with the NPV-adjusted investment cost ('NPV_inv_cost') added for each device.
    Note:
        Requires the function 'calculate_NPV_factor_inv_costs' to be defined elsewhere.
    """

    # Calculate NPV investment costs per unit for each device, and use it to calculate total CAPEX
    for device, device_info in devices_info.items():
        NPV_factor = calculate_NPV_factor_inv_costs(
            interest_rate, device_info["life_time"], observation_time
        )
        # Calculate the investment cost per unit including replacements and residual value
        devices_info[device]["NPV_inv_cost"] = NPV_factor * device_info["inv_cost"]

    return devices_info


def calculate_capex(devices_info, interest_rate, observation_time):
    """
    Calculate the total capital expenditure (CAPEX) for all devices, accounting for the net present value (NPV) of investment costs
    over the observation period and device replacements.

    Args:
        devices_info (dict): Dictionary containing device information. Each device entry should include:
            - "life_time" (float): Lifetime of the device in years.
            - "inv_cost" (float): Investment cost per unit of the device.
            - "size_parameters" (dict): Dictionary containing:
                - "Size" (dict): Dictionary with:
                    - "value" (float): The size value of the device.
        interest_rate (float): Interest rate used for NPV calculation (as a decimal, e.g., 0.05 for 5%).
        observation_time (float): Total observation period in years.

    Returns:
        tuple:
            - capex (float): Total capital expenditure for all devices.
            - devices_info (dict): Updated devices_info dictionary with calculated NPV investment costs and CAPEX for each device.
    """

    capex = 0
    # Calculate NPV investment costs per unit for each device, and use it to calculate total CAPEX
    for device, device_info in devices_info.items():
        devices_info[device]["capex"] = (
            devices_info[device]["NPV_inv_cost"]
            * device_info["size_parameters"]["Size"]["value"]
        )
        capex += devices_info[device]["capex"]

    return capex, devices_info


def calculate_opex_and_maintCost(
    operational_variables,
    devices_info,
    interest_rate,
    observation_time,
    elec_price_offtake,
    elec_price_injection,
):
    # p_el --> €/MWh
    annuity_factor = (1 / interest_rate) * (
        1 - (1 / (1 + interest_rate) ** observation_time)
    )

    # Calculate OPEX
    opex = (
        operational_variables["elec_offtake"]["value"]
        * elec_price_offtake
        * annuity_factor
    )
    opex -= (
        operational_variables["elec_injection"]["value"]
        * elec_price_injection
        * annuity_factor
    )

    # Calculate maintCost
    maintCost = 0
    for device, device_info in devices_info.items():
        # Calculate the maintenance cost per unit
        devices_info[device]["maintCost"] = (
            device_info["cost_om"]
            * device_info["inv_cost"]
            * device_info["size_parameters"]["Size"]["value"]
        )
        # Calculate the total maintenance cost
        maintCost += devices_info[device]["maintCost"]

    # Convert yearly maintenance cost to total maintenance cost
    maintCost *= annuity_factor

    return opex, maintCost, devices_info


def calculate_maintCost(devices_info, interest_rate, observation_time):
    """
    Calculate the maintenance costs based on the provided size variables and observation time.
    Args:
        devices_info (dict): A dictionary containing information about each device. Each device entry should include:
            - "life_time" (float): The lifetime of the device.
            - "cost_om" (float): The operation and maintenance cost per unit of the device.
            - "size_parameters" (dict): A dictionary containing:
                - "Size" (dict): A dictionary containing:
                    - "value" (float): The size value of the device.
        observation_time (float): The observation time period over which the maintenance costs are calculated.
    Returns:
        float: The total maintenance costs.
    """

    maintCost = 0
    for device, device_info in devices_info.items():
        # Calculate the maintenance cost per unit
        devices_info[device]["maintCost"] = (
            device_info["cost_om"] * device_info["size_parameters"]["Size"]["value"]
        )
        # Calculate the total maintenance cost
        maintCost += devices_info[device]["maintCost"]

    return maintCost
