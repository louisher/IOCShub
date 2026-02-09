# fmt: off
import GHEtool as ghe
from borefield_modeling import Borefield
import json
import numpy as np



def set_general_parameters(devs: dict) -> dict:
    """
    Set and update general borefield parameters in the provided device configuration dictionary.
    This function reads borefield parameters from a JSON file specified in the input dictionary,
    computes derived parameters, and updates the dictionary with all necessary configuration
    values for borefield simulation and analysis.
    Parameters:
        devs (dict): 
            A nested dictionary containing device and borefield configuration. 
            Must include the following structure and keys:
                devs["Borefield"]["path_bor_params"]: str
                    Path to the JSON file containing borefield parameters.
                devs["Borefield"]["bor_params"]: dict
                    Dictionary to be updated with borefield parameters.
                devs["Borefield"]["min_depth"]: float
                    Minimum depth per borehole (m).
                devs["Borefield"]["max_depth"]: float
                    Maximum depth per borehole (m).
                devs["Borefield"]["life_time"]: int or float
                    Lifetime of the borefield (years).
    Returns:
        dict: 
            The updated device configuration dictionary with all borefield parameters set.
    Raises:
        FileNotFoundError: If the JSON parameter file does not exist.
        KeyError: If required keys are missing in the JSON or input dictionary.
        ValueError: If file contents or parameter values are invalid.
    Notes:
        - Requires the `json`, `numpy` (as np), and `ghetool` (as ghe) modules to be imported.
        - The function modifies the input dictionary in place and also returns it for convenience.
    """

    with open(devs["Borefield"]["path_bor_params"], 'r') as file:
        bor_params_json = json.load(file)  # Load JSON data into a dictionary

    # Configuration parameters
    devs["Borefield"]["bor_params"]["config_from_file"] = bor_params_json["config_from_file"] # Boolean, if True, the borefield configuration is read from a file
    devs["Borefield"]["bor_params"]["conf_file_path"] = bor_params_json["conf_file_path"] # Path to the borefield configuration file
    devs["Borefield"]["bor_params"]["N_1"] = bor_params_json["N_1"] # Number of boreholes in the first direction
    devs["Borefield"]["bor_params"]["N_2"] = bor_params_json["N_2"] # Number of boreholes in the second direction
    if devs["Borefield"]["bor_params"]["config_from_file"]:
        devs["Borefield"]["bor_params"]["nBor"] = len(np.loadtxt(devs["Borefield"]["bor_params"]["conf_file_path"], comments="#"))
    else:
        devs["Borefield"]["bor_params"]["nBor"] = devs["Borefield"]["bor_params"]["N_1"]*devs["Borefield"]["bor_params"]["N_2"]
    
    devs["Borefield"]["bor_params"]["B"] = bor_params_json["B"] # m, distance between boreholes
    devs["Borefield"]["bor_params"]["D"] = bor_params_json["D"] # m, buried depth of the boreholes
    devs["Borefield"]["bor_params"]["r_b"] = bor_params_json["r_b"] # m, radius of the boreholes

    devs["Borefield"]["min_cap"] = devs["Borefield"]["min_depth"] * devs["Borefield"]["bor_params"]["nBor"] # m, minimum total borefield length
    devs["Borefield"]["max_cap"] = devs["Borefield"]["max_depth"] * devs["Borefield"]["bor_params"]["nBor"] # m, maximum total borefield length

    # Fluid Temperature parameters
    devs["Borefield"]["bor_params"]["T_cte"] = bor_params_json["T_cte"] # °C, constant temperature of the ground
    devs["Borefield"]["bor_params"]["Tf_min"] = bor_params_json["Tf_min"] # °C, minimum fluid temperature
    devs["Borefield"]["bor_params"]["Tf_max"] = bor_params_json["Tf_max"] # °C, maximum fluid temperature
    # Ground Thermal properties
    devs["Borefield"]["bor_params"]["cp_ground"] = bor_params_json["cp_ground"] # J/kg/K, specific heat capacity of the ground
    devs["Borefield"]["bor_params"]["rho_ground"] = bor_params_json["rho_ground"] # kg/m3, density of the ground
    devs["Borefield"]["bor_params"]["k_ground"] = bor_params_json["k_ground"] # W/m/K, thermal conductivity of the ground
    devs["Borefield"]["bor_params"]["volumetric_heat_capacity_ground"] = devs["Borefield"]["bor_params"]["cp_ground"] * devs["Borefield"]["bor_params"]["rho_ground"] # J/m3/K, volumetric heat capacity of the ground
    devs["Borefield"]["bor_params"]["alpha_ground"] = devs["Borefield"]["bor_params"]["k_ground"]/(devs["Borefield"]["bor_params"]["rho_ground"]*devs["Borefield"]["bor_params"]["cp_ground"]) # m2/s, thermal diffusivity of the ground

    # Peak durations
    devs["Borefield"]["bor_params"]["peak_duration_ext"] = bor_params_json["peak_duration_ext"] # s, peak duration of extraction of the borefield
    devs["Borefield"]["bor_params"]["peak_duration_inj"] = bor_params_json["peak_duration_inj"] # s, peak duration of injection of the borefield

    # Load aggregation parameters
    devs["Borefield"]["bor_params"]["mBorFie"] = 0.2*devs["Borefield"]["bor_params"]["nBor"] # kg/s, mass flow rate of the borefield
    devs["Borefield"]["bor_params"]["timFin"] = devs["Borefield"]['life_time']*365*24*3600 # s, final time of the g-function calculation
    devs["Borefield"]["bor_params"]["tBorStep"] = 3600*730 # s, Total Time of one borefield time step in seconds
    devs["Borefield"]["bor_params"]["nbSteps"] = 12*devs["Borefield"]["life_time"] # Total number of borefield steps over lifetime

    # GHEtool parameters
    devs["Borefield"]["bor_params"]["ground_data"] = ghe.GroundConstantTemperature(k_s=devs["Borefield"]["bor_params"]["k_ground"], T_g=devs["Borefield"]["bor_params"]["T_cte"], volumetric_heat_capacity= devs["Borefield"]["bor_params"]["volumetric_heat_capacity_ground"])
    devs["Borefield"]["bor_params"]["pipe_data"] = ghe.DoubleUTube(k_g=2, r_in=0.0131, r_out=0.016, k_p=0.38, D_s=0.043)
    devs["Borefield"]["bor_params"]["fluid_data"] = ghe.FluidData(mfr=devs["Borefield"]["bor_params"]["mBorFie"]/devs["Borefield"]["bor_params"]["nBor"], k_f=0.598, rho=995.586, Cp=4184, mu=1e-3)

    return devs


