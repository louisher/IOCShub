# -*- coding: utf-8 -*-


from pathlib import Path
import numpy as np
import math
import clustering_medoid as clustering
import time
import os
import csv
import solar_modeling
import json
from scipy.stats import linregress
import GHEtool as ghe
from borefield_modeling import Borefield
from matplotlib import pyplot as plt
import json
import borefield_params
import pandas as pd


def load_params():
    """
    Load and initialize all parameters, device specifications, weather data, and demand profiles for the energy system optimization.
    This function performs the following operations:
    1. Sets up file paths for input data and profiles
    2. Loads general physical parameters (water properties, roof area constraints)
    3. Loads economic parameters from JSON (interest rate, observation time, electricity prices)
    4. Loads and processes weather data (temperature, irradiance, wind speed)
    5. Loads and processes energy demand profiles (heating, cooling, electricity)
    6. Calculates solar yield for PV, solar thermal collectors, and PVT systems
    7. Loads device technical specifications and economic parameters
    8. Configures thermal energy storage parameters based on volume and temperature delta
    9. Initializes borefield parameters and determines optimal configuration if enabled
    10. Calculates annual investments and reference scenario
    11. Processes monthly demand data for post-processing
    Returns
    -------
    param : dict
        Dictionary containing general parameters including:
        - Physical constants (c_w, rho_w)
        - Roof area constraints
        - Weather data (T_air, GHI, DHI, wind_speed) reshaped as (365, 24)
        - Performance coefficients (cop_gshp, cop_ashp, eer_aschi) reshaped as (365, 24)
        - Peak demands for heat, cool, and power
        - Economic parameters (prices, rates, observation time)
        - Energy supply and feed-in parameters
        - CO2 emission factors
        - Reference scenario parameters
    devs : dict
        Dictionary containing device specifications for each technology including:
        - Investment costs (inv_cost, inv_var)
        - Technical parameters (efficiencies, COP, EER)
        - Operational parameters (life_time, cost_om)
        - Capacity constraints (min_cap, max_cap)
        - Storage-specific parameters (sto_loss, soc_init, delta_T)
        - Solar system parameters (norm_power, specific_heat)
        - Borefield configuration (if enabled)
    dem : dict
        Dictionary containing demand profiles reshaped as (365, 24) arrays:
        - 'heat': Heating demand in kW
        - 'cool': Cooling demand in kW
        - 'power': Electricity demand in kW
    result_dict : dict
        Dictionary containing processed results and intermediate calculations:
        - Monthly demand aggregations
        - Reference scenario results (if calculated)
    Raises
    ------
    FileNotFoundError
        If economic_params.json, weather file, or other required input files are missing.
    Notes
    -----
    - All energy values are converted to kW/kWh units
    - Weather data is expected in a tab-separated format with specific column structure
    - Device parameters can be partially loaded from devices.json
    - Borefield initialization may disable the system if load is too small
    - The function generates several matplotlib figures for visualization:
      * Demand profiles
      * COP/EER comparison
      * Solar yield profiles
    """

    result_dict = {}

    param = {}
    param_uncl = {}  # unclustered time series for weather data

    pwd = Path.cwd()
    path_input_data = pwd / "input_data"
    path_input_profiles = path_input_data / "Profiles"
    print("Path to input data: ", path_input_data)
    print("Path to input profiles: ", path_input_profiles)

    days = range(365)
    time_steps = range(24)

    ################################################################
    # GENERAL PARAMETERS

    param["c_w"] = 4.18  # kJ/(kgK)
    param["rho_w"] = 1000  # kg/m3
    param["limited_roof_area"] = False
    param["available_roof_area"] = 200  # m2

    ################################################################
    # LOAD ECONOMIC PARAMETERS

    path_economic_params = path_input_data / "economic_params.json"
    if not path_economic_params.exists():
        raise FileNotFoundError(
            f"Economic parameters file {path_economic_params} does not exist. Please check the path and file name."
        )
    with open(path_economic_params, "r") as file:
        economic_constants = json.load(file)
    INTEREST_RATE = economic_constants["INTEREST_RATE"]
    OBSERVATION_TIME = economic_constants["OBSERVATION_TIME"]
    ELEC_PRICE_OFFTAKE = economic_constants["ELEC_PRICE_OFFTAKE"]
    ELEC_PRICE_INJECTION = economic_constants["ELEC_PRICE_INJECTION"]

    ################################################################
    # LOAD WEATHER DATA

    # fmt: off
    ## Load the other weather parameters from json-file
    path_weather_params = path_input_data / "weather_params.json"
    with open(path_weather_params, "r") as file:
        weather_params = json.load(file)

    latitude = weather_params["latitude"]
    longitude = weather_params["longitude"]
    timezone = weather_params["timezone"]
    altitude = weather_params["altitude"]

    weather_file = path_input_data / "WeatherFiles" / weather_params["weather_file_name"]
    if not weather_file.exists():
        raise FileNotFoundError(
            f"Weather file {weather_file} does not exist. Please check the path and file name."
        )

    column_names = ["Time","DryBulbTemperature","DewPointTemperature", "RelativeHumidity","Pressure","ExtraterrestrialHorizontalRadiation","ExtraterrestrialDirectNormalRadiation",
        "HorizontalInfraredRadiation","GlobalHorizontalIrradiance","DirectNormalRadiation","DiffuseHorizontalRadiation","AveragedGlobalHorizontalIlluminance","DirectNormalIlluminance",
        "DiffuseHorizontalIlluminance","ZenithLuminance","WindDirection","WindSpeed","TotalSkyCover","OpaqueSkyCover","Visibility","CeilingHeight","PresentWeatherObservation",
        "PresentWeatherCodes","PrecipitableWater","AerosolOpticalDepth","SnowDepth","DaysSinceLastSnowfall","Albedo","LiquidPrecipitationDepth","LiquidPrecipitationQuantity",
    ]
    # fmt: on
    df_weather = pd.read_csv(
        weather_file,
        comment="#",
        skiprows=2,
        sep="\t",
        names=column_names,
        header=None,
        usecols=range(len(column_names)),
    )
    T_air = df_weather["DryBulbTemperature"].to_numpy()
    GHI = df_weather["GlobalHorizontalIrradiance"].to_numpy()
    DHI = df_weather["DiffuseHorizontalRadiation"].to_numpy()
    wind_speed = df_weather["WindSpeed"].to_numpy()

    param_uncl["T_air"] = T_air
    param_uncl["GHI"] = GHI
    param_uncl["DHI"] = DHI
    param_uncl["wind_speed"] = wind_speed
    param_uncl["cop_gshp"] = np.loadtxt(path_input_profiles / "COP_GSHP.txt")
    param_uncl["cop_ashp"] = np.loadtxt(path_input_profiles / "COP_ASHP.txt")
    param_uncl["eer_aschi"] = np.loadtxt(path_input_profiles / "EER_ASCHI.txt")

    ################################################################
    # LOAD DEMANDS

    dem_uncl = {}

    dem_uncl["heat"] = np.loadtxt(path_input_profiles / "heating_demand.txt")
    dem_uncl["cool"] = np.loadtxt(path_input_profiles / "cooling_demand.txt")
    dem_uncl["power"] = np.loadtxt(path_input_profiles / "electricity_demand.txt")

    for k in ["heat", "cool", "power"]:
        param["peak_" + k] = np.max(dem_uncl[k])

    ################################################################
    # DESIGN DAY CLUSTERING

    dem = {}
    dem["heat"] = dem_uncl["heat"].reshape((365, 24))
    dem["cool"] = dem_uncl["cool"].reshape((365, 24))
    dem["power"] = dem_uncl["power"].reshape((365, 24))
    param["T_air"] = param_uncl["T_air"].reshape((365, 24))
    param["GHI"] = param_uncl["GHI"].reshape((365, 24))
    param["DHI"] = param_uncl["DHI"].reshape((365, 24))
    param["wind_speed"] = param_uncl["wind_speed"].reshape((365, 24))
    param["cop_gshp"] = param_uncl["cop_gshp"].reshape((365, 24))
    param["cop_ashp"] = param_uncl["cop_ashp"].reshape((365, 24))
    param["eer_aschi"] = param_uncl["eer_aschi"].reshape((365, 24))

    plt.figure("Demand profiles")
    plt.plot(dem_uncl["heat"], label="Heat demand")
    plt.plot(dem_uncl["cool"], label="Cool demand")
    plt.plot(dem_uncl["power"], label="Power demand")
    plt.legend(), plt.grid()
    plt.show()

    # plot to check COP and EER profiles
    cop_gshp_array = np.zeros(8760)
    cop_ashp_array = np.zeros(8760)
    eer_aschi_array = np.zeros(8760)
    for d in days:
        for t in time_steps:
            cop_gshp_array[24 * d + t] = param["cop_gshp"][d][t]
            cop_ashp_array[24 * d + t] = param["cop_ashp"][d][t]
            eer_aschi_array[24 * d + t] = param["eer_aschi"][d][t]

    plt.figure("COP comparison")
    plt.plot(cop_gshp_array, label="GSHP COP")
    plt.plot(cop_ashp_array, label="ASHP COP")
    plt.plot(eer_aschi_array, label="ASCHI EER")
    plt.legend(), plt.grid()

    # SOLAR YIELD CALCULATION
    solar_yield = solar_modeling.solar_yield(
        latitude=latitude,
        longitude=longitude,
        timezone=timezone,
        altitude=altitude,
        azimuth=0,
        elevation=35,
        df_weather=df_weather,
        collector_type="flat_plate",
        pvt_type="dual_sun",
        T_m_stc=35 * np.ones(8760),
        T_m_pvt=25 * np.ones(8760),
    )
    #
    solar_yield_dict = {}
    solar_yield_dict["pv_power"] = {}
    solar_yield_dict["collector_heat"] = {}
    solar_yield_dict["pvt_power"] = {}
    solar_yield_dict["pvt_heat"] = {}

    for d in days:
        solar_yield_dict["pv_power"][d] = {}
        solar_yield_dict["collector_heat"][d] = {}
        solar_yield_dict["pvt_power"][d] = {}
        solar_yield_dict["pvt_heat"][d] = {}
        for t in time_steps:
            solar_yield_dict["pv_power"][d][t] = (
                solar_yield["pv_power"][24 * d + t] / 1e3
            )
            solar_yield_dict["collector_heat"][d][t] = (
                solar_yield["collector_heat"][24 * d + t] / 1e3
            )
            solar_yield_dict["pvt_power"][d][t] = (
                solar_yield["pvt_power"][24 * d + t] / 1e3
            )
            solar_yield_dict["pvt_heat"][d][t] = (
                solar_yield["pvt_heat"][24 * d + t] / 1e3
            )
    print("Total pv yield per year per m2: ", np.sum(solar_yield["pv_power"]) / 1e3)

    plt.figure("Solar yield")
    plt.plot(solar_yield["pv_power"], label="PV power")
    plt.plot(solar_yield["collector_heat"], label="Collector heat")
    plt.plot(solar_yield["pvt_power"], label="PVT power")
    plt.plot(solar_yield["pvt_heat"], label="PVT heat")
    plt.legend(), plt.grid()
    plt.show()

    ################################################################
    # LOAD MODEL PARAMETERS

    ### Energy costs ###
    # Electricity costs
    param["enable_supply_el"] = True
    param["price_supply_el"] = ELEC_PRICE_OFFTAKE / 1e3  # €/kWh

    param["price_cap_el"] = 0  # kEUR/MW
    param["enable_feed_in_el"] = True
    param["revenue_feed_in_el"] = ELEC_PRICE_INJECTION / 1e3  # €/kWh

    param["enable_cap_limit_el"] = False
    param["cap_limit_el"] = 1000  # kW

    param["enable_supply_limit_el"] = False
    param["supply_limit_el"] = 100000  # kWh/a

    # Natural gas
    param["enable_supply_gas"] = True
    param["price_supply_gas"] = 0.05  # €/kWh
    param["price_cap_gas"] = 0
    param["enable_feed_in_gas"] = False
    param["revenue_feed_in_gas"] = 0.01

    param["enable_cap_limit_gas"] = False
    param["cap_limit_gas"] = 100  # kW
    param["enable_supply_limit_gas"] = False
    param["supply_limit_gas"] = 100000  # kWh/a

    ### Ecological impact ###
    param["co2_tax"] = 180 / 1000  # EUR/kg
    param["co2_el_grid"] = 0.4  # kg/kWh
    param["co2_el_feed_in"] = 0.3  # kg/kWh
    param["co2_gas"] = 0.2  # kg/kWh
    param["co2_gas_feed_in"] = 0.2  # kg/kWh

    ### General ###
    param["optim_focus"] = 0  # 0: cost minimization, 1: emission minimization
    param["interest_rate"] = INTEREST_RATE
    param["observation_time"] = OBSERVATION_TIME  # in years
    param["peak_dem_met_conv"] = (
        False  # If true, peak demands have to be met without renewables
    )

    ### Reference scenario ###
    param["ref"] = {}
    param["ref"]["enable_hp"] = True
    param["ref"]["cop_hp"] = 5
    param["ref"]["cop_cc"] = 5
    param["ref"]["enable_chp"] = False

    ################################################################
    # LOAD TECHNICAL PARAMETERS

    devs = {}

    ### Natural gas ###

    # CHP
    devs["CHP"] = {
        "feasible": False,
        "inv_cost": 1000,
        "eta_el": 0.35,
        "eta_th": 0.5,
        "life_time": 20,
        "cost_om": 0.08,
        "min_cap": 0,
        "max_cap": 10000,  # kW_el
    }

    ### Heating and cooling ###

    # Absorption chiller
    devs["AC"] = {
        "feasible": False,
        "inv_cost": 750,
        "eta_th": 0.6,
        "life_time": 20,
        "cost_om": 0.05,
        "min_cap": 0,
        "max_cap": 10000,  # kW_th
    }

    # Gas storage
    devs["GS"] = {
        "feasible": False,
        "inv_cost": 150,  # EUR/kWh
        "life_time": 20,
        "cost_om": 0.01,
        "min_cap": 0,  # kWh
        "max_cap": 10000,  # kWh
        "sto_loss": 0,  # 1/h,              standby losses over one time step
        "soc_init": 0.5,  # ---,              maximum initial state of charge
    }

    ## Load the other device parameters from json-file
    with open(path_input_data / "devices.json", "r") as file:
        devs_params = json.load(file)
    # Add the devices from the json-file to the devices dictionary
    devs.update(devs_params)

    for dev in devs:
        devs[dev]["inv_var"] = devs[dev][
            "inv_cost"
        ]  # Set the investment costs variables, for all variables, the storage values will be overwritten later on

    # Photovoltaics
    devs["PV"]["norm_power"] = solar_yield_dict["pv_power"]

    # Solar thermal collector
    devs["STC"]["specific_heat"] = solar_yield_dict["collector_heat"]

    # Photovoltaic thermal collector
    devs["PVT"]["norm_power"] = solar_yield_dict["pvt_power"]
    devs["PVT"]["specific_heat"] = solar_yield_dict["pvt_heat"]

    # Gas boiler
    # Ground Source Heat pump
    devs["GSHP"]["COP"] = param["cop_gshp"]

    # Air Source Heat pump
    devs["ASHP"]["COP"] = param["cop_ashp"]

    # Air source compression chiller
    devs["ASCHI"]["EER"] = param["eer_aschi"]

    ### Storages ###
    # fmt: off
    # Heat thermal energy storage
    deltaT = devs["TES"]["delta_T"]
    devs["TES"]["inv_var"] = devs["TES"]["inv_cost"] / (param["rho_w"] * param["c_w"] * deltaT / 3600) # Calculate investment costs per kWh
    devs["TES"]["min_cap"] = devs["TES"]["min_vol"] * param["rho_w"] * param["c_w"] * deltaT / 3600 # Calculate minimum capacity in kWh
    devs["TES"]["max_cap"] = devs["TES"]["max_vol"] * param["rho_w"] * param["c_w"] * deltaT / 3600 # Calculate maximum capacity in kWh

    # Cold thermal energy storage
    deltaT = devs["CTES"]["delta_T"]
    devs["CTES"]["inv_var"] = devs["CTES"]["inv_cost"] / (param["rho_w"] * param["c_w"] * deltaT / 3600) # Calculate investment costs per kWh
    devs["CTES"]["min_cap"] = devs["CTES"]["min_vol"] * param["rho_w"] * param["c_w"] * deltaT / 3600 # Calculate minimum capacity in kWh
    devs["CTES"]["max_cap"] = devs["CTES"]["max_vol"] * param["rho_w"] * param["c_w"] * deltaT / 3600 # Calculate maximum capacity in kWh

    # Borefield
    devs["Borefield"]["min_cap"] = 0 # m, will be set later after number of boreholes is known
    devs["Borefield"]["max_cap"] = 0 # m, will be set later after number of boreholes is known
    devs["Borefield"]["path_bor_params"] = path_input_data / "bor_params.json"

    ## Set the borefield parameters
    devs["Borefield"]["bor_params"] = {}
    # Load the borefield load from profiles:
    init_inj = np.loadtxt(path_input_profiles / "initial_borefield_inj.txt")
    init_ext = np.loadtxt(path_input_profiles / "initial_borefield_ext.txt")
    # Determine the peak durations of the borefield load:
    peak_duration_ext, peak_duration_inj = borefield_params.determine_peak_durations(ext_load = init_ext, inj_load = init_inj)
    print("Peak duration injection of borefield: ", peak_duration_inj)
    print("Peak duration extraction of borefield: ", peak_duration_ext)
    borefield_params.write_peak_durations_to_json(devs=devs, peak_duration_ext=peak_duration_ext, peak_duration_inj=peak_duration_inj)
    # Set the general parameters for the borefield:
    devs = borefield_params.set_general_parameters(devs)
    if devs["Borefield"]["feasible"]:
        if devs["Borefield"]["intialize_length"]:
            devs["Borefield"]["intialize_lengthh"] = False
            # Determine the starting borefield configuration
            Borefield_possible = borefield_params.determine_nBor(devs, param, init_inj, init_ext)  # This function outputs false if the borefield load is to small
            if Borefield_possible:
                devs = borefield_params.set_calculation_parameters(devs)
            else:
                devs["Borefield"]["feasible"] = False # Capacity of GSHP will be automatically zero in the model due to constraints
                print("The borefield load is too small, borefield is removed from size optimization, an ASHP and Compression Chiller (CC) will be used instead")
                devs["ASHP"]["feasible"] = True
                devs["ASCHI"]["feasible"] = True
        else:
            devs = borefield_params.set_calculation_parameters(devs)

    # fmt: on

    ################################################################
    # INITIALIZE CALCULATION

    # Calculate annual investments
    devs, param = calc_annual_investment(devs, param)

    # Calculate reference scenario
    # result_dict = calc_reference(devs, dem, param, dem_uncl, result_dict)

    # print("=== PARAMETER ===")
    # print(param)
    # print("=== TECHNOLOGIES ===")
    # print(devs)

    # Calculate values for post-processing
    result_dict = calc_monthly_dem(dem_uncl, param_uncl, result_dict)

    return param, devs, dem, result_dict


