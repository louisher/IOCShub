import pandas as pd
import numpy as np
import os
import sys
from matplotlib import pyplot as plt
from scipy.optimize import minimize

module_path = r"C:\Workdir\Develop\IOCS"
if module_path not in sys.path:
    sys.path.append(module_path)
import eff_tables
from pathlib import Path

colors = ["red", "blue", "green", "orange", "purple", "black"]
# fmt: off


ASHP_table_path = Path(r"C:\Workdir\Develop\IOCS\Datasheets\HPs\COPTable_VitoCal200A.csv")
GSHP_table_path = Path(r"C:\Workdir\Develop\IOCS\Datasheets\HPs\COPTable_VitoCal300G_BWS_A21.csv")	
CHI_table_path = Path(r"C:\Workdir\Develop\IOCS\Datasheets\HPs\EERTable_Galetti_MPE013H0AA.csv")

cop_gshp = eff_tables.eff(eff_table_path=GSHP_table_path)
cop_ashp = eff_tables.eff(eff_table_path=ASHP_table_path)
eer_chi = eff_tables.eff(eff_table_path=CHI_table_path)

def linear_regression_nom(params, x1, x2, actual, nom):  # simple linear regression where the nominal value is given
    a, b = params
    pred = a * x1 + b * x2 + nom
    cost = np.sum((pred - actual) ** 2)
    return cost

def calibration(cop_dict, Tsink_nominal, Tsource_nominal, eff_nominal):
    # This function determines the coefficients a and b for the linear regression model
    # The model is given by: COP = a * (Tsink - Tsink_nominal) + b * (Tsource - Tsource_nominal) + eff_nominal


    # Specify the initial guess for the parameters a and b
    intial_guess = [0.1, 0.1]

    # Get the necessary values
    actual_COP = cop_dict["eff"].flatten() # Flatten the COP values
    x_Tsink = np.repeat(cop_dict["Tsink"] - Tsink_nominal, len(cop_dict["Tsource"])) # a list of Tsink values, the repeat is necessary to match the length of the actual COP values
    x_Tsource = np.tile(cop_dict["Tsource"] - Tsource_nominal, len(cop_dict["Tsink"])) # a list of Tsource values, the tile is necessary to match the length of the actual COP values

    # Perform the minimization to find the best fit parameters
    result = minimize(linear_regression_nom, intial_guess, args=(x_Tsink, x_Tsource, actual_COP, eff_nominal), method="BFGS")

    coef_Tsink, coef_Tsource = result.x

    return coef_Tsink, coef_Tsource

## ASHP calibration
cop_dict_ashp = cop_ashp.read_table(ASHP_table_path)
Tsink_nominal = 40
Tsource_nominal = 7
COP_nominal = cop_ashp.get_eff(Tsink=Tsink_nominal, Tsource=Tsource_nominal)

coefCon_ashp, coefEva_ashp = calibration(cop_dict_ashp, Tsink_nominal, Tsource_nominal, COP_nominal)

print(f"COP_ASHP = {COP_nominal} + {coefCon_ashp} * (Tsink - {Tsink_nominal}) + {coefEva_ashp} * (Tsource - {Tsource_nominal})")

plt.figure("COP_ASHP - Calibration")
for i, Tsink in enumerate(cop_dict_ashp["Tsink"]):
    plt.plot(cop_dict_ashp["Tsource"], cop_dict_ashp["eff"][i],label=f"Tsink = {Tsink}",color=colors[i])
    plt.plot(cop_dict_ashp["Tsource"], COP_nominal + coefCon_ashp * (Tsink - Tsink_nominal) + coefEva_ashp * (cop_dict_ashp["Tsource"] - Tsource_nominal), color=colors[i], linestyle="--")
plt.xlabel("Tsource")
plt.ylabel("COP")
plt.legend()
plt.grid()



## GSHP calibration
cop_dict_gshp = cop_gshp.read_table(GSHP_table_path)
Tsink_nominal = 40
Tsource_nominal = 7
COP_nominal = cop_gshp.get_eff(Tsink=Tsink_nominal, Tsource=Tsource_nominal)

coefCon_gshp, coefEva_gshp = calibration(cop_dict_gshp, Tsink_nominal, Tsource_nominal, COP_nominal)

print(f"COP_GSHP = {COP_nominal} + {coefCon_gshp} * (Tsink - {Tsink_nominal}) + {coefEva_gshp} * (Tsource - {Tsource_nominal})")

plt.figure("COP_GSHP - Calibration")
for i, Tsink in enumerate(cop_dict_gshp["Tsink"]):
    plt.plot(cop_dict_gshp["Tsource"], cop_dict_gshp["eff"][i],label=f"Tsink = {Tsink}",color=colors[i])
    plt.plot(cop_dict_gshp["Tsource"], COP_nominal + coefCon_gshp * (Tsink - Tsink_nominal) + coefEva_gshp * (cop_dict_gshp["Tsource"] - Tsource_nominal), color=colors[i], linestyle="--")
plt.xlabel("Tsource")
plt.ylabel("COP")
plt.legend()
plt.grid()

## Chiller calibration
eer_chi_dict = eer_chi.read_table(CHI_table_path)
Tsink_nominal = 25
Tsource_nominal = 7
EER_nominal = eer_chi.get_eff(Tsink=Tsink_nominal, Tsource=Tsource_nominal)
coefCon_chi, coefEva_chi = calibration(eer_chi_dict, Tsink_nominal, Tsource_nominal, EER_nominal)

print(f"EER_CHI = {EER_nominal} + {coefCon_chi} * (Tsink - {Tsink_nominal}) + {coefEva_chi} * (Tsource - {Tsource_nominal})")
plt.figure("EER_CHI - Calibration")
for i, Tsink in enumerate(eer_chi_dict["Tsink"]):
    plt.plot(eer_chi_dict["Tsource"], eer_chi_dict["eff"][i], label=f"Tsink = {Tsink}", color=colors[i])
    plt.plot(eer_chi_dict["Tsource"], EER_nominal + coefCon_chi * (Tsink - Tsink_nominal) + coefEva_chi * (eer_chi_dict["Tsource"] - Tsource_nominal), color=colors[i], linestyle="--")
plt.xlabel("Tsource")
plt.ylabel("EER")
plt.legend()



plt.show()
