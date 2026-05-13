# -*- coding: utf-8 -*-

"""

EHDO - ENERGY HUB DESIGN OPTIMIZATION Tool

Developed by:   E.ON Energy Research Center,
                Institute for Energy Efficient Buildings and Indoor Climate,
                RWTH Aachen University,
                Germany

Contact:        Marco Wirtz
                marco.wirtz@eonerc.rwth-aachen.de

"""
from pathlib import Path
import gurobipy as gp
import numpy as np
import time
import os
from time import perf_counter
import math
from borefield_modeling import Borefield


# from optim_app.help_functions import create_excel_file


def run_optim(devs, param, dem, result_dict):

    # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Load model parameters
    start_time = time.time()

    days = range(365)
    time_steps = range(24)
    year = range(365)

    # Create set for devices
    all_devs = [
        "PV",
        "STC",
        "PVT",
        "GSHP",
        "Borefield",
        "ASHP",
        "EB",
        "ASCHI",
        "AC",
        "CHP",
        "BOI",
        "TES",
        "CTES",
        "BAT",
        "GS",
    ]

    # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Set up model and create variables

    # Create a new model
    model = gp.Model("Energy_hub_model")

    # Purchase decision binary variables (1 if device is installed, 0 otherwise)
    x = {}
    for device in all_devs:
        x[device] = model.addVar(vtype="B", name="x_" + str(device))

    # Device's capacity (i.e. rated power)
    cap = {}
    for device in all_devs:
        cap[device] = model.addVar(vtype="C", name="nominal_capacity_" + str(device))

    # Roof area used for PV and solar thermal collector installation
    area = {}
    for device in ["PV", "STC", "PVT"]:
        area[device] = model.addVar(vtype="C", name="area_" + str(device))

    # Gas flow to/from devices
    gas = {}
    for device in ["CHP", "BOI", "from_grid", "to_grid"]:
        gas[device] = {}
        for d in days:
            gas[device][d] = {}
            for t in time_steps:
                gas[device][d][t] = model.addVar(
                    vtype="C", name="gas_" + device + "_d" + str(d) + "_t" + str(t)
                )

    # Electric power to/from devices
    power = {}
    for device in [
        "PV",
        "PVT",
        "GSHP",
        "ASHP",
        "EB",
        "ASCHI",
        "CHP",
        "from_grid",
        "to_grid",
    ]:
        power[device] = {}
        for d in days:
            power[device][d] = {}
            for t in time_steps:
                power[device][d][t] = model.addVar(
                    vtype="C", name="power_" + device + "_d" + str(d) + "_t" + str(t)
                )

    # Heat to/from devices
    heat = {}
    for device in ["STC", "PVT", "GSHP", "Borefield", "ASHP", "EB", "AC", "CHP", "BOI"]:
        heat[device] = {}
        for d in days:
            heat[device][d] = {}
            for t in time_steps:
                heat[device][d][t] = model.addVar(
                    vtype="C", name="heat_" + device + "_d" + str(d) + "_t" + str(t)
                )

    # Cooling power to/from devices
    cool = {}
    for device in ["ASCHI", "AC", "Borefield"]:
        cool[device] = {}
        for d in days:
            cool[device][d] = {}
            for t in time_steps:
                cool[device][d][t] = model.addVar(
                    vtype="C", name="cool_" + device + "_d" + str(d) + "_t" + str(t)
                )

    # Storage variables
    ch = {}  # Energy flow to charge storage device
    soc = {}  # State of charge
    for device in ["TES", "CTES", "BAT", "GS"]:
        ch[device] = {}
        soc[device] = {}
        for d in days:
            ch[device][d] = {}
            for t in time_steps:
                # For charge variable: ch is positive if storage is charged, and negative if storage is discharged
                ch[device][d][t] = model.addVar(
                    vtype="C",
                    lb=-gp.GRB.INFINITY,
                    name="ch_" + device + "_d" + str(d) + "_t" + str(t),
                )
        for day in year:
            soc[device][day] = {}
            for t in time_steps:
                soc[device][day][t] = model.addVar(
                    vtype="C", name="soc_" + device + "_d" + str(day) + "_t" + str(t)
                )

    # Borefield regeneration
    reg = {}
    reg["Borefield"] = {}
    inj_bor = {}  # Hourly borefield injection load
    for d in days:
        reg["Borefield"][d] = {}
        inj_bor[d] = {}
        for t in time_steps:
            reg["Borefield"][d][t] = model.addVar(
                vtype="C", name="reg_" + "Borefield" + "_d" + str(d) + "_t" + str(t)
            )
            inj_bor[d][t] = model.addVar(
                vtype="C", name="inj_bor" + "_d" + str(d) + "_t" + str(t)
            )

    # Variables for annual device costs
    inv = {}
    c_inv = {}
    c_om = {}
    c_total = {}
    for device in all_devs:
        inv[device] = model.addVar(vtype="C", name="investment_costs_" + device)
    for device in all_devs:
        c_inv[device] = model.addVar(
            vtype="C", name="annual_investment_costs_" + device
        )
    for device in all_devs:
        c_om[device] = model.addVar(vtype="C", name="om_costs_" + device)
    for device in all_devs:
        c_total[device] = model.addVar(vtype="C", name="total_annual_costs_" + device)

    # Capacity of grid connections (gas and electricity)
    grid_limit_el = model.addVar(vtype="C", name="grid_limit_el")
    grid_limit_gas = model.addVar(vtype="C", name="grid_limit_gas")

    # Total energy amounts taken from grid and fed into grid
    from_el_grid_total = model.addVar(vtype="C", name="from_el_grid_total")
    to_el_grid_total = model.addVar(vtype="C", name="to_el_grid_total")

    from_gas_grid_total = model.addVar(vtype="C", name="from_gas_grid_total")
    to_gas_grid_total = model.addVar(vtype="C", name="to_gas_grid_total")

    # Total revenue for feed-in
    rev_feed_in_gas = model.addVar(vtype="C", name="rev_feed_in_gas")
    rev_feed_in_el = model.addVar(vtype="C", name="rev_feed_in_el")

    # Electricity/gas costs
    supply_costs_el = model.addVar(vtype="C", name="supply_costs_el")
    cap_costs_el = model.addVar(vtype="C", name="cap_costs_el")
    supply_costs_gas = model.addVar(vtype="C", name="supply_costs_gas")
    cap_costs_gas = model.addVar(vtype="C", name="cap_costs_gas")

    # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Objective functions
    obj = {}
    obj["tac"] = model.addVar(
        vtype="C", lb=-gp.GRB.INFINITY, name="total_annualized_costs"
    )
    obj["co2"] = model.addVar(vtype="C", lb=-gp.GRB.INFINITY, name="total_CO2")

    # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Assign objective function
    model.update()
    model.setObjective(
        (1 - param["optim_focus"]) * obj["tac"] + param["optim_focus"] * obj["co2"],
        gp.GRB.MINIMIZE,
    )

    # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Add constraints

    # %% Constraints defined by user in GUI

    for device in all_devs:
        if device == "Borefield":
            if devs[device]["feasible"] == False:
                model.addConstr(x[device] == 0)
            continue
        if devs[device]["feasible"] == True:
            model.addConstr(x[device] == 1)
        else:
            model.addConstr(x[device] == 0)

    # %% CONTINUOUS SIZING OF DEVICES: minimum capacity <= capacity <= maximum capacity

    for device in [
        "ASHP",
        "GSHP",
        "EB",
        "ASCHI",
        "AC",
        "CHP",
        "BOI",
        "TES",
        "CTES",
        "BAT",
        "GS",
    ]:  # PV/STC/PVT is not listed due to min_area/max_area. Borefield is not listed as cap is defined later through equality
        model.addConstr(cap[device] >= x[device] * devs[device]["min_cap"])
        model.addConstr(cap[device] <= x[device] * devs[device]["max_cap"])

    # Ensure that there is no GSHP when there is no borefield
    model.addConstr(cap["GSHP"] >= x["Borefield"] * devs["GSHP"]["min_cap"])
    model.addConstr(cap["GSHP"] <= x["Borefield"] * devs["GSHP"]["max_cap"])

    for d in days:
        for t in time_steps:
            for device in ["EB", "GSHP", "ASHP", "BOI"]:
                model.addConstr(heat[device][d][t] <= cap[device])

            for device in ["CHP"]:
                model.addConstr(power[device][d][t] <= cap[device])

            for device in ["ASCHI", "AC"]:
                model.addConstr(cool[device][d][t] <= cap[device])

            for device in ["Borefield"]:
                # Ensure no cooling or regeneration with borefield if no borefield is installed
                # Here not the capacity (which is zero for technologies with x == 0) is used as limit as cap["Borefield"] does not represent an energy flow
                model.addConstr(cool[device][d][t] <= 100000000 * x[device])
                # borefield regeneration < regeneration capacity
                model.addConstr(
                    reg[device][d][t] <= devs[device]["regeneration_cap"] * x[device]
                )

            # Limitation of power from and to grid
            for device in ["from_grid", "to_grid"]:
                model.addConstr(power[device][d][t] <= grid_limit_el)
                model.addConstr(gas[device][d][t] <= grid_limit_gas)

    # PV and STC: minimum area < used roof area <= maximum area
    for device in ["PV", "STC", "PVT"]:
        model.addConstr(area[device] >= x[device] * devs[device]["min_area"])
        model.addConstr(area[device] <= x[device] * devs[device]["max_area"])
        model.addConstr(
            cap[device] == area[device]
        )  # Set capacity equal to areay; cap[device] is only needed for calculating investment costs)

    # Limited roof area
    if param["limited_roof_area"] == True:
        model.addConstr(
            area["PV"] + area["STC"] + area["PVT"] <= param["available_roof_area"]
        )
    # state of charge < storage capacity
    for device in ["TES", "CTES", "BAT", "GS"]:
        for day in year:
            for t in time_steps:
                model.addConstr(soc[device][day][t] <= cap[device])

    # %% INPUT / OUTPUT CONSTRAINTS

    for d in days:
        for t in time_steps:

            # Photovoltaics
            model.addConstr(
                power["PV"][d][t] <= devs["PV"]["norm_power"][d][t] * cap["PV"]
            )

            # Solar thermal collector
            model.addConstr(
                heat["STC"][d][t] <= devs["STC"]["specific_heat"][d][t] * cap["STC"]
            )

            # PVT
            model.addConstr(
                power["PVT"][d][t] <= devs["PVT"]["norm_power"][d][t] * cap["PVT"]
            )
            model.addConstr(
                heat["PVT"][d][t] <= devs["PVT"]["specific_heat"][d][t] * cap["PVT"]
            )

            # Electric ground source heat pump
            model.addConstr(
                heat["GSHP"][d][t] == power["GSHP"][d][t] * devs["GSHP"]["COP"][d][t]
            )

            # Borefield
            model.addConstr(
                heat["Borefield"][d][t]
                == heat["GSHP"][d][t]
                * ((devs["GSHP"]["COP"][d][t] - 1) / devs["GSHP"]["COP"][d][t])
            )

            model.addConstr(
                inj_bor[d][t] == cool["Borefield"][d][t] + reg["Borefield"][d][t]
            )

            # Electric air source heat pump
            model.addConstr(
                heat["ASHP"][d][t] == power["ASHP"][d][t] * devs["ASHP"]["COP"][d][t]
            )

            # Electric boiler
            model.addConstr(
                heat["EB"][d][t] == power["EB"][d][t] * devs["EB"]["eta_th"]
            )

            # Compression chiller
            model.addConstr(
                cool["ASCHI"][d][t] == power["ASCHI"][d][t] * devs["ASCHI"]["EER"][d][t]
            )

            # Absorption chiller
            model.addConstr(cool["AC"][d][t] == heat["AC"][d][t] * devs["AC"]["eta_th"])

            # Gas CHP
            model.addConstr(
                power["CHP"][d][t] == gas["CHP"][d][t] * devs["CHP"]["eta_el"]
            )
            model.addConstr(
                heat["CHP"][d][t] == gas["CHP"][d][t] * devs["CHP"]["eta_th"]
            )

            # Gas boiler
            model.addConstr(
                heat["BOI"][d][t] == gas["BOI"][d][t] * devs["BOI"]["eta_th"]
            )

    # %% GLOBAL ENERGY BALANCES

    for d in days:
        for t in time_steps:

            # Heating balance
            model.addConstr(
                heat["STC"][d][t]
                + heat["PVT"][d][t]
                + heat["GSHP"][d][t]
                + heat["ASHP"][d][t]
                + heat["EB"][d][t]
                + heat["CHP"][d][t]
                + heat["BOI"][d][t]
                == dem["heat"][d][t]
                + heat["AC"][d][t]
                + ch["TES"][d][t]
                + reg["Borefield"][d][t]
            )

            # Electricity balance
            model.addConstr(
                power["PV"][d][t]
                + power["PVT"][d][t]
                + power["CHP"][d][t]
                + power["from_grid"][d][t]
                == dem["power"][d][t]
                + power["GSHP"][d][t]
                + power["ASHP"][d][t]
                + power["EB"][d][t]
                + power["ASCHI"][d][t]
                + ch["BAT"][d][t]
                + power["to_grid"][d][t]
            )

            model.addConstr(
                cool["Borefield"][d][t] + cool["AC"][d][t] + cool["ASCHI"][d][t]
                == dem["cool"][d][t] + ch["CTES"][d][t]
            )

            # Gas balance
            model.addConstr(
                gas["from_grid"][d][t]
                == gas["CHP"][d][t]
                + gas["BOI"][d][t]
                + ch["GS"][d][t]
                + gas["to_grid"][d][t]
            )

    ######################### BOREFIELD MODELING ########################################
    # fmt: off
    if devs["Borefield"]["feasible"] == True:
        start_bf = perf_counter()
        print("Starting Borefield constraints")

        # Precompute useful values
        nb_bor_steps = devs["Borefield"]["bor_params"]["nbSteps"]
        nb_bor_steps_per_year = int(nb_bor_steps/devs["Borefield"]["life_time"])
        nb_hours_per_bor_step = int(devs["Borefield"]["bor_params"]["tBorStep"]/ 3600)

        # Create the Gurobi variables
        average_load_borefield = {d: model.addVar(vtype="C", lb=-gp.GRB.INFINITY, name=f"average_load_borefield_{d}") for d in range(nb_bor_steps_per_year)}  # Average load of the borefield (positive values)
        extraction_borefield = {d: model.addVar(vtype="C", name=f"extraction_borefield_{d}") for d in range(nb_bor_steps_per_year)}              # Average extraction of the borefield (positive values)
        injection_borefield = {d: model.addVar(vtype="C", name=f"injection_borefield_{d}") for d in range(nb_bor_steps_per_year)}                # Average injection of the borefield (positive values)
        extraction_borefield_peak = {d: model.addVar(vtype="C", name=f"extraction_borefield_peak_{d}") for d in range(nb_bor_steps_per_year)}    # Peak extraction of the borefield (positive values)
        injection_borefield_peak = {d: model.addVar(vtype="C", name=f"injection_borefield_peak_{d}") for d in range(nb_bor_steps_per_year)}      # Peak injection of the borefield (positive values)

        Tb_borefield = {d: model.addVar(vtype="C", lb=-gp.GRB.INFINITY, name=f"Tb_borefield_{d}") for d in range(nb_bor_steps)}
        Tf_monthly_extraction_borefield = {d: model.addVar(vtype="C", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY, name=f"Tf_monthly_extraction_borefield_{d}") for d in range(nb_bor_steps)}    # Monthly average fluid temperature of the borefield for average extraction
        Tf_monthly_injection_borefield = {d: model.addVar(vtype="C", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY, name=f"Tf_monthly_injection_borefield_{d}") for d in range(nb_bor_steps)}      # Monthly average fluid temperature of the borefield for average injection
        Tf_peak_extraction_borefield = {d: model.addVar(vtype="C", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY, name=f"Tf_peak_extraction_borefield_{d}") for d in range(nb_bor_steps)}          # Monthly fluid temperature of the borefield for peak extraction
        Tf_peak_injection_borefield = {d: model.addVar(vtype="C", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY, name=f"Tf_peak_injection_borefield_{d}") for d in range(nb_bor_steps)}            # Monthly fluid temperature of the borefield for peak injection

    
        # Piecewise constant approximation
        # Define the decision variables
        kappas = devs["Borefield"]["bor_params"]["kappas"]

        # Define breakpoints and values for y1 and y2
        breakpoints_H = devs["Borefield"]["bor_params"]["H_range_linearisation"]
        kappa_values = {}
        for d in range(nb_bor_steps):
            kappa_values[d] = np.array([kappas[H][d] for H in breakpoints_H])
        Tf_corr_monthly_values = devs["Borefield"]["bor_params"]["Tf_corr_monthly"]
        Tf_corr_peak_ext_values = devs["Borefield"]["bor_params"]["Tf_corr_peak_ext"]
        Tf_corr_peak_inj_values = devs["Borefield"]["bor_params"]["Tf_corr_peak_inj"]

        # Add lambda variables for the interpolation at each breakpoint
        lambdas = model.addVars(len(breakpoints_H), vtype=gp.GRB.BINARY, name="lambda")
        # Sum of lambda variables should equal 1 to ensure a convex combination
        model.addConstr(gp.quicksum(lambdas[i] for i in range(len(breakpoints_H))) == 1, "ConvexCombination")

        # Link cap["Borefield"] to the breakpoints using lambda variables
        # model.addConstr(cap["Borefield"] == (gp.quicksum(breakpoints_H[i] * lambdas[i] for i in range(len(breakpoints_H))) * devs["Borefield"]["bor_params"]["nBor"] * x["Borefield"]), "PiecewiseH") #--> this was a quadratic constraint --> linearize with auxiliary variables
        M = 1000 # Big M method
        depth_var = model.addVar(vtype="C", name="depth_var", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY)
        model.addConstr(depth_var == gp.quicksum(breakpoints_H[i] * lambdas[i] for i in range(len(breakpoints_H))), "PiecewiseH")
        depth_aux = model.addVar(vtype="C", name="aux_depth", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY)
        model.addConstr(depth_aux <= M * x["Borefield"])
        model.addConstr(depth_aux >= -M * x["Borefield"])
        model.addConstr(depth_aux <= depth_var + M * (1 - x["Borefield"]))
        model.addConstr(depth_aux >= depth_var - M * (1 - x["Borefield"]))
        model.addConstr(cap["Borefield"] == depth_aux * devs["Borefield"]["bor_params"]["nBor"], "BorefieldCapacity")

        # PREVIOUS IMPLEMENTATION 
        # # Piecewise linear approximations
        # # Define the decision variables
        # kappas = devs["Borefield"]["bor_params"]["kappas"]
        # kappa = {}
        # for d in range(nb_bor_steps):
        #     kappa[d] = model.addVar(name=f"kappa_{d}")
        # Tf_corr_monthly = model.addVar(name="Tf_corr_monthly")
        # Tf_corr_peak = model.addVar(name="Tf_corr_peak")
        # # Add SOS2 constraint to enforce piecewise linear interpolation
        # model.addSOS(gp.GRB.SOS_TYPE2, [lambdas[i] for i in range(len(breakpoints_H))])
        # Define kappa's and y2 as convex combinations based on their respective function values
        # for d in range(nb_bor_steps):
        #     model.addConstr(kappa[d] == gp.quicksum(kappa_values[d][i] * lambdas[i] for i in range(len(breakpoints_H))), f"PiecewiseKappa_{d}")
        # model.addConstr(Tf_corr_monthly == gp.quicksum(Tf_corr_monthly_values[i] * lambdas[i] for i in range(len(breakpoints_H))), "Piecewise_Tf_corr_monthly")
        # model.addConstr(Tf_corr_peak == gp.quicksum(Tf_corr_peak_values[i] * lambdas[i] for i in range(len(breakpoints_H))), "Piecewise_Tf_corr_peak")

        # define auxiliary variables for linearising bilinear terms
        max_aux_avg = 500
        min_aux_avg = -500 # Here, min and max should have the same absolute value
        max_aux = 500
        min_aux = 0 # 0 because extraction and injection are positive
        aux_avg = {}
        aux_ext = {}
        aux_inj = {}
        aux_ext_peak = {}
        aux_inj_peak = {}
        for d in range(nb_bor_steps_per_year):
            aux_avg[d] = {}
            aux_ext[d] = {}
            aux_inj[d] = {}
            aux_ext_peak[d] = {}
            aux_inj_peak[d] = {}
            for h in range(len(breakpoints_H)):
                aux_avg[d][h] = model.addVar(vtype="C", name=f"aux_avg{d}_H{h}", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY) # aux_avg_d_h = average_load_borefield[d] * lambda[h]
                aux_ext[d][h] = model.addVar(vtype="C", name=f"aux_ext{d}_H{h}", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY) # aux_ext_d_h = extraction_borefield[d] * lambda[h]
                aux_inj[d][h] = model.addVar(vtype="C", name=f"aux_inj{d}_H{h}", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY) # aux_inj_d_h = injection_borefield[d] * lambda[h]
                aux_ext_peak[d][h] = model.addVar(vtype="C", name=f"aux_ext_peak{d}_H{h}", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY) # aux_ext_peak_d_h = (extraction_borefield_peak[d] - extraction_borefield[d]) * lambda[h]
                aux_inj_peak[d][h] = model.addVar(vtype="C", name=f"aux_inj_peak{d}_H{h}", lb=-gp.GRB.INFINITY, ub=gp.GRB.INFINITY) # aux_inj_peak_d_h = (injection_borefield_peak[d] - injection_borefield[d]) * lambda[h]

            

        extraction_borefield_array = np.array([[heat["Borefield"][d][t] for t in time_steps ] for d in days]).flatten()
        extraction_borefield_values = {step: (sum(extraction_borefield_array[step*nb_hours_per_bor_step: (step+1)*nb_hours_per_bor_step]))/nb_hours_per_bor_step for step in range(nb_bor_steps_per_year)}
        injection_borefield_array = np.array([[inj_bor[d][t] for t in time_steps ] for d in days]).flatten()
        injection_borefield_values = {step: (sum(injection_borefield_array[step*nb_hours_per_bor_step: (step+1)*nb_hours_per_bor_step]))/nb_hours_per_bor_step for step in range(nb_bor_steps_per_year)}
        average_load_borefield_values = {step: (injection_borefield[step] - extraction_borefield_values[step]) for step in range(nb_bor_steps_per_year)}
        T_gr = devs["Borefield"]["bor_params"]["T_cte"]  # Ground temperature
        Tf_max = devs["Borefield"]["bor_params"]["Tf_max"]  # Maximum fluid temperature
        Tf_min = devs["Borefield"]["bor_params"]["Tf_min"]  # Minimum fluid temperature
        for d in range(nb_bor_steps_per_year):
            model.addConstr(extraction_borefield[d] == extraction_borefield_values[d])
            model.addConstr(extraction_borefield_peak[d] == gp.max_([extraction_borefield_array[d*nb_hours_per_bor_step + i] for i in range(nb_hours_per_bor_step)]))
            model.addConstr(injection_borefield[d] == injection_borefield_values[d])
            model.addConstr(injection_borefield_peak[d] == gp.max_([injection_borefield_array[d*nb_hours_per_bor_step + i] for i in range(nb_hours_per_bor_step)]))
            model.addConstr(average_load_borefield[d] == average_load_borefield_values[d])

        # Add the constraints for the auxiliary variables

        for d in range(nb_bor_steps_per_year):
            for h in range(len(breakpoints_H)):
                model.addConstr(aux_avg[d][h] <= max_aux_avg * lambdas[h])
                model.addConstr(aux_avg[d][h] <= average_load_borefield[d] - min_aux_avg * (1 - lambdas[h]))
                model.addConstr(aux_avg[d][h] >= min_aux_avg * lambdas[h])
                model.addConstr(aux_avg[d][h] >= average_load_borefield[d] - max_aux_avg * (1 - lambdas[h]))

                model.addConstr(aux_ext[d][h] <= max_aux * lambdas[h])
                model.addConstr(aux_ext[d][h] <= extraction_borefield[d] - min_aux * (1 - lambdas[h]))
                model.addConstr(aux_ext[d][h] >= min_aux * lambdas[h])
                model.addConstr(aux_ext[d][h] >= extraction_borefield[d] - max_aux * (1 - lambdas[h]))

                model.addConstr(aux_inj[d][h] <= max_aux * lambdas[h])
                model.addConstr(aux_inj[d][h] <= injection_borefield[d] - min_aux * (1 - lambdas[h]))
                model.addConstr(aux_inj[d][h] >= min_aux * lambdas[h])
                model.addConstr(aux_inj[d][h] >= injection_borefield[d] - max_aux * (1 - lambdas[h]))

                model.addConstr(aux_ext_peak[d][h] <= max_aux * lambdas[h])
                model.addConstr(aux_ext_peak[d][h] <= (extraction_borefield_peak[d] - extraction_borefield[d]) - min_aux * (1 - lambdas[h]))
                model.addConstr(aux_ext_peak[d][h] >= min_aux * lambdas[h])
                model.addConstr(aux_ext_peak[d][h] >=(extraction_borefield_peak[d] - extraction_borefield[d]) - max_aux * (1 - lambdas[h]))

                model.addConstr(aux_inj_peak[d][h] <= max_aux * lambdas[h])
                model.addConstr(aux_inj_peak[d][h] <= (injection_borefield_peak[d] - injection_borefield[d]) - min_aux * (1 - lambdas[h]))
                model.addConstr(aux_inj_peak[d][h] >= min_aux * lambdas[h])
                model.addConstr(aux_inj_peak[d][h] >= (injection_borefield_peak[d] - injection_borefield[d]) - max_aux * (1 - lambdas[h]))

        for d in range(nb_bor_steps):
            if devs["Borefield"]["fixed_T_model"]:
                model.addConstr(Tb_borefield[d] == T_gr)
                model.addConstr(Tf_monthly_extraction_borefield[d] == T_gr)
                model.addConstr(Tf_monthly_injection_borefield[d] == T_gr)
                model.addConstr(Tf_peak_extraction_borefield[d] == T_gr)
                model.addConstr(Tf_peak_injection_borefield[d] == T_gr)
            else:
                step = d % nb_bor_steps_per_year
                # Compute the borefield temperature
                model.addConstr(Tb_borefield[d] == T_gr + 1000*gp.quicksum(gp.quicksum(aux_avg[i%nb_bor_steps_per_year][h] * kappa_values[d-i][h] for h in range(len(breakpoints_H))) for i in range(d+1)))
                model.addConstr(Tf_monthly_extraction_borefield[d] == Tb_borefield[d] - 1000 * gp.quicksum(aux_ext[step][h] * Tf_corr_monthly_values[h] for h in range(len(breakpoints_H))))
                model.addConstr(Tf_peak_extraction_borefield[d] == Tf_monthly_extraction_borefield[d] - 1000 * gp.quicksum(aux_ext_peak[step][h] * Tf_corr_peak_ext_values[h] for h in range(len(breakpoints_H))))
                model.addConstr(Tf_monthly_injection_borefield[d] == Tb_borefield[d] + 1000 * gp.quicksum(aux_inj[step][h] * Tf_corr_monthly_values[h] for h in range(len(breakpoints_H))))
                model.addConstr(Tf_peak_injection_borefield[d] == Tf_monthly_injection_borefield[d] + 1000 * gp.quicksum(aux_inj_peak[step][h] * Tf_corr_peak_inj_values[h] for h in range(len(breakpoints_H))))

                # PREVIOUS IMPLEMENTATION:
                # Tb_borefield_sum =  sum(average_load_borefield[i%nb_bor_steps_per_year] * kappa[d - i] for i in range(d + 1))
                # model.addConstr(Tb_borefield[d] == T_gr + 1000*Tb_borefield_sum)
                # model.addConstr(Tf_monthly_extraction_borefield[d] == Tb_borefield[d] - 1000*extraction_borefield[step]*Tf_corr_monthly)
                # model.addConstr(Tf_peak_extraction_borefield[d] == Tf_monthly_extraction_borefield[d] - 1000*(extraction_borefield_peak[step] - extraction_borefield[step])*Tf_corr_peak)
                # model.addConstr(Tf_monthly_injection_borefield[d] == Tb_borefield[d] + 1000*injection_borefield[step]*Tf_corr_monthly)
                # model.addConstr(Tf_peak_injection_borefield[d] == Tf_monthly_injection_borefield[d] + 1000*(injection_borefield_peak[step] - injection_borefield[step])*Tf_corr_peak)
                
                # Commment the following constraints if you want to do fixed size model
                model.addConstr(Tf_peak_extraction_borefield[d] >= Tf_min)
                model.addConstr(Tf_peak_injection_borefield[d] <= Tf_max)

        # Uncomment the following constraints if you want to do fixed size model
        # model.addConstr(cap["Borefield"] == devs["Borefield"]["bor_params"]["H"] * devs["Borefield"]["bor_params"]["nBor"], name="Borefield_capacity")
        print("Setting borefield constraints took", perf_counter() - start_bf, "seconds")
    else: 
        print("Borefield not feasible: no borefield constraints set")

    # fmt: on

    #############################################################################

    # %% MEET PEAK DEMANDS OF UNCLUSTERED DEMANDS

    if (
        len(days) < 365
    ):  # if full-year optimisation --> no additional constraints to meet peak demands are necessary
        print("Setting additional peak constraints")
        if param["peak_dem_met_conv"] == False:

            # Heating
            model.addConstr(
                cap["GSHP"]
                + cap["ASHP"]
                + cap["EB"]
                + cap["CHP"] / devs["CHP"]["eta_el"] * devs["CHP"]["eta_th"]
                + cap["BOI"]
                >= param["peak_heat"]
            )

            # Cooling
            model.addConstr(cap["ASCHI"] + cap["AC"] + 1000000 >= param["peak_cool"])

            # Power
            model.addConstr(cap["CHP"] + grid_limit_el >= param["peak_power"])

        else:  # With STC, PV

            # Heating
            model.addConstr(
                +cap["GSHP"]
                + cap["ASHP"]
                + cap["EB"]
                + cap["CHP"] / devs["CHP"]["eta_el"] * devs["CHP"]["eta_th"]
                + cap["BOI"]
                >= param["peak_heat"]
            )

            # Cooling
            model.addConstr(cap["ASCHI"] + cap["AC"] + 1000000 >= param["peak_cool"])

            # Power
            model.addConstr(+cap["CHP"] + grid_limit_el >= param["peak_power"])

    else:
        print("No additional peak constraints set")
    # %% STORAGE DEVICES

    for device in ["TES", "CTES", "BAT", "GS"]:
        for day in year:
            for t in np.arange(1, len(time_steps)):

                # Energy balance: soc(t) = soc(t-1) + charge - discharge
                model.addConstr(
                    soc[device][day][t]
                    == soc[device][day][t - 1] * (1 - devs[device]["sto_loss"])
                    + ch[device][day][t]
                )

            # Transition between two consecutive days
            if day > 0:
                model.addConstr(
                    soc[device][day][0]
                    == soc[device][day - 1][len(time_steps) - 1]
                    * (1 - devs[device]["sto_loss"])
                    + ch[device][day][0]
                )

        # Cyclic year condition
        model.addConstr(
            soc[device][0][0]
            == soc[device][len(year) - 1][len(time_steps) - 1]
            * (1 - devs[device]["sto_loss"])
            + ch[device][0][0]
        )

    # %% SUM UP RESULTS

    ### Total energy import/feed-in ###
    # Total amount of gas taken from and to grid
    model.addConstr(
        from_gas_grid_total
        == sum(sum(gas["from_grid"][d][t] for t in time_steps) for d in days)
    )
    model.addConstr(
        to_gas_grid_total
        == sum(sum(gas["to_grid"][d][t] for t in time_steps) for d in days)
    )

    # Total electric energy from and to grid
    model.addConstr(
        from_el_grid_total
        == sum(sum(power["from_grid"][d][t] for t in time_steps) for d in days)
    )
    model.addConstr(
        to_el_grid_total
        == sum(sum(power["to_grid"][d][t] for t in time_steps) for d in days)
    )

    ### Costs ###
    # Costs/revenues for electricity
    model.addConstr(supply_costs_el == from_el_grid_total * param["price_supply_el"])
    model.addConstr(cap_costs_el == grid_limit_el * param["price_cap_el"])
    model.addConstr(rev_feed_in_el == to_el_grid_total * param["revenue_feed_in_el"])

    # Costs/revenues for natural gas
    model.addConstr(supply_costs_gas == from_gas_grid_total * param["price_supply_gas"])
    model.addConstr(cap_costs_gas == grid_limit_gas * param["price_cap_gas"])
    model.addConstr(rev_feed_in_gas == to_gas_grid_total * param["revenue_feed_in_gas"])

    ### Supply limitations ###
    # Forbid/allow feed-in (user input)
    if param["enable_feed_in_el"] != True:
        model.addConstr(to_el_grid_total == 0)
    if param["enable_feed_in_gas"] != True:
        model.addConstr(to_gas_grid_total == 0)

    # Limitation of electricity supply (user input)
    if param["enable_supply_el"] != True:
        model.addConstr(from_el_grid_total == 0)
    if param["enable_cap_limit_el"] == True:
        model.addConstr(grid_limit_el <= param["cap_limit_el"])
    if param["enable_supply_limit_el"] == True:
        model.addConstr(from_el_grid_total <= param["supply_limit_el"])

    # Limitation of gas supply (user input)
    if param["enable_supply_gas"] != True:
        model.addConstr(from_gas_grid_total == 0)
    if param["enable_cap_limit_gas"] == True:
        model.addConstr(grid_limit_gas <= param["cap_limit_gas"])
    if param["enable_supply_limit_gas"] == True:
        model.addConstr(from_gas_grid_total <= param["supply_limit_gas"])

    # Total investment costs
    for device in all_devs:
        model.addConstr(inv[device] == devs[device]["inv_var"] * cap[device])

    # Annual investment costs
    for device in all_devs:
        model.addConstr(c_inv[device] == inv[device] * devs[device]["ann_factor"])

    # Operation and maintenance costs
    for device in all_devs:
        model.addConstr(c_om[device] == devs[device]["cost_om"] * inv[device])

    # Total annual costs
    for device in all_devs:
        model.addConstr(c_total[device] == c_inv[device] + c_om[device])

    # %% OBJECTIVE FUNCTIONS
    # Total annualized costs
    model.addConstr(
        obj["tac"]
        == sum(c_total[dev] for dev in all_devs)  # annualized investments
        + supply_costs_gas
        + cap_costs_gas  # gas costs
        + supply_costs_el
        + cap_costs_el  # electricity costs
        - rev_feed_in_el
        - rev_feed_in_gas  # revenues
        + (from_gas_grid_total * param["co2_gas"]) * param["co2_tax"]
    )  # CO2 tax

    # Annual CO2 emissions: Implicit emissions by power supply from national grid is penalized, feed-in is ignored
    model.addConstr(
        obj["co2"]
        == from_el_grid_total * param["co2_el_grid"]
        + from_gas_grid_total * param["co2_gas"]
        - to_el_grid_total * param["co2_el_feed_in"]
        - to_gas_grid_total * param["co2_gas_feed_in"]
    )

    # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Set model parameters and execute calculation

    print(
        "Precalculation and model set up done in %f seconds."
        % (time.time() - start_time)
    )

    # Set solver parameters
    model.Params.MIPGap = 0.02  # ---,   gap for branch-and-bound algorithm
    # model.Params.Presolve = 2 # ---,   -1: no presolve, 0: auto, 1: conserv., 2: aggressive
    # model.Params.MIPFocus = 1
    # model.Params.method = 2     # ---,   -1: default, 0: primal simplex, 1: dual simplex, 2: barrier, etc.

    ## The following lines are used to visualize the gurobi model --> uncomment if needed
    # import pandas as pd
    # import scipy as sp
    # import matplotlib.pyplot as plt
    # model.update()
    # var_names = [v.VarName for v in model.getVars()]  # Column labels
    # constr_names = [c.ConstrName for c in model.getConstrs()]  # Row labels
    # # Open the file in write mode ('w')
    # with open("var_names.txt", "w") as file:
    #     # Write all elements at once, joining with a newline
    #     file.writelines(f"{item}\n" for item in var_names)
    # with open("constr_names.txt", "w") as file:
    #     # Write all elements at once, joining with a newline
    #     file.writelines(f"{item}\n" for item in constr_names)

    # A = model.getA()
    # sense = np.array(model.getAttr("Sense", model.getConstrs()))
    # # extract sub matrices of (in)equality constraints
    # Aeq = A[sense == "=", :]
    # Ale = A[sense == "<", :]
    # Age = A[sense == ">", :]

    # plt.figure()
    # plt.spy(A, markersize=5)
    # plt.title("Gurobi Constraint Matrix Visualization")
    # plt.tight_layout()
    # plt.figure()
    # plt.spy(Aeq, markersize=5)
    # plt.title("Gurobi Constraint Matrix Visualization (Equality)")
    # plt.tight_layout()
    # plt.figure()
    # plt.spy(Ale, markersize=5)
    # plt.title("Gurobi Constraint Matrix Visualization (Less than)")
    # plt.tight_layout()
    # plt.figure()
    # plt.spy(Age, markersize=5)
    # plt.title("Gurobi Constraint Matrix Visualization (Greater than)")
    # plt.tight_layout()
    # plt.show()
    # model.write("model.lp")  # Save model in LP format

    # Execute calculation
    start_time = time.time()
    model.optimize()

    print("Optimization done. (%f seconds.)" % (time.time() - start_time))

    # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Check and save results

    # Check if optimal solution was found
    if model.Status in (3, 4) or model.SolCount == 0:  # "INFEASIBLE" or "INF_OR_UNBD"

        print("Optimization: No feasible solution found.")
        try:
            print("Try to calculate IIS.")
            model.write("model.lp")
            model.computeIIS()
            model.write("model.ilp")

            print("IIS was calculated and saved as model.ilp")

        except:
            print("Could not calculate IIS.")
        return {}

    else:
        print("Optimization: Optimal solution found.")
        print("Optimization: Optimal solution found.")
        print("Optimization: Optimal solution found.")
        pwd = Path.cwd()
        result_dir = pwd / "results"
        if not result_dir.exists():
            result_dir.mkdir(parents=True)

        # Save results
        model.write(str(result_dir / "model.sol"))
        model.write(str(result_dir / "model.lp"))
        # fmt: off

        ###  MAKE A DICITONARY WITH THE ALL USEFUL RESULTS
        ## TECHNOLOGY SPECIFIC RESULTS
        always_include_devs = ["ASHP", "GSHP", "Borefield", "EB", "BOI", "PV", "STC", "PVT", "TES", "CTES", "BAT", "ASCHI"]
        feasible_devs = [dev for dev in all_devs if devs[dev]["feasible"]]
        result_devs = always_include_devs + [dev for dev in feasible_devs if dev not in always_include_devs]
        result_dict["installed_devices"] = result_devs # List of installed devices
        # Size and investment costs of the devices    
        for device in result_devs:
            result_dict[device] = {}
            result_dict[device]["cap"] = round(cap[device].X, 1)
            result_dict[device]["CAPEX"] = int(c_inv[device].X / param["CRF"]) # Total investment cost over observation time incl. initial investement, replacements and substraction of any residual value [EUR]
            result_dict[device]["CAPEX_intial"] = int(inv[device].X) # Initial investment cost [EUR]
            result_dict[device]["CAPEX_annual"] = int(c_inv[device].X) # Annualized investment costs [EUR/year]
        
        # Add Borefield depth and number of boreholes  if borefield is present
        if "Borefield" in result_devs:
            result_dict["Borefield"]["depth"] = round(cap["Borefield"].X / devs["Borefield"]["bor_params"]["nBor"], 1)
            result_dict["Borefield"]["nBor"] = devs["Borefield"]["bor_params"]["nBor"]*x["Borefield"].X
            result_dict["Borefield"]["Sized_to_min"] = (cap["Borefield"].X == devs["Borefield"]["min_cap"] and cap["Borefield"].X > 0)
            result_dict["Borefield"]["Sized_to_max"] = (cap["Borefield"].X == devs["Borefield"]["max_cap"] and cap["Borefield"].X > 0)
            ## rCel and kappa calculation for modelica
            if result_dict["Borefield"]["cap"] > 0: # if borefield is present, the kappa and rCel parameters should be caluclated exactly
                devs["Borefield"]["bor_params"]["H"] = result_dict["Borefield"]["depth"] 
            else: # if borefield is not present, the kappa and rCel parameters are calculated for a default depth of 100m
                devs["Borefield"]["bor_params"]["H"] = 100
            # Load aggregation parameters
            tLoaAgg = 3600
            nCel = 1 # Modelica default is: nCel = 5
            lvlBas = 2 # Modelica default is: lvlBas = 2
            timFin = devs["Borefield"]["bor_params"]["timFin"]  # s, final time of the g-function calculation

            # Create borefield object
            bf = Borefield(devs["Borefield"]["bor_params"])

            # Calculate the g-function
            bf.calculate_g_function()
            timSer = np.column_stack((devs["Borefield"]["bor_params"]["time_gfunc"], devs["Borefield"]["bor_params"]["Tstep_gfunc"]))
            i = bf.countAggregationCells(lvlBas=lvlBas, nCel=nCel, timFin=timFin, tLoaAgg=tLoaAgg)
            nu, rCel = bf.aggregationCellTimes(i, lvlBas, nCel, tLoaAgg, timFin)
            kappa = bf.aggregationWeightingFactors(i, len(devs["Borefield"]["bor_params"]["Tstep_gfunc"]), timSer, nu)

            rCel_param = "{" + str(", ".join(map(str, rCel)) + "}")
            kappa_param = "{" + str(", ".join(map(str, kappa)) + "}")
            result_dict["Borefield"]["rCel"] = rCel_param
            result_dict["Borefield"]["kappa"] = kappa_param
            


        # Heat, cold, and power of the devices 
        heat_gen_devs = ["STC", "PVT", "GSHP", "Borefield", "ASHP", "EB", "CHP", "BOI"]
        heat_gen_devs = [dev for dev in heat_gen_devs if dev in result_devs]
        heat_dem_devs = ["AC"]
        heat_dem_devs = [dev for dev in heat_dem_devs if dev in result_devs]
        heat_devs = heat_gen_devs + heat_dem_devs
        cool_devs = ["ASCHI", "AC", "Borefield"]
        cool_devs = [dev for dev in cool_devs if dev in result_devs]
        power_gen_devs = ["PV", "PVT", "CHP"]
        power_gen_devs = [dev for dev in power_gen_devs if dev in result_devs]
        power_dem_devs = ["GSHP", "ASHP", "EB", "ASCHI"]
        power_dem_devs = [dev for dev in power_dem_devs if dev in result_devs]
        power_devs = power_gen_devs + power_dem_devs


        for dev in heat_devs:
            result_dict[dev]["heat"] = np.zeros(len(year) * len(time_steps))
            for d in days:
                for t in time_steps:
                    result_dict[dev]["heat"][d * len(time_steps) + t] = heat[dev][d][t].X
            result_dict[dev]["heat_total"] = int(sum(result_dict[dev]["heat"]) / 1000) # MWh

        for dev in cool_devs:
            result_dict[dev]["cool"] = np.zeros(len(year) * len(time_steps))
            for d in days:
                for t in time_steps:
                    result_dict[dev]["cool"][d * len(time_steps) + t] = cool[dev][d][t].X
            result_dict[dev]["cool_total"] = int(sum(result_dict[dev]["cool"]) / 1000) # MWh
            
        for dev in power_devs:
            result_dict[dev]["power"] = np.zeros(len(year) * len(time_steps))
            for d in days:
                for t in time_steps:
                    result_dict[dev]["power"][d * len(time_steps) + t] = power[dev][d][t].X
            result_dict[dev]["power_total"] = int(sum(result_dict[dev]["power"]) / 1000) # MWh

        # Calculate full load hours
        eps = 0.01
        for dev in heat_gen_devs:
            if cap[dev].X > eps:
                result_dict[dev]["flh"] = int(result_dict[dev]["heat_total"] * 1000 / cap[dev].X)
            else:
                result_dict[dev]["flh"] = 0
        for dev in power_gen_devs:
            if cap[dev].X > eps:
                result_dict[dev]["flh"] = int(result_dict[dev]["power_total"] * 1000 / cap[dev].X)
            else:
                result_dict[dev]["flh"] = 0

        # State of charge, charging power and charhing cycles of storage devices
        storage_devs = ["TES", "CTES", "BAT", "GS"]
        storage_devs = [dev for dev in storage_devs if devs[dev]["feasible"]]
        for dev in storage_devs:
            result_dict[dev]["soc"] = np.zeros(len(year) * len(time_steps))
            result_dict[dev]["ch"] = np.zeros(len(year) * len(time_steps))
            for d in days:
                for t in time_steps:
                    result_dict[dev]["soc"][d * len(time_steps) + t] = soc[dev][d][t].X
                    result_dict[dev]["ch"][d * len(time_steps) + t] = ch[dev][d][t].X

            # Calculate charge cycles of storages
            if cap[dev].X > eps:
                result_dict[dev]["chc"] = int(
                    sum(
                        sum(abs(ch[dev][d][t].X) / 2 for t in time_steps)
                        
                        for d in days
                    )
                    / cap[dev].X
                )
            else:
                result_dict[dev]["chc"] = 0

        # Calculate volume of thermal storages
        for dev in ["TES", "CTES"]:
            if dev in result_devs:
                result_dict[dev]["volume"] = round(cap[dev].X / (param["c_w"] * param["rho_w"] * devs[dev]["delta_T"]) * 3600, 1)

        # Borefield results
        if devs["Borefield"]["feasible"]:
            result_dict["Borefield"]["Tb"] = np.zeros(devs["Borefield"]["bor_params"]["nbSteps"])
            result_dict["Borefield"]["Qb_average"] = np.zeros(nb_bor_steps_per_year)
            result_dict["Borefield"]["Qb_extraction"] = np.zeros(nb_bor_steps_per_year)
            result_dict["Borefield"]["Qb_peak_extraction"] = np.zeros(nb_bor_steps_per_year)
            result_dict["Borefield"]["Qb_injection"] = np.zeros(nb_bor_steps_per_year)
            result_dict["Borefield"]["Qb_peak_injection"] = np.zeros(nb_bor_steps_per_year)
            result_dict["Borefield"]["Tf_monthly_extraction"] = np.zeros(devs["Borefield"]["bor_params"]["nbSteps"])
            result_dict["Borefield"]["Tf_peak_extraction"] = np.zeros(devs["Borefield"]["bor_params"]["nbSteps"])
            result_dict["Borefield"]["Tf_monthly_injection"] = np.zeros(devs["Borefield"]["bor_params"]["nbSteps"])
            result_dict["Borefield"]["Tf_peak_injection"] = np.zeros(devs["Borefield"]["bor_params"]["nbSteps"])
            result_dict["Borefield"]["reg"] = np.zeros(len(year) * len(time_steps))

            for d in range(devs["Borefield"]["bor_params"]["nbSteps"]):
                result_dict["Borefield"]["Tb"][d] = Tb_borefield[d].X
                result_dict["Borefield"]["Qb_average"][d % nb_bor_steps_per_year] = (average_load_borefield[d % nb_bor_steps_per_year].X)
                result_dict["Borefield"]["Qb_extraction"][d % nb_bor_steps_per_year] = (extraction_borefield[d % nb_bor_steps_per_year].X)
                result_dict["Borefield"]["Qb_peak_extraction"][d % nb_bor_steps_per_year] = (extraction_borefield_peak[d % nb_bor_steps_per_year].X)
                result_dict["Borefield"]["Qb_injection"][d % nb_bor_steps_per_year] = (injection_borefield[d % nb_bor_steps_per_year].X)
                result_dict["Borefield"]["Qb_peak_injection"][d % nb_bor_steps_per_year] = (injection_borefield_peak[d % nb_bor_steps_per_year].X)
                result_dict["Borefield"]["Tf_monthly_extraction"][d] = (Tf_monthly_extraction_borefield[d].X)
                result_dict["Borefield"]["Tf_peak_extraction"][d] = (Tf_peak_extraction_borefield[d].X)
                result_dict["Borefield"]["Tf_monthly_injection"][d] = (Tf_monthly_injection_borefield[d].X)
                result_dict["Borefield"]["Tf_peak_injection"][d] = (Tf_peak_injection_borefield[d].X)
            for d in days:
                for t in time_steps:
                    result_dict["Borefield"]["reg"][d * len(time_steps) + t] = reg["Borefield"][d][t].X
            result_dict["Borefield"]["reg_total"] = int(sum(result_dict["Borefield"]["reg"]) / 1000) # MWh

        # Calculate minimum borefield temperature in first year of operation
        if "Borefield" in result_devs:
            if result_dict["Borefield"]["cap"] > 0:
                result_dict["Borefield"]["Tf_min"] = np.min(
                    result_dict["Borefield"]["Tf_peak_extraction"][0:nb_bor_steps_per_year]
                )  # degC
            else:
                result_dict["Borefield"]["Tf_min"] = 0 # degC


        # Renewable curtailment
        heat_renewables = ["STC", "PVT"]
        power_renewables = ["PV"]
        heat_renewables = [dev for dev in heat_renewables if devs[dev]["feasible"]]
        power_renewables = [dev for dev in power_renewables if devs[dev]["feasible"]]

        for dev in heat_renewables:
            result_dict[dev]["curtailment_heat"] = np.zeros(len(year) * len(time_steps))
            for d in days:
                for t in time_steps:
                    result_dict[dev]["curtailment_heat"][d * len(time_steps) + t] = (devs[dev]["specific_heat"][d][t] * cap[dev].X - heat[dev][d][t].X)
            result_dict[dev]["curtailed_heat"] = int(np.sum(result_dict[dev]["curtailment_heat"]) / 1000) # MWh
        
        for dev in power_renewables:    
            result_dict[dev]["curtailment_power"] = np.zeros(len(year) * len(time_steps))
            for d in days:
                for t in time_steps:
                    result_dict[dev]["curtailment_power"][d * len(time_steps) + t] = (devs[dev]["norm_power"][d][t] * cap[dev].X - power[dev][d][t].X)
            result_dict[dev]["curtailed_power"] = int(np.sum(result_dict[dev]["curtailment_power"]) / 1000) # MWh


        ## GENERAL RESULTS

        result_dict["tac"] = int(obj["tac"].X)  # Total annualized costs [EUR/year]
        result_dict["co2"] = int(obj["co2"].X / 1000)  # Total annual CO2 emissions [tonCO2/year]

        result_dict["CAPEX_initial"] = int(sum(inv[k].X for k in cap.keys())) # Total investment costs at year 0 [EUR]
        result_dict["CAPEX_annual"] = int(sum(c_inv[k].X for k in cap.keys())) # Total annualized investment costs [EUR/year]
        result_dict["OPEX_yearly"] = int(result_dict["tac"] - result_dict["CAPEX_annual"])  # Total annual operation and maintenance costs [EUR/year]
        result_dict["OPEX_yearly_maint"] = int(sum(c_om[k].X for k in cap.keys()))  # Total annual operation and maintenance costs for maintenance [EUR/year]
        result_dict["OPEX_yearly_energy"] =  int(result_dict["OPEX_yearly"] - result_dict["OPEX_yearly_maint"])  # Total annual operation and maintenance costs for energy [EUR/year]: cost of gas, electricity, co2 tax - feed-in revenues

        result_dict["total_om_cost"] = int(sum(c_om[k].X for k in cap.keys()))
        # Imports/exports
        result_dict["from_el_grid_total"] = int(from_el_grid_total.X / 1000)  # MWh
        result_dict["to_el_grid_total"] = int(to_el_grid_total.X / 1000)  # MWh
        result_dict["from_gas_grid_total"] = int(from_gas_grid_total.X / 1000)  # MWh
        result_dict["to_gas_grid_total"] = int(to_gas_grid_total.X / 1000)  # MWh

        # CO2 emissions
        result_dict["total_co2_el"] = int(from_el_grid_total.X * param["co2_el_grid"] / 1000)  # t/a
        result_dict["total_co2_el_feed_in"] = int(to_el_grid_total.X * param["co2_el_feed_in"] / 1000)  # t/a
        if result_dict["total_co2_el_feed_in"] > 0:
            result_dict["total_co2_el_feed_in_larger_zero"] = True
        result_dict["total_co2_gas"] = int(from_gas_grid_total.X * param["co2_gas"] / 1000)  # t/a
        result_dict["total_co2_gas_feed_in"] = int(to_gas_grid_total.X * param["co2_gas_feed_in"] / 1000)  # t/a
        if result_dict["total_co2_gas_feed_in"] > 0:
            result_dict["total_co2_gas_feed_in_larger_zero"] = True

        result_dict["co2_onsite_emissions"] = int((from_gas_grid_total.X * param["co2_gas"]) / 1000) #tonCO2/year
        result_dict["co2_global_emissions"] = int(result_dict["co2"]) # tonCO2/year
        result_dict["co2_credit_feedin"] = int((to_el_grid_total.X * param["co2_el_feed_in"] + to_gas_grid_total.X * param["co2_gas_feed_in"]) / 1000) # tonCO2/year
        result_dict["co2_tax_total"] = int(result_dict["co2_onsite_emissions"] * param["co2_tax"] * 1000)  # EUR, only gas


        # Calculate maximum grid flows (electricity and gas)
        for k in ["from_grid", "to_grid"]:
            result_dict["max_el_" + k] = 0
            for d in days:
                for t in time_steps:
                    if power[k][d][t].X > result_dict["max_el_" + k]:
                        result_dict["max_el_" + k] = power[k][d][t].X
            result_dict["max_el_" + k] = int(result_dict["max_el_" + k])

        for k in ["from_grid", "to_grid"]:
            result_dict["max_gas_" + k] = 0
            for d in days:
                for t in time_steps:
                    if gas[k][d][t].X > result_dict["max_gas_" + k]:
                        result_dict["max_gas_" + k] = gas[k][d][t].X
            result_dict["max_gas_" + k] = int(result_dict["max_gas_" + k])


        result_dict["supply_costs_el"] = int(supply_costs_el.X)
        result_dict["cap_costs_el"] = int(cap_costs_el.X)
        result_dict["total_el_costs"] = int(supply_costs_el.X + cap_costs_el.X)
        result_dict["rev_feed_in_el"] = int(rev_feed_in_el.X)

        result_dict["supply_costs_gas"] = int(supply_costs_gas.X)
        result_dict["cap_costs_gas"] = int(cap_costs_gas.X)
        result_dict["total_gas_costs"] = int(supply_costs_gas.X + cap_costs_gas.X)
        result_dict["rev_feed_in_gas"] = int(rev_feed_in_gas.X)


        return result_dict
