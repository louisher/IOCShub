import numpy as np
import pandas as pd
from scipy.interpolate import RegularGridInterpolator


class eff:

    def __init__(self, eff_table_path):
        self.eff_table_path = eff_table_path

    def read_table(self, table_path):
        df = pd.read_csv(table_path, header=0, comment="#")

        Tsource = df["Tsource"].dropna().to_numpy()
        Tsink = df["Tsink"].dropna().to_numpy()
        eff = (
            df["eff"].dropna().to_numpy().reshape(len(Tsink), len(Tsource))
        )  # COP or EER values

        TABLE = {"Tsource": Tsource, "Tsink": Tsink, "eff": eff}

        return TABLE

    def create_interpolator(self, TABLE):
        interp_func = RegularGridInterpolator(
            (TABLE["Tsink"], TABLE["Tsource"]),
            TABLE["eff"],
            bounds_error=False,  # Allow out-of-bounds
            fill_value=None,
        )  # Enable extrapolation using nearest value

        return interp_func

    def get_eff(self, Tsink, Tsource):
        TABLE = self.read_table(self.eff_table_path)
        interp_func = self.create_interpolator(TABLE)

        values = np.array([[Tsink, Tsource]])  # Ensure a 2D array with shape (1, 2)
        eff_value = interp_func(values)[0]  # Interpolate or extrapolate the value

        # Clamp the output COP value between the defined minimum and maximum
        eff_min = 1
        eff_max = 15
        eff_value_clamped = np.clip(eff_value, eff_min, eff_max)
        return eff_value_clamped
