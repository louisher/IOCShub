import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

path = "C:\Workdir\Develop\MasterThesissen\ThesisMaartje\\tinycluster\TinyCluster\Resources\OccupancyProfiles\\"

file_names = [
    "FTE_FTE",
    "FTE_FTE_School_School",
    "FTE_FTE_School_School_School",
    "FTE_PTE_School",
    "FTE_PTE_School_School",
    "Retired_Retired",
]


TSetDHW = 45
TCold = 10

for file_name in file_names:
    df = pd.read_csv(path + file_name + ".txt", sep=",", header=0, skiprows=2)

    # Average out DHW demand over 3 hours
    DHW_demand = (
        np.array(df[" Hot water demand [l/min]"]) * 15 * 4184 * (TSetDHW - TCold)
    )
    DHW_demand_3hourly = DHW_demand.reshape(-1, 12).sum(axis=1) * (1 / 3600) * (1 / 3)

    time_in_seconds = np.array([i * (3 * 3600) for i in range(len(DHW_demand_3hourly))])

    # Export to txt file
    export_path = "C:\Workdir\Develop\MasterThesissen\ThesisMaartje\MaartjeMod\Resources\BHP_profiles\\"
    export_name = export_path + file_name + "_BHP.txt"
    data_to_export = np.column_stack((time_in_seconds, DHW_demand_3hourly))
    np.savetxt(
        export_name,
        data_to_export,
        delimiter=";",
        header=f"#1\ndouble data({len(DHW_demand_3hourly)}, 2)",
        comments="",
        fmt=["%d", "%.1f"],
    )