def set_calculation_parameters(devs: dict) -> dict:
    """
    Sets and calculates borefield parameters to use within optimization.
    This function updates the input dictionary `devs` with calculated borefield parameters,
    including aggregation weighting factors and fluid temperature correction factors for a range
    of borehole depths. It performs the following steps:
        - Initializes a Borefield object and sets ground, fluid, and pipe parameters.
        - Defines a range of borehole depths for linearisation.
        - For each depth, calculates aggregation weighting factors for monthly and peak (extraction/injection) scenarios.
        - Computes monthly and peak fluid temperature correction factors for each depth.
        - Updates the `devs` dictionary with the calculated values.
    Args:
        devs (dict): 
            Dictionary containing borefield and parameter data. Must include the following keys:
                - "Borefield": {
                    "bor_params": {
                        "ground_data", "fluid_data", "pipe_data",
                        "min_depth", "max_depth", "nbSteps", "tBorStep",
                        "time_gfunc", "Tstep_gfunc", "peak_duration_ext", "peak_duration_inj",
                        "D", "r_b", "k_ground", "nBor"
                    }
                }
    Returns:
        dict: The updated `devs` dictionary with additional calculated borefield parameters:
            - "H_range_linearisation": np.ndarray of borehole depths
            - "kappas": dict of aggregation weighting factors per depth
            - "kappa_peak_ext": dict of peak extraction weighting factors per depth
            - "kappa_peak_inj": dict of peak injection weighting factors per depth
            - "Tf_corr_monthly": np.ndarray of monthly fluid temperature correction factors
            - "Tf_corr_peak_ext": np.ndarray of peak extraction fluid temperature correction factors
            - "Tf_corr_peak_inj": np.ndarray of peak injection fluid temperature correction factors
    """

    borfie = ghe.Borefield()
    borfie.set_ground_parameters(devs["Borefield"]["bor_params"]["ground_data"])
    borfie.set_fluid_parameters(devs["Borefield"]["bor_params"]["fluid_data"])
    borfie.set_pipe_parameters(devs["Borefield"]["bor_params"]["pipe_data"])
    
    H_step = 5
    H_range_linearisation = np.arange(devs["Borefield"]["min_depth"], devs["Borefield"]["max_depth"] + H_step, H_step) # m, range of borehole depths for linearisation
    devs["Borefield"]["bor_params"]["H_range_linearisation"] = H_range_linearisation

    ## Calculate the acutal kapppa values for the borefield for each depth in H_ragne
    devs["Borefield"]["bor_params"]["kappas"] = dict() # Aggregation weighting factors
    devs["Borefield"]["bor_params"]["kappa_peak_ext"] = dict() # Peak extraction weighting factor
    devs["Borefield"]["bor_params"]["kappa_peak_inj"] = dict() # Peak injection weighting factor

    # Calculate the aggregation weighting factors for different depths
    for H in H_range_linearisation:
        devs["Borefield"]["bor_params"]["H"] = H # m, depth of the boreholes
        # Create borefield object
        bf = Borefield(devs["Borefield"]["bor_params"])
        # Calculate the g-function
        bf.calculate_g_function()
        timSer = np.column_stack(
                    (devs["Borefield"]["bor_params"]["time_gfunc"], devs["Borefield"]["bor_params"]["Tstep_gfunc"])
                )
        rCel = np.ones(devs["Borefield"]["bor_params"]["nbSteps"]) * devs["Borefield"]["bor_params"]["tBorStep"]
        nu = np.cumsum(rCel)
        devs["Borefield"]["bor_params"]["kappas"][H] = bf.aggregationWeightingFactors(
                    i=devs["Borefield"]["bor_params"]["nbSteps"],
                    nTimTot=len(timSer),
                    TStep=timSer,
                    nu=nu,
                )
        
        peak_duration_ext = devs["Borefield"]["bor_params"]["peak_duration_ext"]
        peak_duration_inj = devs["Borefield"]["bor_params"]["peak_duration_inj"]
        nu_peak_ext = np.array([peak_duration_ext*3600])
        nu_peak_inj = np.array([peak_duration_inj*3600])
        devs["Borefield"]["bor_params"]["kappa_peak_ext"][H] = bf.aggregationWeightingFactors(
                        i=1, nTimTot=len(timSer), TStep=timSer, nu=nu_peak_ext)
        devs["Borefield"]["bor_params"]["kappa_peak_inj"][H] = bf.aggregationWeightingFactors(
                        i=1, nTimTot=len(timSer), TStep=timSer, nu=nu_peak_inj)
        

    # Monthly fluid temperature correction factors
    Tf_corr_monthly = np.zeros(len(H_range_linearisation))
    Tf_corr_peak_ext = np.zeros(len(H_range_linearisation))
    Tf_corr_peak_inj = np.zeros(len(H_range_linearisation))
    for i, H in enumerate(H_range_linearisation):
        Rb = borfie.borehole.get_Rb(H=H, D=devs["Borefield"]["bor_params"]["D"], r_b=devs["Borefield"]["bor_params"]["r_b"], k_s=devs["Borefield"]["bor_params"]["k_ground"])
        Tf_corr_monthly[i] = Rb/(devs["Borefield"]["bor_params"]["nBor"]*H)
        Tf_corr_peak_ext[i] = devs["Borefield"]["bor_params"]["kappa_peak_ext"][H][0] + Rb/(devs["Borefield"]["bor_params"]["nBor"]*H)
        Tf_corr_peak_inj[i] = devs["Borefield"]["bor_params"]["kappa_peak_inj"][H][0] + Rb/(devs["Borefield"]["bor_params"]["nBor"]*H)

    devs["Borefield"]["bor_params"]["Tf_corr_monthly"] = Tf_corr_monthly
    devs["Borefield"]["bor_params"]["Tf_corr_peak_ext"] = Tf_corr_peak_ext
    devs["Borefield"]["bor_params"]["Tf_corr_peak_inj"] = Tf_corr_peak_inj

    return devs


