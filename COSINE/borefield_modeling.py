import numpy as np
import pygfunction as gt
import math
from scipy.interpolate import CubicHermiteSpline


class Borefield:
    def __init__(self, bor_params):
        self.bor_params = bor_params
        self.H = bor_params["H"]  # m, depth of the boreholes
        self.D = bor_params["D"]  # m, borehole buried depth
        self.B = bor_params["B"]  # m, borehole spacing
        self.r_b = bor_params["r_b"]  # m, borehole radius
        self.nBor = bor_params["nBor"]  # number of boreholes
        self.cp_ground = bor_params[
            "cp_ground"
        ]  # J/kgK, specific heat capacity of the ground
        self.rho_ground = bor_params["rho_ground"]  # kg/m3, density of the ground
        self.k_ground = bor_params[
            "k_ground"
        ]  # W/mK, thermal conductivity of the ground
        self.alpha_ground = self.k_ground / (
            self.rho_ground * self.cp_ground
        )  # m2/s, thermal diffusivity of the ground
        self.ts = self.H**2 / (
            9 * self.alpha_ground
        )  # s, characteristic time of the borefield

    def calculate_g_function(self):
        # Geometrically expanding time vector.
        dt = 1  # Time step
        tmax = self.bor_params["timFin"]  # Maximum time
        Nt = 75  # Number of time steps
        time_pyg = gt.utilities.time_geometric(dt, tmax, Nt)

        # g-Function calculation options
        # options = {
        #     "nSegments": 10,
        #     "disp": True,
        #     "segment_ratios": None,
        #     "profiles": True,
        #     "cylindrical_correction": True,
        # }  # Important: keep 'segment_ratios': None --> otherwise pygfunction does not equally divide segments

        options = {
            "nSegments": 12,
            "segment_ratios": None,
            "disp": False,
            "profiles": True,
            "method": "equivalent",
            "cylindrical_correction": True,
        }

        if self.bor_params["config_from_file"]:
            field = gt.boreholes.field_from_file(self.bor_params["conf_file_path"])
        else:
            field = gt.boreholes.rectangle_field(
                N_1=self.bor_params["N_1"],
                N_2=self.bor_params["N_2"],
                B_1=self.B,
                B_2=self.B,
                H=self.H,
                D=self.D,
                r_b=self.r_b,
            )
        # gt.boreholes.visualize_field(field)
        # plt.show()

        # -------------------------------------------------------------------------
        # Evaluate g-functions (only FLS)
        # -------------------------------------------------------------------------
        gfunc_detailed_cyl = gt.gfunction.gFunction(
            field,
            self.alpha_ground,
            time=time_pyg,
            options=options,
            method="equivalent",
        )
        print(gfunc_detailed_cyl)
        Tstep_pyg = gfunc_detailed_cyl.gFunc / (
            2 * np.pi * self.H * self.nBor * self.k_ground
        )

        time = time_pyg
        Tstep = Tstep_pyg

        self.bor_params["time_gfunc"] = time
        self.bor_params["Tstep_gfunc"] = Tstep
        self.bor_params["gfunc"] = gfunc_detailed_cyl.gFunc

        return None

    def countAggregationCells(
        self, lvlBas: float, nCel: int, timFin: float, tLoaAgg: float
    ) -> int:
        """
        Function which returns the number of aggregation cells in the aggregation vector.

        Args:
            lvlBas (float): Base for growth between each level, e.g. 2.
            nCel (int): Number of cells of same size per level (min=1).
            timFin (float): Total simulation max length (in seconds).
            tLoaAgg (float): Time resolution of load aggregation (in seconds).

        Returns:
            int: Size of aggregation vectors.
        """

        assert timFin > 0, "Total simulation time must be bigger than 0."

        width_i = 0
        nu_i = 0
        i = 0

        while nu_i < timFin:
            i += 1
            width_i = tLoaAgg * lvlBas ** math.floor((i - 1) / nCel)
            nu_i += width_i

        return i

    def aggregationCellTimes(
        self, i: int, lvlBas: float, nCel: int, tLoaAgg: float, timFin: float
    ):
        """
        Function which builds the time and cell width vectors for aggregation.

        Args:
            i (int): Size of time vector.
            lvlBas (float): Base for growth between each level, e.g. 2.
            nCel (int): Number of cells of same size per level.
            tLoaAgg (float): Time resolution of load aggregation (in seconds).
            timFin (float): Total simulation max length (in seconds).

        Returns:
            Tuple[np.ndarray, np.ndarray]:
                - nu: Time vector nu of size i.
                - rCel: Cell width vector of size i.
        """

        width_j = 0
        nu = np.zeros(i)
        rCel = np.zeros(i)

        for j in range(1, i + 1):
            width_j += tLoaAgg * lvlBas ** math.floor((j - 1) / nCel)
            nu[j - 1] = width_j
            rCel[j - 1] = lvlBas ** math.floor((j - 1) / nCel)

        if nu[i - 1] > timFin:
            nu[i - 1] = timFin
            if i > 1:
                rCel[i - 1] = (nu[i - 1] - nu[i - 2]) / tLoaAgg
            else:
                rCel[i - 1] = nu[i - 1] / tLoaAgg

        return nu, rCel

    def spline_derivatives(self, x, y):
        """
        Calculate the derivatives at the support points for cubic Hermite spline interpolation.

        Parameters:
        x (array-like): The x-coordinates of the support points.
        y (array-like): The y-coordinates of the support points.

        Returns:
        array-like: The derivatives at the support points.
        """
        n = len(x)
        d = np.zeros(n)
        for i in range(1, n - 1):
            dx1 = x[i] - x[i - 1]
            dx2 = x[i + 1] - x[i]
            dy1 = y[i] - y[i - 1]
            dy2 = y[i + 1] - y[i]
            d[i] = (dy1 / dx1 + dy2 / dx2) / 2
        d[0] = dy1 / dx1
        d[-1] = dy2 / dx2
        return d

    def cubic_hermite_linear_extrapolation(self, x, x1, x2, y1, y2, y1d, y2d):
        """Perform cubic Hermite spline interpolation or linear extrapolation."""
        spline = CubicHermiteSpline([x1, x2], [y1, y2], [y1d, y2d])
        return spline(x)

    def aggregationWeightingFactors(self, i, nTimTot, TStep, nu):
        """
        Calculates the kappa vector for load aggregation.

        Parameters:
            i (int): Size of aggregation vector.
            nTimTot (int): Size of g-function time table.
            TStep (ndarray): Time matrix with TStep, shape (nTimTot, 2).
            nu (ndarray): Aggregation time vector, length i.

        Returns:
            kappa (ndarray): Weighting factors vector.
        """
        # Initialize output kappa vector and supporting variables
        kappa = np.zeros(i)

        # Calculate spline derivatives at the support points
        x, y = TStep[:, 0], TStep[:, 1]
        d = self.spline_derivatives(x, y)

        prevT = 0.0  # Initial previous T value

        for j in range(i):
            if j > 0:
                # Find the interval for nu[j-1]
                curInt = np.searchsorted(TStep[:, 0], nu[j - 1]) - 1
                curInt = max(min(curInt, nTimTot - 2), 0)

                # Spline interpolation at nu[j-1]
                prevT = self.cubic_hermite_linear_extrapolation(
                    x=nu[j - 1],
                    x1=TStep[curInt, 0],
                    x2=TStep[curInt + 1, 0],
                    y1=TStep[curInt, 1],
                    y2=TStep[curInt + 1, 1],
                    y1d=d[curInt],
                    y2d=d[curInt + 1],
                )

            # Find the interval for nu[j]
            curInt = np.searchsorted(TStep[:, 0], nu[j]) - 1
            curInt = max(min(curInt, nTimTot - 2), 0)

            # Spline interpolation at nu[j]
            curT = self.cubic_hermite_linear_extrapolation(
                x=nu[j],
                x1=TStep[curInt, 0],
                x2=TStep[curInt + 1, 0],
                y1=TStep[curInt, 1],
                y2=TStep[curInt + 1, 1],
                y1d=d[curInt],
                y2d=d[curInt + 1],
            )

            # Calculate the kappa[j] value
            kappa[j] = curT - prevT

        return kappa

    def write_rCel_record(self, rCel, path, name):
        """
        Write the rCel values to a .mo file.
        """
        ## export rCel to Modelica record:
        Name_rCel_record = f"{name}"
        lines = []
        lines += [
            "within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.ThreeHouses;"
            + "\n"
        ]
        lines += ["record " + Name_rCel_record + " \n"]
        lines += [
            "extends IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.RCelTemplate( \n"
        ]
        lines += ["\t rCel={\n"]
        for r in rCel[:-1]:  # all but last lines
            lines += [f"\t\t {r},\n"]
        lines += [f"\t\t {rCel[-1]}" + "}); \n"]
        lines += [
            'annotation (defaultComponentName="rCel", defaultComponentPrefixes="parameter", Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false))); \n'
        ]
        lines += ["end " + Name_rCel_record + ";"]

        with open(path + f"/{name}.mo", "w") as f:
            f.writelines(lines)

    def write_kappa_record(self, kappa, path, name):
        """
        Writes the given kappa values to a Modelica record file.

        Args:
            kappa (list): A list of kappa values.
            path (str): The path to the output file.

        Returns:
            None
        """

        ## export kappa to Modelica record:
        Name_kappa_record = f"{name}"
        lines = []
        lines += [
            "within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.ThreeHouses;"
            + "\n"
        ]
        lines += ["record " + Name_kappa_record + " \n"]
        lines += [
            "extends IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.KappaTemplate( \n"
        ]
        lines += ["\t kappa={\n"]
        for k in kappa[:-1]:  # all but last lines
            lines += [f"\t\t {k},\n"]
        lines += [f"\t\t {kappa[-1]}" + "}); \n"]
        lines += [
            'annotation (defaultComponentName="kappa", defaultComponentPrefixes="parameter", Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false))); \n'
        ]
        lines += ["end " + Name_kappa_record + ";"]

        with open(path + f"/{name}.mo", "w") as f:
            f.writelines(lines)