# %% SUB-FUNCTIONS ##################################################


def calc_annual_investment(devs, param):
    """
    Calculation of total investment costs including replacements (based on VDI 2067-1, pages 16-17).

    Parameters
    ----------
    dev : dictionary
        technology parameter
    param : dictionary
        economic parameters

    Returns
    -------
    annualized fix and variable investment
    """

    observation_time = param["observation_time"]
    interest_rate = param["interest_rate"]
    q = 1 + param["interest_rate"]

    # Calculate capital recovery factor
    CRF = ((q**observation_time) * interest_rate) / ((q**observation_time) - 1)

    # Calculate annuity factor for each device
    for device in devs.keys():

        # Get device life time
        life_time = devs[device]["life_time"]

        # Number of required replacements
        n = int(math.floor(observation_time / life_time))

        # Investment for replacements
        invest_replacements = sum((q ** (-i * life_time)) for i in range(1, n + 1))

        # Residual value of final replacement
        res_value = (
            ((n + 1) * life_time - observation_time)
            / life_time
            * (q ** (-observation_time))
        )

        # Calculate annualized investments
        if life_time > observation_time:
            devs[device]["ann_factor"] = (1 - res_value) * CRF
        else:
            devs[device]["ann_factor"] = (1 + invest_replacements - res_value) * CRF

    # Save capital recovery factor
    param["CRF"] = CRF

    return devs, param