def write_N_1_N_2_to_json(
    devs: dict,
    N_1: int,
    N_2: int
) -> None:
    """
    Update the borefield parameters JSON file with new values for N_1 and N_2.

    Args:
        devs (dict): Configuration dictionary containing the path to the borefield parameters JSON file
                     under devs["Borefield"]["path_bor_params"].
        N_1 (int): Value to set for the "N_1" key in the JSON file.
        N_2 (int): Value to set for the "N_2" key in the JSON file.

    Returns:
        None
    """
    path = devs["Borefield"]["path_bor_params"]
    with open(path, 'r') as file:
        bor_params_json = json.load(file)

    bor_params_json["N_1"] = N_1
    bor_params_json["N_2"] = N_2

    with open(path, 'w') as file:
        json.dump(bor_params_json, file, indent=4)

def determine_peak_durations(
    ext_load: np.ndarray, 
    inj_load: np.ndarray
) -> tuple[int, int]:
    """
    Determine the peak durations (in consecutive time steps) for extraction and injection loads.
    The peak duration is defined as the longest consecutive period where the load is at least 70% of its maximum value.

    Args:
        ext_load (np.ndarray): Array of extraction load values.
        inj_load (np.ndarray): Array of injection load values.

    Returns:
        tuple[int, int]: Peak durations for extraction and injection loads, respectively (in time steps).
    """
    peak_ext = np.max(ext_load)
    peak_inj = np.max(inj_load)
    threshold_ext = 0.8*peak_ext
    threshold_inj = 0.8*peak_inj
    print("Peak injection: ", peak_inj, "Peak extraction: ", peak_ext)
    print("Threshold injection: ", threshold_inj, "Threshold extraction: ", threshold_ext)

    # Find the indices where the load exceeds the threshold
    peak_locations_ext = np.where(ext_load >= threshold_ext, True, False)
    peak_locations_inj = np.where(inj_load >= threshold_inj, True, False)

    # Determine the maximum amount of consecutive True values in peak_locations
    peak_duration_ext = 0
    peak_duration_inj = 0
    current_count_ext = 0
    current_count_inj = 0

    for value in peak_locations_ext:
        if value:
            current_count_ext += 1
            peak_duration_ext = max(peak_duration_ext, current_count_ext)
        else:
            current_count_ext = 0
    
    for value in peak_locations_inj:
        if value:
            current_count_inj += 1
            peak_duration_inj = max(peak_duration_inj, current_count_inj)
        else:
            current_count_inj = 0

    return peak_duration_ext, peak_duration_inj


