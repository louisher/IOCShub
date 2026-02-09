import os
import sys

# Add the directory of the script to the Python path while running the scrip
script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(script_dir)
import load_params
import optim_model
from matplotlib import pyplot as plt
from time import perf_counter
from tabulate import tabulate
import numpy as np
import json
import pandas as pd

######################################################################################################################
############### OPTIMIZATION  ########################################################################################
######################################################################################################################

# Load parameters
param, devs, dem, result_dict = load_params.load_params()

# Run optimization
start_optim = perf_counter()
result_dict = optim_model.run_optim(devs, param, dem, result_dict)
end_optim = perf_counter()
print("Optimization time: ", end_optim - start_optim)

result_dict["Optimization_time"] = end_optim - start_optim


######################################################################################################################
############ Print results ###########################################################################################
######################################################################################################################

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


######################################################################################################################
############### POST PROCESSING  ######################################################################################
######################################################################################################################


# Convert all numpy arrays in the result dict to lists:
def convert_numpy_to_list(obj):
    """
    Recursively converts all numpy arrays in a dictionary (or list) to lists.

    Args:
        obj (dict, list, or other): The object to process.

    Returns:
        The processed object with numpy arrays converted to lists.
    """
    if isinstance(obj, dict):  # If the object is a dictionary
        return {key: convert_numpy_to_list(value) for key, value in obj.items()}
    elif isinstance(obj, list):  # If the object is a list
        return [convert_numpy_to_list(item) for item in obj]
    elif isinstance(obj, np.ndarray):  # If the object is a numpy array
        return obj.tolist()
    else:  # Return the object as-is for all other types
        return obj


result_dict = convert_numpy_to_list(result_dict)

# Save results as a JSON file
with open("result_dict.json", "w") as file:
    json.dump(result_dict, file, indent=4)

## Save Excel file

# Export results to an Excel file
output_excel_path = "optimization_results.xlsx"
df_results = pd.DataFrame(table, columns=["KPI", "Value", "Unit"])


# Create a Pandas Excel writer using XlsxWriter as the engine.
with pd.ExcelWriter(output_excel_path, engine="xlsxwriter") as writer:
    df_results.to_excel(writer, sheet_name="Results", index=False)

    # Get the xlsxwriter workbook and worksheet objects.
    workbook = writer.book
    worksheet = writer.sheets["Results"]

    # Add some cell formats.
    format1 = workbook.add_format({"num_format": "#,##0.00"})
    format2 = workbook.add_format({"bold": True, "font_color": "blue"})

    # Set the column width and format.
    worksheet.set_column("A:A", 20, format2)
    worksheet.set_column("B:B", 15, format1)
    worksheet.set_column("C:C", 15)

    # Add a header format.
    header_format = workbook.add_format(
        {
            "bold": True,
            "text_wrap": True,
            "valign": "top",
            "fg_color": "#D7E4BC",
            "border": 1,
        }
    )

    # Write the column headers with the defined format.
    for col_num, value in enumerate(df_results.columns.values):
        worksheet.write(0, col_num, value, header_format)

    for dev in result_dict["installed_devices"]:
        # Convert dictionary to DataFrame
        df_device = pd.DataFrame(index=range(8760))
        for key in result_dict[dev]:
            if isinstance(result_dict[dev][key], (list, np.ndarray)):
                if len(result_dict[dev][key]) == 8760:
                    array = result_dict[dev][key]
                else:
                    array = np.full(8760, np.nan)
                    array[: len(result_dict[dev][key])] = result_dict[dev][key]
                df_device[key] = array
            else:  # Convert scalar to list
                df_device[key] = np.ones(8760) * result_dict[dev][key]
        print("df_device", df_device)
        # Reset index to avoid duplicates before applying 'explode'
        df_device.reset_index(drop=True, inplace=True)

        # Check each column and explode if it's a list/array
        for column in df_device.columns:
            if isinstance(df_device[column].iloc[0], (list, np.ndarray)):
                # Apply explode and align other columns by resetting index
                df_device[column] = df_device[column].explode().reset_index(drop=True)

        # Now, the dataframe is "exploded", write it to Excel
        df_device.to_excel(writer, sheet_name=dev, index=False)

        # Get the worksheet object for the current device
        worksheet_device = writer.sheets[dev]

        # Set the column width and format for the device sheet
        for col_num, col_name in enumerate(df_device.columns):
            max_len = (
                max(df_device[col_name].astype(str).map(len).max(), len(col_name)) + 2
            )
            worksheet_device.set_column(
                col_num, col_num, max_len, format1 if col_num > 0 else format2
            )

        # Write the column headers with the defined format for the device sheet
        for col_num, value in enumerate(df_device.columns.values):
            worksheet_device.write(0, col_num, value, header_format)