def calc_monthly_dem(dem_uncl, param_uncl, result_dict):

    month_tuple = (
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
    )
    days_sum = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]

    monthly_dem = {}
    year_peak = {}
    year_sum = {}
    for m in ["heat", "cool", "power"]:
        monthly_dem[m] = {}
        year_peak[m] = int(np.max(dem_uncl[m]))
        year_sum[m] = int(np.sum(dem_uncl[m]) / 1000)
        for month in range(12):
            monthly_dem[m][month_tuple[month]] = (
                sum(
                    dem_uncl[m][t]
                    for t in range(days_sum[month] * 24, days_sum[month + 1] * 24)
                )
                / 1000
            )

    result_dict["monthly_dem"] = monthly_dem
    result_dict["year_peak"] = year_peak
    result_dict["year_sum"] = year_sum

    # monthly_val = {}
    # year_peak = {}
    # year_sum = {}
    # for m in ["T_air", "GHI"]:  # "wind_speed"]:
    #    monthly_val[m] = {}
    #    year_peak[m] = int(np.max(param_uncl[m]))
    #    year_sum[m] = int(np.sum(param_uncl[m]) / 1000)
    #    for month in range(12):
    #        monthly_val[m][month_tuple[month]] = sum(param_uncl[m][t] for t in range(days_sum[month]*24, #days_sum[month+1]*24)) / 1000

    # result_dict["monthly_val"] = monthly_val

    return result_dict