def write_peak_durations_to_json(
    devs: dict,
    peak_duration_ext: float,
    peak_duration_inj: float
) -> None:
    """
    Updates the borefield parameters JSON file with new peak duration values.
    Args:
        devs (dict): A dictionary containing device configuration, including the path to the borefield parameters JSON file under `devs["Borefield"]["path_bor_params"]`.
        peak_duration_ext (float): The new peak duration value for extraction to be written to the JSON file.
        peak_duration_inj (float): The new peak duration value for injection to be written to the JSON file.
    Returns:
        None
    """
    with open(devs["Borefield"]["path_bor_params"], 'r') as file:
        bor_params_json = json.load(file)

    bor_params_json["peak_duration_ext"] = peak_duration_ext
    bor_params_json["peak_duration_inj"] = peak_duration_inj

    with open(devs["Borefield"]["path_bor_params"], 'w') as file:
        json.dump(bor_params_json, file, indent=4)

    return None



def size_borefield(
    devs: dict,
    ext_load: list[float],
    inj_load: list[float]
) -> float:
    """
    Sizes a geothermal borefield based on device parameters and hourly load profiles.
    This function initializes a borefield object, sets its ground, fluid, and pipe parameters,
    creates a rectangular borefield layout, sets temperature bounds, and assigns hourly extraction
    and injection load profiles. It then calculates the required borefield length using the specified
    sizing method.
    Args:
        devs (dict): Dictionary containing borefield and parameter data, including ground, fluid,
            and pipe parameters, borefield layout, temperature bounds, and simulation period.
        ext_load (list[float]): Hourly extraction load profile (heat extraction from the ground) for the simulation period.
        inj_load (list[float]): Hourly injection load profile (heat injection into the ground) for the simulation period.
    Returns:
        float: The calculated borefield length required to meet the specified load and temperature constraints.
    """
    
    # initiate borefield
    borefield = ghe.Borefield()

    # set ground data in borefield
    borefield.set_ground_parameters(devs["Borefield"]["bor_params"]["ground_data"])
    borefield.set_fluid_parameters(devs["Borefield"]["bor_params"]["fluid_data"])
    borefield.set_pipe_parameters(devs["Borefield"]["bor_params"]["pipe_data"])

    borefield.create_rectangular_borefield(N_1=devs["Borefield"]["bor_params"]["N_1"], N_2=devs["Borefield"]["bor_params"]["N_2"], B_1=devs["Borefield"]["bor_params"]["B"], B_2=devs["Borefield"]["bor_params"]["B"], \
                                                H=100, D=devs["Borefield"]["bor_params"]["D"], r_b=devs["Borefield"]["bor_params"]["r_b"])

    # set temperature bounds
    borefield.set_max_avg_fluid_temperature(devs["Borefield"]["bor_params"]["Tf_max"])
    borefield.set_min_avg_fluid_temperature(devs["Borefield"]["bor_params"]["Tf_min"])

    
    # load the hourly profile
    borefield.simulation_period = devs["Borefield"]["life_time"]
    load = ghe.HourlyGeothermalLoad(simulation_period=devs["Borefield"]["life_time"])

    load.hourly_extraction_load = ext_load
    load.hourly_injection_load = inj_load
    load.peak_extraction_duration = devs["Borefield"]["bor_params"]["peak_duration_ext"]  # hours
    load.peak_injection_duration = devs["Borefield"]["bor_params"]["peak_duration_inj"]  # hours

    borefield.load = load
    load.all_months_equal = True

    ## options without short-term effects
    options = {"disp": False, "profiles": True, "method": "equivalent"}
    ## set options
    borefield.set_options_gfunction_calculation(options)

    L = borefield.size(L3_sizing=True)

    return L

def find_closest_valid_factor_pair(n):
    """Find the closest factor pair (a, b) of n where |a - b| is minimized 
       and (max(a, b) / min(a, b)) is at most 10."""
    if n <= 0:
        raise ValueError("Only positive integers are allowed.")

    closest_pair = None
    min_difference = float('inf')

    # Iterate only up to sqrt(n) for efficiency
    for i in range(1, int(n**0.5) + 1):
        if n % i == 0:  # Check if 'i' is a factor
            a, b = i, n // i  # Get the factor pair
            ratio = max(a, b) / min(a, b)  # Calculate the ratio
            
            if ratio <= 10:  # Check if ratio condition is met
                diff = abs(a - b)  # Compute the absolute difference
                
                if diff < min_difference:
                    min_difference = diff
                    closest_pair = (a, b)  # Store the best pair

    return closest_pair

def find_next_N_1_N_2(N_1: int, N_2: int) -> tuple[int, int, int]:
    """
    Finds the next optimal pair of factors (N_1, N_2) for a given product N_1 * N_2.
    This function iteratively reduces the product of N_1 and N_2 (nBor) and finds the closest valid factor pair
    using the `find_closest_valid_factor_pair` function. The reduction continues until a valid factor pair is found.
    Args:
        N_1 (int): The initial value of the first factor.
        N_2 (int): The initial value of the second factor.
    Returns:
        tuple: A tuple containing the optimal values of N_1 and N_2, and the final value of nBor.
    """

    nBor: int = N_1 * N_2
    optimal_N_1: int = N_1
    optimal_N_2: int = N_2
    succes: bool = True
    while succes:
        if nBor > 10:
            nBor -= int(nBor/10)
        else:
            nBor -= 1
        print("nBor: ", nBor)

        pair: tuple[int, int] | None = find_closest_valid_factor_pair(nBor)
        if pair is not None:
            optimal_N_1, optimal_N_2 = pair
            succes = False
        else:
            succes = True
    return optimal_N_1, optimal_N_2, nBor

def determine_nBor(
    devs: dict,
    param: dict,
    ext_load: np.ndarray,
    inj_load: np.ndarray
) -> bool:
    """
    Determines the optimal number of boreholes in a borefield to ensure the borehole depth (L) 
    falls within specified minimum and maximum limits. The function iteratively adjusts the 
    borefield configuration, updating the number of boreholes in two directions, and writes 
    these values to a JSON file. If the borefield size is too small to meet the minimum depth 
    requirement, the function returns False.
    Parameters:
        devs (dict): Device or configuration object containing borefield parameters.
        param (dict): Additional parameters required for borefield calculations.
        ext_load (np.ndarray): External load applied to the borefield.
        inj_load (np.ndarray): Injection load applied to the borefield.
    Returns:
        bool: True if a suitable borefield size is found within the specified limits, 
              False if the minimum size cannot be achieved.
    """

    N_1: int = 5  # Initial number of boreholes in the first direction
    N_2: int = 5  # Initial number of boreholes in the second direction
    write_N_1_N_2_to_json(devs, N_1, N_2)
    devs = set_general_parameters(devs)  
    L: float = size_borefield(devs, ext_load, inj_load)

    # Check if the borefield size is within the limits
    min_L: float = 125
    max_L: float = 225
    size_found: bool = True
    while L < min_L or L > max_L:
        N_1, N_2, nBor = find_next_N_1_N_2(N_1, N_2)
        write_N_1_N_2_to_json(devs, N_1, N_2)
        devs = set_general_parameters(devs)
        L = size_borefield(devs, ext_load, inj_load)
        print("L: ", L)
        if nBor == 2 and L < min_L:
            print("Minimum borefield size reached")
            if L < 25:  # if the size with 2 boreholes is smaller than 25m, the size is too small
                size_found = False
            break
    if size_found:
        print(f"Resulting borefield size: {N_1}X{N_2} -- Length: {L}")
    return size_found

def increase_nBor(N_1, N_2):
    if N_1 <= N_2:
        N_1 += 1
    else:
        N_2 += 1
    return N_1, N_2
