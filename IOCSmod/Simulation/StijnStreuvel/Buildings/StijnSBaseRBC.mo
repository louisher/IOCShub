within IOCSmod.Simulation.StijnStreuvel.Buildings;
model StijnSBaseRBC
  outer IDEAS.BoundaryConditions.SimInfoManager sim(
    n50=n50,
    interZonalAirFlowType=IDEAS.BoundaryConditions.Types.InterZonalAirFlow.OnePort,
    incAndAziInBus={{IDEAS.Types.Tilt.Ceiling,0},{IDEAS.Types.Tilt.Wall,downAngle},{IDEAS.Types.Tilt.Wall,leftAngle},{IDEAS.Types.Tilt.Wall,upAngle},{IDEAS.Types.Tilt.Wall,rightAngle}, {IDEAS.Types.Tilt.Floor,0}})
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  parameter Boolean addDummyEquation = true;


  replaceable package MediumWater = IDEAS.Media.Water "Water medium";
  parameter Modelica.Units.SI.Area Atot = 998.8900000000001 "Total zone surface area";
  parameter Modelica.Units.SI.Area AtotExt = 3527.158147560989 "Total external wall/roof/window surface area";
  parameter Modelica.Units.SI.Volume VtotExt = 2796.8920000000003 "Total zone volume";
  parameter Modelica.Units.SI.Area AtotWin = 96.19369999999991 "Total window surface area";
  parameter Modelica.Units.SI.Power QDesignLoss = 32958.915756897375 "Total design heat loss through building envelope. Todo: Includes uninsulated outer walls of e.g. basement. Excludes slab on ground.";
  parameter Modelica.Units.SI.Power QDesignLossVentilation = 4700.001 "Total design heat loss through ventilation";
  parameter Modelica.Units.SI.Power QDesignLossInfiltration = 4212.119352 "Total design heat loss through air infiltration";
  parameter Modelica.Units.SI.HeatCapacity C = 902079234.2236762 "Total wall/floor/ceiling thermal mass. Includes parts exterior to insulation.";
  parameter Real n50 = 7.5 "Default n50 value"; // this value may not actually be used by the model, do not modify it unless you know what you're doing
  constant Modelica.Units.SI.Angle upAngle = IDEAS.Types.Azimuth.N + (1.2705060372917076);
  constant Modelica.Units.SI.Angle rightAngle = IDEAS.Types.Azimuth.E + (1.2705060372917076);
  constant Modelica.Units.SI.Angle downAngle = IDEAS.Types.Azimuth.S + (1.2705060372917076);
  constant Modelica.Units.SI.Angle leftAngle = IDEAS.Types.Azimuth.W + (1.2705060372917076);
  replaceable package MediumAir = IDEAS.Media.Specialized.DryAir "Air medium";
  constant Real mSenFac = 5;

  /// INTERNAL HEAT GAINS
  // Internal loads
  parameter Real q_internal_apartment=1000 "kWh/a/apartment";
  parameter Real p_internal_apartment=q_internal_apartment/8760*1000 "W/apartment";
  //
  parameter Real n_living=0.7 "share load living room";
  parameter Real n_bath=0.2 "share load bath room";
  parameter Real n_sleep=0.1 "share load sleeping room";
    // radiative
  parameter Real p_int_living_rad=p_internal_apartment*n_living*0.5 "radiative internal load living room";
  parameter Real p_int_bath_rad=p_internal_apartment*n_bath*0.5 "radiative internal load bath room";
  parameter Real p_int_sleep_rad=p_internal_apartment*n_sleep*0.5 "radiative internal load sleeping room";
  // convective
  parameter Real p_int_living_conv=p_internal_apartment*n_living*0.5 "convective internal load living room";
  parameter Real p_int_bath_conv=p_internal_apartment*n_bath*0.5 "convective internal load bath room";
  parameter Real p_int_sleep_conv=p_internal_apartment*n_sleep*0.5 "convective internal load sleeping room";

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_11_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_11_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_11_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_13_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_13_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_13_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_15_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_15_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_15_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_17_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_17_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_17_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_19_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_19_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_19_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_21_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_21_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_21_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_23_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_23_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_23_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_25_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_25_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_25_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_27_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_27_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_27_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_29_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_29_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_29_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_31_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_31_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_31_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_3_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_3_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_3_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_5_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_5_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_5_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_7_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_7_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_7_Slaapkamer_conv(Q_flow=p_int_sleep_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_9_Badkamer_conv(Q_flow=p_int_bath_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_9_Leefruimte_conv(Q_flow=p_int_living_conv);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_9_Slaapkamer_conv(Q_flow=p_int_sleep_conv);

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_11_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_11_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_11_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_13_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_13_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_13_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_15_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_15_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_15_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_17_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_17_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_17_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_19_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_19_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_19_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_21_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_21_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_21_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_23_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_23_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_23_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_25_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_25_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_25_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_27_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_27_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_27_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_29_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_29_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_29_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_31_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_31_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_31_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_3_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_3_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_3_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_5_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_5_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_5_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_7_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_7_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_7_Slaapkamer_rad(Q_flow=p_int_sleep_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_9_Badkamer_rad(Q_flow=p_int_bath_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_9_Leefruimte_rad(Q_flow=p_int_living_rad);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow_Huis_nr_9_Slaapkamer_rad(Q_flow=p_int_sleep_rad);

  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_11_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_11_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_11_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_11_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_11_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_11_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_13_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_13_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_13_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_13_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_13_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_13_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_15_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_15_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_15_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_15_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_15_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_15_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_17_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_17_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_17_Inkom = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_17_Inkom.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_17_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_17_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_17_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_17_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_19_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_19_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_19_Inkom = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_19_Inkom.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_19_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_19_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_19_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_19_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_21_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_21_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_21_Inkom = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_21_Inkom.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_21_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_21_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_21_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_21_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_23_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_23_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_23_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_23_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_23_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_23_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_25_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_25_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_25_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_25_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_25_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_25_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_27_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_27_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_27_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_27_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_27_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_27_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_29_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_29_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_29_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_29_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_29_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_29_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_31_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_31_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_31_Inkom = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_31_Inkom.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_31_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_31_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_31_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_31_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_3_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_3_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_3_Inkom = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_3_Inkom.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_3_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_3_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_3_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_3_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_5_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_5_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_5_Inkom = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_5_Inkom.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_5_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_5_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_5_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_5_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_7_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_7_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_7_Inkom = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_7_Inkom.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_7_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_7_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_7_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_7_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_9_Badkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_9_Badkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_9_Leefruimte = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_9_Leefruimte.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TCore_embeddedPipe_1_zone_Huis_nr_9_Slaapkamer = Modelica.Units.Conversions.to_degC(embeddedPipe_1_zone_Huis_nr_9_Slaapkamer.heatPortEmb[1].T) "EmbeddedPipe core temperature";
  output Modelica.Units.NonSI.Temperature_degC TDewPoi = Modelica.Units.Conversions.to_degC(sim.TDewPoi) "Dew point temperature";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Fietsenstalling_2_UC = Modelica.Units.Conversions.to_degC(zone__Fietsenstalling_2_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Fietsenstalling_UC = Modelica.Units.Conversions.to_degC(zone__Fietsenstalling_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_11_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_11_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_11_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_13_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_13_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_13_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_15_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_15_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_15_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_17_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_17_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Inkom.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_17_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_17_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_19_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_19_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Inkom.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_19_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_19_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_21_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_21_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Inkom.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_21_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_21_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_23_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_23_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_23_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_25_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_25_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_25_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_27_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_27_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_27_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_29_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_29_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_29_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_31_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_31_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Inkom.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_31_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_31_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_3_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_3_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Inkom.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_3_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_3_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_5_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_5_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Inkom.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_5_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_5_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_7_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_7_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Inkom.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_7_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_7_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_9_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Badkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_9_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Leefruimte.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Huis_nr_9_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Slaapkamer.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Inkom_tech_lokaal_1_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_lokaal_1_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Inkom_tech_lokaal_2_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_lokaal_2_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Inkom_tech_lokaal_3_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_lokaal_3_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Inkom_tech_ruimte_4_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_ruimte_4_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Inkom_tech_ruimte_5_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_ruimte_5_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Inkom_tech_ruimte_6_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_ruimte_6_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRad_zone__Technische_ruimte_BEO_UC = Modelica.Units.Conversions.to_degC(zone__Technische_ruimte_BEO_UC.TRad) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_11 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_11.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_13 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_13.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_15 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_15.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_17 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_17.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_19 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_19.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_21 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_21.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_23 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_23.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_25 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_25.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_27 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_27.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_29 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_29.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_3 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_3.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_31 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_31.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_5 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_5.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_7 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_7.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_airHandlingUnit__AHU_huis_nr_9 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_9.TRet) "";
  output Modelica.Units.NonSI.Temperature_degC TRet_collector__Heating_collector = Modelica.Units.Conversions.to_degC(collector__Heating_collector.TRet) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_11 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_11__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_13 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_13__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_15 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_15__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_17 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_17__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_19 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_19__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_21 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_21__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_23 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_23__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_25 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_25__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_27 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_27__valve.sta_a.T) "";
// output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_29 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_29__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_3 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_3__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_31 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_31__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_5 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_5__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_7 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_7__valve.sta_a.T) "";
//  output Modelica.Units.NonSI.Temperature_degC TRet_floorHeating__TABS_huis_nr_9 = Modelica.Units.Conversions.to_degC(floorHeating__TABS_huis_nr_9__valve.sta_a.T) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_11 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_11.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_13 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_13.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_15 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_15.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_17 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_17.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_19 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_19.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_21 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_21.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_23 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_23.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_25 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_25.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_27 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_27.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_29 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_29.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_3 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_3.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_31 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_31.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_5 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_5.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_7 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_7.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_airHandlingUnit__AHU_huis_nr_9 = Modelica.Units.Conversions.to_degC(airHandlingUnit__AHU_huis_nr_9.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC TSup_collector__Heating_collector = Modelica.Units.Conversions.to_degC(collector__Heating_collector.TSup) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Fietsenstalling_2_UC = Modelica.Units.Conversions.to_degC(zone__Fietsenstalling_2_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Fietsenstalling_UC = Modelica.Units.Conversions.to_degC(zone__Fietsenstalling_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_11_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_11_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_11_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_13_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_13_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_13_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_15_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_15_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_15_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_17_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_17_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Inkom.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_17_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_17_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_19_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_19_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Inkom.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_19_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_19_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_21_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_21_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Inkom.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_21_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_21_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_23_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_23_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_23_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_25_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_25_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_25_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_27_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_27_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_27_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_29_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_29_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_29_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_31_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_31_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Inkom.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_31_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_31_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_3_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_3_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Inkom.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_3_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_3_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_5_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_5_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Inkom.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_5_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_5_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_7_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_7_Inkom = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Inkom.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_7_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_7_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_9_Badkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Badkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_9_Leefruimte = Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Leefruimte.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Huis_nr_9_Slaapkamer = Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Slaapkamer.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Inkom_tech_lokaal_1_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_lokaal_1_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Inkom_tech_lokaal_2_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_lokaal_2_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Inkom_tech_lokaal_3_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_lokaal_3_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Inkom_tech_ruimte_4_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_ruimte_4_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Inkom_tech_ruimte_5_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_ruimte_5_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Inkom_tech_ruimte_6_UC = Modelica.Units.Conversions.to_degC(zone__Inkom_tech_ruimte_6_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC T_zone__Technische_ruimte_BEO_UC = Modelica.Units.Conversions.to_degC(zone__Technische_ruimte_BEO_UC.TSensor) "";
  output Modelica.Units.NonSI.Temperature_degC Te = Modelica.Units.Conversions.to_degC(sim.Te) "Outdoor air temperature";
  output Modelica.Units.NonSI.Temperature_degC Tsky = Modelica.Units.Conversions.to_degC(sim.Tsky) "Sky temperature";
  output Modelica.Units.SI.MassFlowRate m_flow_collector__Heating_collector = collector__Heating_collector.port_a2.m_flow "";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_11__valve = floorHeating__TABS_huis_nr_11__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 11'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_13__valve = floorHeating__TABS_huis_nr_13__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 13'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_15__valve = floorHeating__TABS_huis_nr_15__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 15'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_17__valve = floorHeating__TABS_huis_nr_17__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 17'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_19__valve = floorHeating__TABS_huis_nr_19__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 19'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_21__valve = floorHeating__TABS_huis_nr_21__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 21'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_23__valve = floorHeating__TABS_huis_nr_23__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 23'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_25__valve = floorHeating__TABS_huis_nr_25__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 25'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_27__valve = floorHeating__TABS_huis_nr_27__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 27'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_29__valve = floorHeating__TABS_huis_nr_29__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 29'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_31__valve = floorHeating__TABS_huis_nr_31__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 31'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_3__valve = floorHeating__TABS_huis_nr_3__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 3'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_5__valve = floorHeating__TABS_huis_nr_5__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 5'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_7__valve = floorHeating__TABS_huis_nr_7__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 7'";
  output Modelica.Units.SI.MassFlowRate m_flow_floorHeating__TABS_huis_nr_9__valve = floorHeating__TABS_huis_nr_9__valve.m_flow "Total mass flow rate for all assignments of 'TABS - huis nr 9'";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_11 = sum(airHandlingUnit__AHU_huis_nr_11.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_13 = sum(airHandlingUnit__AHU_huis_nr_13.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_15 = sum(airHandlingUnit__AHU_huis_nr_15.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_17 = sum(airHandlingUnit__AHU_huis_nr_17.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_19 = sum(airHandlingUnit__AHU_huis_nr_19.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_21 = sum(airHandlingUnit__AHU_huis_nr_21.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_23 = sum(airHandlingUnit__AHU_huis_nr_23.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_25 = sum(airHandlingUnit__AHU_huis_nr_25.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_27 = sum(airHandlingUnit__AHU_huis_nr_27.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_29 = sum(airHandlingUnit__AHU_huis_nr_29.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_3 = sum(airHandlingUnit__AHU_huis_nr_3.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_31 = sum(airHandlingUnit__AHU_huis_nr_31.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_5 = sum(airHandlingUnit__AHU_huis_nr_5.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_7 = sum(airHandlingUnit__AHU_huis_nr_7.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_ret_airHandlingUnit__AHU_huis_nr_9 = sum(airHandlingUnit__AHU_huis_nr_9.port_a.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_11 = sum(-airHandlingUnit__AHU_huis_nr_11.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_13 = sum(-airHandlingUnit__AHU_huis_nr_13.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_15 = sum(-airHandlingUnit__AHU_huis_nr_15.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_17 = sum(-airHandlingUnit__AHU_huis_nr_17.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_19 = sum(-airHandlingUnit__AHU_huis_nr_19.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_21 = sum(-airHandlingUnit__AHU_huis_nr_21.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_23 = sum(-airHandlingUnit__AHU_huis_nr_23.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_25 = sum(-airHandlingUnit__AHU_huis_nr_25.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_27 = sum(-airHandlingUnit__AHU_huis_nr_27.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_29 = sum(-airHandlingUnit__AHU_huis_nr_29.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_3 = sum(-airHandlingUnit__AHU_huis_nr_3.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_31 = sum(-airHandlingUnit__AHU_huis_nr_31.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_5 = sum(-airHandlingUnit__AHU_huis_nr_5.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_7 = sum(-airHandlingUnit__AHU_huis_nr_7.port_b.m_flow) "";
  output Modelica.Units.SI.MassFlowRate m_flow_sup_airHandlingUnit__AHU_huis_nr_9 = sum(-airHandlingUnit__AHU_huis_nr_9.port_b.m_flow) "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23 = (cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23.port_b.h_outflow-zone__Huis_nr_11_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2 = (cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2.port_b.h_outflow-zone__Huis_nr_13_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3 = (cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3.port_b.h_outflow-zone__Huis_nr_15_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5 = (cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5.port_b.h_outflow-zone__Huis_nr_17_Inkom.ports[1].h_outflow)*cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4 = (cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4.port_b.h_outflow-zone__Huis_nr_17_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7 = (cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7.port_b.h_outflow-zone__Huis_nr_19_Inkom.ports[1].h_outflow)*cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6 = (cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6.port_b.h_outflow-zone__Huis_nr_19_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8 = (cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8.port_b.h_outflow-zone__Huis_nr_21_Inkom.ports[1].h_outflow)*cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9 = (cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9.port_b.h_outflow-zone__Huis_nr_21_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10 = (cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10.port_b.h_outflow-zone__Huis_nr_23_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14 = (cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14.port_b.h_outflow-zone__Huis_nr_25_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13 = (cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13.port_b.h_outflow-zone__Huis_nr_27_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11 = (cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11.port_b.h_outflow-zone__Huis_nr_29_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12 = (cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12.port_b.h_outflow-zone__Huis_nr_31_Inkom.ports[1].h_outflow)*cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12 = (cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12.port_b.h_outflow-zone__Huis_nr_31_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16 = (cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16.port_b.h_outflow-zone__Huis_nr_3_Inkom.ports[1].h_outflow)*cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15 = (cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15.port_b.h_outflow-zone__Huis_nr_3_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18 = (cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18.port_b.h_outflow-zone__Huis_nr_5_Inkom.ports[1].h_outflow)*cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19 = (cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19.port_b.h_outflow-zone__Huis_nr_5_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21 = (cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21.port_b.h_outflow-zone__Huis_nr_7_Inkom.ports[1].h_outflow)*cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20 = (cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20.port_b.h_outflow-zone__Huis_nr_7_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22 = (cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22.port_b.h_outflow-zone__Huis_nr_9_Leefruimte.ports[1].h_outflow)*cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_collector__Heating_collector = collector__Heating_collector.Q_flow "collector__Heating_collector thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_11_Badkamer = -embeddedPipe_1_zone_Huis_nr_11_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_11_Leefruimte = -embeddedPipe_1_zone_Huis_nr_11_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_11_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_11_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_13_Badkamer = -embeddedPipe_1_zone_Huis_nr_13_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_13_Leefruimte = -embeddedPipe_1_zone_Huis_nr_13_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_13_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_13_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_15_Badkamer = -embeddedPipe_1_zone_Huis_nr_15_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_15_Leefruimte = -embeddedPipe_1_zone_Huis_nr_15_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_15_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_15_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_17_Badkamer = -embeddedPipe_1_zone_Huis_nr_17_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_17_Inkom = -embeddedPipe_1_zone_Huis_nr_17_Inkom.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_17_Leefruimte = -embeddedPipe_1_zone_Huis_nr_17_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_17_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_17_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_19_Badkamer = -embeddedPipe_1_zone_Huis_nr_19_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_19_Inkom = -embeddedPipe_1_zone_Huis_nr_19_Inkom.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_19_Leefruimte = -embeddedPipe_1_zone_Huis_nr_19_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_19_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_19_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_21_Badkamer = -embeddedPipe_1_zone_Huis_nr_21_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_21_Inkom = -embeddedPipe_1_zone_Huis_nr_21_Inkom.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_21_Leefruimte = -embeddedPipe_1_zone_Huis_nr_21_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_21_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_21_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_23_Badkamer = -embeddedPipe_1_zone_Huis_nr_23_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_23_Leefruimte = -embeddedPipe_1_zone_Huis_nr_23_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_23_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_23_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_25_Badkamer = -embeddedPipe_1_zone_Huis_nr_25_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_25_Leefruimte = -embeddedPipe_1_zone_Huis_nr_25_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_25_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_25_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_27_Badkamer = -embeddedPipe_1_zone_Huis_nr_27_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_27_Leefruimte = -embeddedPipe_1_zone_Huis_nr_27_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_27_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_27_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_29_Badkamer = -embeddedPipe_1_zone_Huis_nr_29_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_29_Leefruimte = -embeddedPipe_1_zone_Huis_nr_29_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_29_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_29_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_31_Badkamer = -embeddedPipe_1_zone_Huis_nr_31_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_31_Inkom = -embeddedPipe_1_zone_Huis_nr_31_Inkom.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_31_Leefruimte = -embeddedPipe_1_zone_Huis_nr_31_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_31_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_31_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_3_Badkamer = -embeddedPipe_1_zone_Huis_nr_3_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_3_Inkom = -embeddedPipe_1_zone_Huis_nr_3_Inkom.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_3_Leefruimte = -embeddedPipe_1_zone_Huis_nr_3_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_3_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_3_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_5_Badkamer = -embeddedPipe_1_zone_Huis_nr_5_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_5_Inkom = -embeddedPipe_1_zone_Huis_nr_5_Inkom.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_5_Leefruimte = -embeddedPipe_1_zone_Huis_nr_5_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_5_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_5_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_7_Badkamer = -embeddedPipe_1_zone_Huis_nr_7_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_7_Inkom = -embeddedPipe_1_zone_Huis_nr_7_Inkom.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_7_Leefruimte = -embeddedPipe_1_zone_Huis_nr_7_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_7_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_7_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_9_Badkamer = -embeddedPipe_1_zone_Huis_nr_9_Badkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_9_Leefruimte = -embeddedPipe_1_zone_Huis_nr_9_Leefruimte.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_embeddedPipe_1_zone_Huis_nr_9_Slaapkamer = -embeddedPipe_1_zone_Huis_nr_9_Slaapkamer.heatPortEmb[1].Q_flow "EmbeddedPipe thermal power";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15 = (supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15.port_b.h_outflow-zone__Huis_nr_11_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1 = (supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1.port_b.h_outflow-zone__Huis_nr_13_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2 = (supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2.port_b.h_outflow-zone__Huis_nr_15_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3 = (supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3.port_b.h_outflow-zone__Huis_nr_17_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4 = (supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4.port_b.h_outflow-zone__Huis_nr_19_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5 = (supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5.port_b.h_outflow-zone__Huis_nr_21_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6 = (supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6.port_b.h_outflow-zone__Huis_nr_23_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10 = (supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10.port_b.h_outflow-zone__Huis_nr_25_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9 = (supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9.port_b.h_outflow-zone__Huis_nr_27_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7 = (supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7.port_b.h_outflow-zone__Huis_nr_29_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8 = (supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8.port_b.h_outflow-zone__Huis_nr_31_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11 = (supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11.port_b.h_outflow-zone__Huis_nr_3_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12 = (supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12.port_b.h_outflow-zone__Huis_nr_5_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13 = (supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13.port_b.h_outflow-zone__Huis_nr_7_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14 = (supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14.port_b.h_outflow-zone__Huis_nr_9_Slaapkamer.ports[1].h_outflow)*supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14.port_a.m_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1 = -window__Window_1.gain.iSolDir.port_b.Q_flow-window__Window_1.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1__2 = -window__Window_1__2.gain.iSolDir.port_b.Q_flow-window__Window_1__2.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1__3 = -window__Window_1__3.gain.iSolDir.port_b.Q_flow-window__Window_1__3.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1__4 = -window__Window_1__4.gain.iSolDir.port_b.Q_flow-window__Window_1__4.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1__5 = -window__Window_1__5.gain.iSolDir.port_b.Q_flow-window__Window_1__5.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1__6 = -window__Window_1__6.gain.iSolDir.port_b.Q_flow-window__Window_1__6.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1__7 = -window__Window_1__7.gain.iSolDir.port_b.Q_flow-window__Window_1__7.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_1__8 = -window__Window_1__8.gain.iSolDir.port_b.Q_flow-window__Window_1__8.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2 = -window__Window_2.gain.iSolDir.port_b.Q_flow-window__Window_2.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__10 = -window__Window_2__10.gain.iSolDir.port_b.Q_flow-window__Window_2__10.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__11 = -window__Window_2__11.gain.iSolDir.port_b.Q_flow-window__Window_2__11.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__12 = -window__Window_2__12.gain.iSolDir.port_b.Q_flow-window__Window_2__12.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__13 = -window__Window_2__13.gain.iSolDir.port_b.Q_flow-window__Window_2__13.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__14 = -window__Window_2__14.gain.iSolDir.port_b.Q_flow-window__Window_2__14.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__15 = -window__Window_2__15.gain.iSolDir.port_b.Q_flow-window__Window_2__15.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__16 = -window__Window_2__16.gain.iSolDir.port_b.Q_flow-window__Window_2__16.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__17 = -window__Window_2__17.gain.iSolDir.port_b.Q_flow-window__Window_2__17.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__18 = -window__Window_2__18.gain.iSolDir.port_b.Q_flow-window__Window_2__18.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__19 = -window__Window_2__19.gain.iSolDir.port_b.Q_flow-window__Window_2__19.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__2 = -window__Window_2__2.gain.iSolDir.port_b.Q_flow-window__Window_2__2.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__20 = -window__Window_2__20.gain.iSolDir.port_b.Q_flow-window__Window_2__20.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__21 = -window__Window_2__21.gain.iSolDir.port_b.Q_flow-window__Window_2__21.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__22 = -window__Window_2__22.gain.iSolDir.port_b.Q_flow-window__Window_2__22.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__23 = -window__Window_2__23.gain.iSolDir.port_b.Q_flow-window__Window_2__23.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__3 = -window__Window_2__3.gain.iSolDir.port_b.Q_flow-window__Window_2__3.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__4 = -window__Window_2__4.gain.iSolDir.port_b.Q_flow-window__Window_2__4.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__5 = -window__Window_2__5.gain.iSolDir.port_b.Q_flow-window__Window_2__5.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__6 = -window__Window_2__6.gain.iSolDir.port_b.Q_flow-window__Window_2__6.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__7 = -window__Window_2__7.gain.iSolDir.port_b.Q_flow-window__Window_2__7.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__8 = -window__Window_2__8.gain.iSolDir.port_b.Q_flow-window__Window_2__8.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_2__9 = -window__Window_2__9.gain.iSolDir.port_b.Q_flow-window__Window_2__9.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3 = -window__Window_3.gain.iSolDir.port_b.Q_flow-window__Window_3.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__2 = -window__Window_3__2.gain.iSolDir.port_b.Q_flow-window__Window_3__2.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__3 = -window__Window_3__3.gain.iSolDir.port_b.Q_flow-window__Window_3__3.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__4 = -window__Window_3__4.gain.iSolDir.port_b.Q_flow-window__Window_3__4.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__5 = -window__Window_3__5.gain.iSolDir.port_b.Q_flow-window__Window_3__5.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__6 = -window__Window_3__6.gain.iSolDir.port_b.Q_flow-window__Window_3__6.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__7 = -window__Window_3__7.gain.iSolDir.port_b.Q_flow-window__Window_3__7.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__8 = -window__Window_3__8.gain.iSolDir.port_b.Q_flow-window__Window_3__8.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_3__9 = -window__Window_3__9.gain.iSolDir.port_b.Q_flow-window__Window_3__9.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4 = -window__Window_4.gain.iSolDir.port_b.Q_flow-window__Window_4.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__10 = -window__Window_4__10.gain.iSolDir.port_b.Q_flow-window__Window_4__10.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__11 = -window__Window_4__11.gain.iSolDir.port_b.Q_flow-window__Window_4__11.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__12 = -window__Window_4__12.gain.iSolDir.port_b.Q_flow-window__Window_4__12.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__13 = -window__Window_4__13.gain.iSolDir.port_b.Q_flow-window__Window_4__13.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__14 = -window__Window_4__14.gain.iSolDir.port_b.Q_flow-window__Window_4__14.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__15 = -window__Window_4__15.gain.iSolDir.port_b.Q_flow-window__Window_4__15.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__16 = -window__Window_4__16.gain.iSolDir.port_b.Q_flow-window__Window_4__16.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__2 = -window__Window_4__2.gain.iSolDir.port_b.Q_flow-window__Window_4__2.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__3 = -window__Window_4__3.gain.iSolDir.port_b.Q_flow-window__Window_4__3.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__4 = -window__Window_4__4.gain.iSolDir.port_b.Q_flow-window__Window_4__4.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__5 = -window__Window_4__5.gain.iSolDir.port_b.Q_flow-window__Window_4__5.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__6 = -window__Window_4__6.gain.iSolDir.port_b.Q_flow-window__Window_4__6.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__7 = -window__Window_4__7.gain.iSolDir.port_b.Q_flow-window__Window_4__7.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__8 = -window__Window_4__8.gain.iSolDir.port_b.Q_flow-window__Window_4__8.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_4__9 = -window__Window_4__9.gain.iSolDir.port_b.Q_flow-window__Window_4__9.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5 = -window__Window_5.gain.iSolDir.port_b.Q_flow-window__Window_5.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5__2 = -window__Window_5__2.gain.iSolDir.port_b.Q_flow-window__Window_5__2.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5__3 = -window__Window_5__3.gain.iSolDir.port_b.Q_flow-window__Window_5__3.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5__4 = -window__Window_5__4.gain.iSolDir.port_b.Q_flow-window__Window_5__4.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5__5 = -window__Window_5__5.gain.iSolDir.port_b.Q_flow-window__Window_5__5.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5__6 = -window__Window_5__6.gain.iSolDir.port_b.Q_flow-window__Window_5__6.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5__7 = -window__Window_5__7.gain.iSolDir.port_b.Q_flow-window__Window_5__7.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_5__8 = -window__Window_5__8.gain.iSolDir.port_b.Q_flow-window__Window_5__8.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_6 = -window__Window_6.gain.iSolDir.port_b.Q_flow-window__Window_6.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_7 = -window__Window_7.gain.iSolDir.port_b.Q_flow-window__Window_7.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.Power Q_flow_window__Window_8 = -window__Window_8.gain.iSolDir.port_b.Q_flow-window__Window_8.gain.iSolDif.port_b.Q_flow "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23(displayUnit="m3/h") = cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2(displayUnit="m3/h") = cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3(displayUnit="m3/h") = cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5(displayUnit="m3/h") = cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4(displayUnit="m3/h") = cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7(displayUnit="m3/h") = cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6(displayUnit="m3/h") = cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8(displayUnit="m3/h") = cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9(displayUnit="m3/h") = cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10(displayUnit="m3/h") = cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14(displayUnit="m3/h") = cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13(displayUnit="m3/h") = cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11(displayUnit="m3/h") = cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12(displayUnit="m3/h") = cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12(displayUnit="m3/h") = cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16(displayUnit="m3/h") = cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15(displayUnit="m3/h") = cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18(displayUnit="m3/h") = cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19(displayUnit="m3/h") = cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21(displayUnit="m3/h") = cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20(displayUnit="m3/h") = cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22(displayUnit="m3/h") = cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_11_Badkamer__CAVr_type_15(displayUnit="m3/h") = returnCav_zone__Huis_nr_11_Badkamer__CAVr_type_15.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_13_Badkamer__CAVr_type_1(displayUnit="m3/h") = returnCav_zone__Huis_nr_13_Badkamer__CAVr_type_1.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_15_Badkamer__CAVr_type_2(displayUnit="m3/h") = returnCav_zone__Huis_nr_15_Badkamer__CAVr_type_2.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_17_Badkamer__CAVr_type_3(displayUnit="m3/h") = returnCav_zone__Huis_nr_17_Badkamer__CAVr_type_3.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_19_Badkamer__CAVr_type_4(displayUnit="m3/h") = returnCav_zone__Huis_nr_19_Badkamer__CAVr_type_4.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_21_Badkamer__CAVr_type_5(displayUnit="m3/h") = returnCav_zone__Huis_nr_21_Badkamer__CAVr_type_5.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_23_Badkamer__CAVr_type_6(displayUnit="m3/h") = returnCav_zone__Huis_nr_23_Badkamer__CAVr_type_6.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_25_Badkamer__CAVr_type_10(displayUnit="m3/h") = returnCav_zone__Huis_nr_25_Badkamer__CAVr_type_10.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_27_Badkamer__CAVr_type_9(displayUnit="m3/h") = returnCav_zone__Huis_nr_27_Badkamer__CAVr_type_9.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_29_Badkamer__CAVr_type_7(displayUnit="m3/h") = returnCav_zone__Huis_nr_29_Badkamer__CAVr_type_7.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_31_Badkamer__CAVr_type_8(displayUnit="m3/h") = returnCav_zone__Huis_nr_31_Badkamer__CAVr_type_8.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_3_Badkamer__CAVr_type_11(displayUnit="m3/h") = returnCav_zone__Huis_nr_3_Badkamer__CAVr_type_11.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_5_Badkamer__CAVr_type_12(displayUnit="m3/h") = returnCav_zone__Huis_nr_5_Badkamer__CAVr_type_12.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_7_Badkamer__CAVr_type_13(displayUnit="m3/h") = returnCav_zone__Huis_nr_7_Badkamer__CAVr_type_13.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_returnCav_zone__Huis_nr_9_Badkamer__CAVr_type_14(displayUnit="m3/h") = returnCav_zone__Huis_nr_9_Badkamer__CAVr_type_14.port_a.m_flow/1.2*3600 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15(displayUnit="m3/h") = supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1(displayUnit="m3/h") = supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2(displayUnit="m3/h") = supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3(displayUnit="m3/h") = supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4(displayUnit="m3/h") = supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5(displayUnit="m3/h") = supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6(displayUnit="m3/h") = supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10(displayUnit="m3/h") = supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9(displayUnit="m3/h") = supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7(displayUnit="m3/h") = supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8(displayUnit="m3/h") = supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11(displayUnit="m3/h") = supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12(displayUnit="m3/h") = supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13(displayUnit="m3/h") = supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13.port_a.m_flow*3600/1.2 "";
  output Modelica.Units.SI.VolumeFlowRate V_flow_supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14(displayUnit="m3/h") = supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14.port_a.m_flow*3600/1.2 "";
  output Real HDifHor = sim.HDifHor.y "Diffuse solar irradiation on a horizontal surface";
  output Real HDirNor = sim.HDirNor.y "Direct normal/beam solar irradiation";
  output Real HGloE = sim.weaBus.solBus[3].HDirTil + sim.radSol[3].HDifTil.HGroDifTil + sim.radSol[3].HDifTil.HSkyDifTil "Total solar irradiation on the east (left in FS, including offset) oriented surface";
  output Real HGloHor = sim.weaBus.solBus[1].HDirTil + sim.radSol[1].HDifTil.HGroDifTil + sim.radSol[1].HDifTil.HSkyDifTil "Total solar irradiation on horizontal surfaces";
  output Real HGloN = sim.weaBus.solBus[2].HDirTil + sim.radSol[2].HDifTil.HGroDifTil + sim.radSol[2].HDifTil.HSkyDifTil "Total solar irradiation on the north (downward in FS, including offset) oriented surface";
  output Real HGloS = sim.weaBus.solBus[4].HDirTil + sim.radSol[4].HDifTil.HGroDifTil + sim.radSol[4].HDifTil.HSkyDifTil "Total solar irradiation on the south (up in FS, including offset) oriented surface";
  output Real HGloW = sim.weaBus.solBus[5].HDirTil + sim.radSol[5].HDifTil.HGroDifTil + sim.radSol[5].HDifTil.HSkyDifTil "Total solar irradiation on the west (right in FS, including offset) oriented surface";
  output Real HSha_window__Window_1 = window__Window_1.shaType.HSha "Total solar irradiance through 'window__Window_1'";
  output Real HSha_window__Window_1__2 = window__Window_1__2.shaType.HSha "Total solar irradiance through 'window__Window_1__2'";
  output Real HSha_window__Window_1__3 = window__Window_1__3.shaType.HSha "Total solar irradiance through 'window__Window_1__3'";
  output Real HSha_window__Window_1__4 = window__Window_1__4.shaType.HSha "Total solar irradiance through 'window__Window_1__4'";
  output Real HSha_window__Window_1__5 = window__Window_1__5.shaType.HSha "Total solar irradiance through 'window__Window_1__5'";
  output Real HSha_window__Window_1__6 = window__Window_1__6.shaType.HSha "Total solar irradiance through 'window__Window_1__6'";
  output Real HSha_window__Window_1__7 = window__Window_1__7.shaType.HSha "Total solar irradiance through 'window__Window_1__7'";
  output Real HSha_window__Window_1__8 = window__Window_1__8.shaType.HSha "Total solar irradiance through 'window__Window_1__8'";
  output Real HSha_window__Window_2 = window__Window_2.shaType.HSha "Total solar irradiance through 'window__Window_2'";
  output Real HSha_window__Window_2__10 = window__Window_2__10.shaType.HSha "Total solar irradiance through 'window__Window_2__10'";
  output Real HSha_window__Window_2__11 = window__Window_2__11.shaType.HSha "Total solar irradiance through 'window__Window_2__11'";
  output Real HSha_window__Window_2__12 = window__Window_2__12.shaType.HSha "Total solar irradiance through 'window__Window_2__12'";
  output Real HSha_window__Window_2__13 = window__Window_2__13.shaType.HSha "Total solar irradiance through 'window__Window_2__13'";
  output Real HSha_window__Window_2__14 = window__Window_2__14.shaType.HSha "Total solar irradiance through 'window__Window_2__14'";
  output Real HSha_window__Window_2__15 = window__Window_2__15.shaType.HSha "Total solar irradiance through 'window__Window_2__15'";
  output Real HSha_window__Window_2__16 = window__Window_2__16.shaType.HSha "Total solar irradiance through 'window__Window_2__16'";
  output Real HSha_window__Window_2__17 = window__Window_2__17.shaType.HSha "Total solar irradiance through 'window__Window_2__17'";
  output Real HSha_window__Window_2__18 = window__Window_2__18.shaType.HSha "Total solar irradiance through 'window__Window_2__18'";
  output Real HSha_window__Window_2__19 = window__Window_2__19.shaType.HSha "Total solar irradiance through 'window__Window_2__19'";
  output Real HSha_window__Window_2__2 = window__Window_2__2.shaType.HSha "Total solar irradiance through 'window__Window_2__2'";
  output Real HSha_window__Window_2__20 = window__Window_2__20.shaType.HSha "Total solar irradiance through 'window__Window_2__20'";
  output Real HSha_window__Window_2__21 = window__Window_2__21.shaType.HSha "Total solar irradiance through 'window__Window_2__21'";
  output Real HSha_window__Window_2__22 = window__Window_2__22.shaType.HSha "Total solar irradiance through 'window__Window_2__22'";
  output Real HSha_window__Window_2__23 = window__Window_2__23.shaType.HSha "Total solar irradiance through 'window__Window_2__23'";
  output Real HSha_window__Window_2__3 = window__Window_2__3.shaType.HSha "Total solar irradiance through 'window__Window_2__3'";
  output Real HSha_window__Window_2__4 = window__Window_2__4.shaType.HSha "Total solar irradiance through 'window__Window_2__4'";
  output Real HSha_window__Window_2__5 = window__Window_2__5.shaType.HSha "Total solar irradiance through 'window__Window_2__5'";
  output Real HSha_window__Window_2__6 = window__Window_2__6.shaType.HSha "Total solar irradiance through 'window__Window_2__6'";
  output Real HSha_window__Window_2__7 = window__Window_2__7.shaType.HSha "Total solar irradiance through 'window__Window_2__7'";
  output Real HSha_window__Window_2__8 = window__Window_2__8.shaType.HSha "Total solar irradiance through 'window__Window_2__8'";
  output Real HSha_window__Window_2__9 = window__Window_2__9.shaType.HSha "Total solar irradiance through 'window__Window_2__9'";
  output Real HSha_window__Window_3 = window__Window_3.shaType.HSha "Total solar irradiance through 'window__Window_3'";
  output Real HSha_window__Window_3__2 = window__Window_3__2.shaType.HSha "Total solar irradiance through 'window__Window_3__2'";
  output Real HSha_window__Window_3__3 = window__Window_3__3.shaType.HSha "Total solar irradiance through 'window__Window_3__3'";
  output Real HSha_window__Window_3__4 = window__Window_3__4.shaType.HSha "Total solar irradiance through 'window__Window_3__4'";
  output Real HSha_window__Window_3__5 = window__Window_3__5.shaType.HSha "Total solar irradiance through 'window__Window_3__5'";
  output Real HSha_window__Window_3__6 = window__Window_3__6.shaType.HSha "Total solar irradiance through 'window__Window_3__6'";
  output Real HSha_window__Window_3__7 = window__Window_3__7.shaType.HSha "Total solar irradiance through 'window__Window_3__7'";
  output Real HSha_window__Window_3__8 = window__Window_3__8.shaType.HSha "Total solar irradiance through 'window__Window_3__8'";
  output Real HSha_window__Window_3__9 = window__Window_3__9.shaType.HSha "Total solar irradiance through 'window__Window_3__9'";
  output Real HSha_window__Window_4 = window__Window_4.shaType.HSha "Total solar irradiance through 'window__Window_4'";
  output Real HSha_window__Window_4__10 = window__Window_4__10.shaType.HSha "Total solar irradiance through 'window__Window_4__10'";
  output Real HSha_window__Window_4__11 = window__Window_4__11.shaType.HSha "Total solar irradiance through 'window__Window_4__11'";
  output Real HSha_window__Window_4__12 = window__Window_4__12.shaType.HSha "Total solar irradiance through 'window__Window_4__12'";
  output Real HSha_window__Window_4__13 = window__Window_4__13.shaType.HSha "Total solar irradiance through 'window__Window_4__13'";
  output Real HSha_window__Window_4__14 = window__Window_4__14.shaType.HSha "Total solar irradiance through 'window__Window_4__14'";
  output Real HSha_window__Window_4__15 = window__Window_4__15.shaType.HSha "Total solar irradiance through 'window__Window_4__15'";
  output Real HSha_window__Window_4__16 = window__Window_4__16.shaType.HSha "Total solar irradiance through 'window__Window_4__16'";
  output Real HSha_window__Window_4__2 = window__Window_4__2.shaType.HSha "Total solar irradiance through 'window__Window_4__2'";
  output Real HSha_window__Window_4__3 = window__Window_4__3.shaType.HSha "Total solar irradiance through 'window__Window_4__3'";
  output Real HSha_window__Window_4__4 = window__Window_4__4.shaType.HSha "Total solar irradiance through 'window__Window_4__4'";
  output Real HSha_window__Window_4__5 = window__Window_4__5.shaType.HSha "Total solar irradiance through 'window__Window_4__5'";
  output Real HSha_window__Window_4__6 = window__Window_4__6.shaType.HSha "Total solar irradiance through 'window__Window_4__6'";
  output Real HSha_window__Window_4__7 = window__Window_4__7.shaType.HSha "Total solar irradiance through 'window__Window_4__7'";
  output Real HSha_window__Window_4__8 = window__Window_4__8.shaType.HSha "Total solar irradiance through 'window__Window_4__8'";
  output Real HSha_window__Window_4__9 = window__Window_4__9.shaType.HSha "Total solar irradiance through 'window__Window_4__9'";
  output Real HSha_window__Window_5 = window__Window_5.shaType.HSha "Total solar irradiance through 'window__Window_5'";
  output Real HSha_window__Window_5__2 = window__Window_5__2.shaType.HSha "Total solar irradiance through 'window__Window_5__2'";
  output Real HSha_window__Window_5__3 = window__Window_5__3.shaType.HSha "Total solar irradiance through 'window__Window_5__3'";
  output Real HSha_window__Window_5__4 = window__Window_5__4.shaType.HSha "Total solar irradiance through 'window__Window_5__4'";
  output Real HSha_window__Window_5__5 = window__Window_5__5.shaType.HSha "Total solar irradiance through 'window__Window_5__5'";
  output Real HSha_window__Window_5__6 = window__Window_5__6.shaType.HSha "Total solar irradiance through 'window__Window_5__6'";
  output Real HSha_window__Window_5__7 = window__Window_5__7.shaType.HSha "Total solar irradiance through 'window__Window_5__7'";
  output Real HSha_window__Window_5__8 = window__Window_5__8.shaType.HSha "Total solar irradiance through 'window__Window_5__8'";
  output Real HSha_window__Window_6 = window__Window_6.shaType.HSha "Total solar irradiance through 'window__Window_6'";
  output Real HSha_window__Window_7 = window__Window_7.shaType.HSha "Total solar irradiance through 'window__Window_7'";
  output Real HSha_window__Window_8 = window__Window_8.shaType.HSha "Total solar irradiance through 'window__Window_8'";
  output Real P_AHUs_Schema_Sts = obj__PRet_airHandlingUnit__AHU_huis_nr_11
  + obj__PRet_airHandlingUnit__AHU_huis_nr_13
  + obj__PRet_airHandlingUnit__AHU_huis_nr_15
  + obj__PRet_airHandlingUnit__AHU_huis_nr_17
  + obj__PRet_airHandlingUnit__AHU_huis_nr_19
  + obj__PRet_airHandlingUnit__AHU_huis_nr_21
  + obj__PRet_airHandlingUnit__AHU_huis_nr_23
  + obj__PRet_airHandlingUnit__AHU_huis_nr_25
  + obj__PRet_airHandlingUnit__AHU_huis_nr_27
  + obj__PRet_airHandlingUnit__AHU_huis_nr_29
  + obj__PRet_airHandlingUnit__AHU_huis_nr_3
  + obj__PRet_airHandlingUnit__AHU_huis_nr_31
  + obj__PRet_airHandlingUnit__AHU_huis_nr_5
  + obj__PRet_airHandlingUnit__AHU_huis_nr_7
  + obj__PRet_airHandlingUnit__AHU_huis_nr_9
  + obj__PSup_airHandlingUnit__AHU_huis_nr_11
  + obj__PSup_airHandlingUnit__AHU_huis_nr_13
  + obj__PSup_airHandlingUnit__AHU_huis_nr_15
  + obj__PSup_airHandlingUnit__AHU_huis_nr_17
  + obj__PSup_airHandlingUnit__AHU_huis_nr_19
  + obj__PSup_airHandlingUnit__AHU_huis_nr_21
  + obj__PSup_airHandlingUnit__AHU_huis_nr_23
  + obj__PSup_airHandlingUnit__AHU_huis_nr_25
  + obj__PSup_airHandlingUnit__AHU_huis_nr_27
  + obj__PSup_airHandlingUnit__AHU_huis_nr_29
  + obj__PSup_airHandlingUnit__AHU_huis_nr_3
  + obj__PSup_airHandlingUnit__AHU_huis_nr_31
  + obj__PSup_airHandlingUnit__AHU_huis_nr_5
  + obj__PSup_airHandlingUnit__AHU_huis_nr_7
  + obj__PSup_airHandlingUnit__AHU_huis_nr_9 "Total electrical power for 'Schema_Sts'";
  output Real PFan_airHandlingUnit__AHU_huis_nr_11 = airHandlingUnit__AHU_huis_nr_11.PSup + airHandlingUnit__AHU_huis_nr_11.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_13 = airHandlingUnit__AHU_huis_nr_13.PSup + airHandlingUnit__AHU_huis_nr_13.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_15 = airHandlingUnit__AHU_huis_nr_15.PSup + airHandlingUnit__AHU_huis_nr_15.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_17 = airHandlingUnit__AHU_huis_nr_17.PSup + airHandlingUnit__AHU_huis_nr_17.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_19 = airHandlingUnit__AHU_huis_nr_19.PSup + airHandlingUnit__AHU_huis_nr_19.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_21 = airHandlingUnit__AHU_huis_nr_21.PSup + airHandlingUnit__AHU_huis_nr_21.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_23 = airHandlingUnit__AHU_huis_nr_23.PSup + airHandlingUnit__AHU_huis_nr_23.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_25 = airHandlingUnit__AHU_huis_nr_25.PSup + airHandlingUnit__AHU_huis_nr_25.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_27 = airHandlingUnit__AHU_huis_nr_27.PSup + airHandlingUnit__AHU_huis_nr_27.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_29 = airHandlingUnit__AHU_huis_nr_29.PSup + airHandlingUnit__AHU_huis_nr_29.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_3 = airHandlingUnit__AHU_huis_nr_3.PSup + airHandlingUnit__AHU_huis_nr_3.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_31 = airHandlingUnit__AHU_huis_nr_31.PSup + airHandlingUnit__AHU_huis_nr_31.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_5 = airHandlingUnit__AHU_huis_nr_5.PSup + airHandlingUnit__AHU_huis_nr_5.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_7 = airHandlingUnit__AHU_huis_nr_7.PSup + airHandlingUnit__AHU_huis_nr_7.PRet "";
  output Real PFan_airHandlingUnit__AHU_huis_nr_9 = airHandlingUnit__AHU_huis_nr_9.PSup + airHandlingUnit__AHU_huis_nr_9.PRet "";
  output Real RH = sim.XiEnv.phi "Outdoor relative humidity";
  output Real Xw = sim.XiEnv.X[1] "Outdoor absolute humidity";
  output Real hour = clock__1.hour "Hour [0,24) in local time zone";
  output Real objInt = pEl_Schema_Sts;
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_11 = airHandlingUnit__AHU_huis_nr_11.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_13 = airHandlingUnit__AHU_huis_nr_13.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_15 = airHandlingUnit__AHU_huis_nr_15.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_17 = airHandlingUnit__AHU_huis_nr_17.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_19 = airHandlingUnit__AHU_huis_nr_19.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_21 = airHandlingUnit__AHU_huis_nr_21.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_23 = airHandlingUnit__AHU_huis_nr_23.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_25 = airHandlingUnit__AHU_huis_nr_25.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_27 = airHandlingUnit__AHU_huis_nr_27.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_29 = airHandlingUnit__AHU_huis_nr_29.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_3 = airHandlingUnit__AHU_huis_nr_3.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_31 = airHandlingUnit__AHU_huis_nr_31.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_5 = airHandlingUnit__AHU_huis_nr_5.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_7 = airHandlingUnit__AHU_huis_nr_7.PRet "";
  output Real obj__PRet_airHandlingUnit__AHU_huis_nr_9 = airHandlingUnit__AHU_huis_nr_9.PRet "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_11 = airHandlingUnit__AHU_huis_nr_11.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_13 = airHandlingUnit__AHU_huis_nr_13.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_15 = airHandlingUnit__AHU_huis_nr_15.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_17 = airHandlingUnit__AHU_huis_nr_17.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_19 = airHandlingUnit__AHU_huis_nr_19.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_21 = airHandlingUnit__AHU_huis_nr_21.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_23 = airHandlingUnit__AHU_huis_nr_23.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_25 = airHandlingUnit__AHU_huis_nr_25.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_27 = airHandlingUnit__AHU_huis_nr_27.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_29 = airHandlingUnit__AHU_huis_nr_29.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_3 = airHandlingUnit__AHU_huis_nr_3.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_31 = airHandlingUnit__AHU_huis_nr_31.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_5 = airHandlingUnit__AHU_huis_nr_5.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_7 = airHandlingUnit__AHU_huis_nr_7.PSup "";
  output Real obj__PSup_airHandlingUnit__AHU_huis_nr_9 = airHandlingUnit__AHU_huis_nr_9.PSup "";
  output Real pEl_Schema_Sts = pel_Schema_Sts*P_AHUs_Schema_Sts/3600000 "Electrical power cost per unit of time";
  output Real pel_Schema_Sts = 0.2+0.2 "Electrical power price per unit of energy";
  output Real ppm_zone__Fietsenstalling_2_UC = zone__Fietsenstalling_2_UC.ppm "";
  output Real ppm_zone__Fietsenstalling_UC = zone__Fietsenstalling_UC.ppm "";
  output Real ppm_zone__Huis_nr_11_Badkamer = zone__Huis_nr_11_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_11_Leefruimte = zone__Huis_nr_11_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_11_Slaapkamer = zone__Huis_nr_11_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_13_Badkamer = zone__Huis_nr_13_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_13_Leefruimte = zone__Huis_nr_13_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_13_Slaapkamer = zone__Huis_nr_13_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_15_Badkamer = zone__Huis_nr_15_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_15_Leefruimte = zone__Huis_nr_15_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_15_Slaapkamer = zone__Huis_nr_15_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_17_Badkamer = zone__Huis_nr_17_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_17_Inkom = zone__Huis_nr_17_Inkom.ppm "";
  output Real ppm_zone__Huis_nr_17_Leefruimte = zone__Huis_nr_17_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_17_Slaapkamer = zone__Huis_nr_17_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_19_Badkamer = zone__Huis_nr_19_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_19_Inkom = zone__Huis_nr_19_Inkom.ppm "";
  output Real ppm_zone__Huis_nr_19_Leefruimte = zone__Huis_nr_19_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_19_Slaapkamer = zone__Huis_nr_19_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_21_Badkamer = zone__Huis_nr_21_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_21_Inkom = zone__Huis_nr_21_Inkom.ppm "";
  output Real ppm_zone__Huis_nr_21_Leefruimte = zone__Huis_nr_21_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_21_Slaapkamer = zone__Huis_nr_21_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_23_Badkamer = zone__Huis_nr_23_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_23_Leefruimte = zone__Huis_nr_23_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_23_Slaapkamer = zone__Huis_nr_23_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_25_Badkamer = zone__Huis_nr_25_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_25_Leefruimte = zone__Huis_nr_25_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_25_Slaapkamer = zone__Huis_nr_25_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_27_Badkamer = zone__Huis_nr_27_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_27_Leefruimte = zone__Huis_nr_27_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_27_Slaapkamer = zone__Huis_nr_27_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_29_Badkamer = zone__Huis_nr_29_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_29_Leefruimte = zone__Huis_nr_29_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_29_Slaapkamer = zone__Huis_nr_29_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_31_Badkamer = zone__Huis_nr_31_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_31_Inkom = zone__Huis_nr_31_Inkom.ppm "";
  output Real ppm_zone__Huis_nr_31_Leefruimte = zone__Huis_nr_31_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_31_Slaapkamer = zone__Huis_nr_31_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_3_Badkamer = zone__Huis_nr_3_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_3_Inkom = zone__Huis_nr_3_Inkom.ppm "";
  output Real ppm_zone__Huis_nr_3_Leefruimte = zone__Huis_nr_3_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_3_Slaapkamer = zone__Huis_nr_3_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_5_Badkamer = zone__Huis_nr_5_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_5_Inkom = zone__Huis_nr_5_Inkom.ppm "";
  output Real ppm_zone__Huis_nr_5_Leefruimte = zone__Huis_nr_5_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_5_Slaapkamer = zone__Huis_nr_5_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_7_Badkamer = zone__Huis_nr_7_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_7_Inkom = zone__Huis_nr_7_Inkom.ppm "";
  output Real ppm_zone__Huis_nr_7_Leefruimte = zone__Huis_nr_7_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_7_Slaapkamer = zone__Huis_nr_7_Slaapkamer.ppm "";
  output Real ppm_zone__Huis_nr_9_Badkamer = zone__Huis_nr_9_Badkamer.ppm "";
  output Real ppm_zone__Huis_nr_9_Leefruimte = zone__Huis_nr_9_Leefruimte.ppm "";
  output Real ppm_zone__Huis_nr_9_Slaapkamer = zone__Huis_nr_9_Slaapkamer.ppm "";
  output Real ppm_zone__Inkom_tech_lokaal_1_UC = zone__Inkom_tech_lokaal_1_UC.ppm "";
  output Real ppm_zone__Inkom_tech_lokaal_2_UC = zone__Inkom_tech_lokaal_2_UC.ppm "";
  output Real ppm_zone__Inkom_tech_lokaal_3_UC = zone__Inkom_tech_lokaal_3_UC.ppm "";
  output Real ppm_zone__Inkom_tech_ruimte_4_UC = zone__Inkom_tech_ruimte_4_UC.ppm "";
  output Real ppm_zone__Inkom_tech_ruimte_5_UC = zone__Inkom_tech_ruimte_5_UC.ppm "";
  output Real ppm_zone__Inkom_tech_ruimte_6_UC = zone__Inkom_tech_ruimte_6_UC.ppm "";
  output Real ppm_zone__Technische_ruimte_BEO_UC = zone__Technische_ruimte_BEO_UC.ppm "";
  output Real solAlt = sim.weaDat.altAng.alt "Solar altitude angle";
  output Real weekDay = clock__1.weekDay "Weekday [1,7] in local time zone";
  output Real weeklyProfile__Always_on_on = weeklyProfile__Always_on.y "";
  parameter Boolean T_start_exists(fixed=false); // reads whether value in field T_start exists
  parameter Boolean weeklyProfile_Always_on_friday_off_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_friday_off exists
  parameter Boolean weeklyProfile_Always_on_friday_on_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_friday_on exists
  parameter Boolean weeklyProfile_Always_on_monday_off_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_monday_off exists
  parameter Boolean weeklyProfile_Always_on_monday_on_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_monday_on exists
  parameter Boolean weeklyProfile_Always_on_saturday_off_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_saturday_off exists
  parameter Boolean weeklyProfile_Always_on_saturday_on_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_saturday_on exists
  parameter Boolean weeklyProfile_Always_on_sunday_off_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_sunday_off exists
  parameter Boolean weeklyProfile_Always_on_sunday_on_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_sunday_on exists
  parameter Boolean weeklyProfile_Always_on_thursday_off_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_thursday_off exists
  parameter Boolean weeklyProfile_Always_on_thursday_on_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_thursday_on exists
  parameter Boolean weeklyProfile_Always_on_tuesday_off_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_tuesday_off exists
  parameter Boolean weeklyProfile_Always_on_tuesday_on_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_tuesday_on exists
  parameter Boolean weeklyProfile_Always_on_wednesday_off_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_wednesday_off exists
  parameter Boolean weeklyProfile_Always_on_wednesday_on_exists(fixed=false); // reads whether value in field weeklyProfile__Always_on_wednesday_on exists
  parameter Modelica.Units.SI.Temperature T_start_fixed = Modelica.Units.Conversions.from_degC(22) "The building initial temperature";
  parameter Real T_start(fixed=false, start=22); // reads value from field T_start
  parameter Real obj = 0;

  parameter Real weeklyProfile__Always_on_friday_off(fixed=false, start=24); // reads value from field weeklyProfile__Always_on_friday_off
  parameter Real weeklyProfile__Always_on_friday_on(fixed=false, start=0); // reads value from field weeklyProfile__Always_on_friday_on
  parameter Real weeklyProfile__Always_on_monday_off(fixed=false, start=24); // reads value from field weeklyProfile__Always_on_monday_off
  parameter Real weeklyProfile__Always_on_monday_on(fixed=false, start=0); // reads value from field weeklyProfile__Always_on_monday_on
  parameter Real weeklyProfile__Always_on_saturday_off(fixed=false, start=24); // reads value from field weeklyProfile__Always_on_saturday_off
  parameter Real weeklyProfile__Always_on_saturday_on(fixed=false, start=0); // reads value from field weeklyProfile__Always_on_saturday_on
  parameter Real weeklyProfile__Always_on_sunday_off(fixed=false, start=24); // reads value from field weeklyProfile__Always_on_sunday_off
  parameter Real weeklyProfile__Always_on_sunday_on(fixed=false, start=0); // reads value from field weeklyProfile__Always_on_sunday_on
  parameter Real weeklyProfile__Always_on_thursday_off(fixed=false, start=24); // reads value from field weeklyProfile__Always_on_thursday_off
  parameter Real weeklyProfile__Always_on_thursday_on(fixed=false, start=0); // reads value from field weeklyProfile__Always_on_thursday_on
  parameter Real weeklyProfile__Always_on_tuesday_off(fixed=false, start=24); // reads value from field weeklyProfile__Always_on_tuesday_off
  parameter Real weeklyProfile__Always_on_tuesday_on(fixed=false, start=0); // reads value from field weeklyProfile__Always_on_tuesday_on
  parameter Real weeklyProfile__Always_on_wednesday_off(fixed=false, start=24); // reads value from field weeklyProfile__Always_on_wednesday_off
  parameter Real weeklyProfile__Always_on_wednesday_on(fixed=false, start=0); // reads value from field weeklyProfile__Always_on_wednesday_on

  parameter ExternData.JSONFile jsonReader__1(fileName=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/Sts_BC.json"))
    "JSON file for manual inputs"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));

  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_11_Badkamer__zone_Huis_nr_11_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=13.440000000000001,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-495.0,-52.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_11_Leefruimte__zone_Huis_nr_9_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.720000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-398.00000000000006,-64.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_11_Leefruimte__zone_Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.88)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-398.00000000000006,-41.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_11_Leefruimte__zone_Inkom_tech_lokaal_1_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=5.319999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-407.5,-31.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_11_Leefruimte__zone_Inkom_tech_lokaal_1_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.6)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-417.0,-21.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_11_Slaapkamer__zone_Huis_nr_11_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=13.440000000000001,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-463.00000000000006,-52.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_13_Badkamer__zone_Huis_nr_13_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=12.879999999999994,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-495.0,154.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.1599999999999975)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-400.0,166.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=4.760000000000008)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-408.5,155.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=11.2)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-417.0,135.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_13_Slaapkamer__zone_Huis_nr_13_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=12.879999999999994,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-464.00000000000006,154.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_15_Badkamer__zone_Huis_nr_15_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.1599999999999975,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-369.0,166.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_15_Badkamer__zone_Huis_nr_15_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=8.680000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-384.5,155.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_15_Leefruimte__zone_Huis_nr_17_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=8.399999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-287.0,162.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_15_Leefruimte__zone_Inkom_tech_lokaal_3_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    final custom_q50=0,
    T_start=T_start,
    A=4.7600000000000025)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-369.0,123.50000000000001})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_15_Slaapkamer__zone_Huis_nr_15_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.439999999999997,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-369.0,143.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_15_Slaapkamer__zone_Inkom_tech_lokaal_3_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=4.7600000000000025)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-386.0,123.50000000000001})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_15_Slaapkamer__zone_Inkom_tech_lokaal_3_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=4.760000000000008)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-377.5,132.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Badkamer__zone_Fietsenstalling_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=7.840000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-273.00000000000006,147.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Badkamer__zone_Huis_nr_17_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=8.399999999999995,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-259.0,162.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Inkom__zone_Huis_nr_17_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    final custom_q50=0,
    T_start=T_start,
    A=5.879999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-239.00000000000003,136.50000000000003})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Inkom__zone_Huis_nr_17_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=8.120000000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-224.50000000000003,126.00000000000001})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Leefruimte__zone_Fietsenstalling_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    final custom_q50=0,
    T_start=T_start,
    A=11.760000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-259.0,126.00000000000001})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Leefruimte__zone_Fietsenstalling_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=7.840000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-273.00000000000006,105.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Slaapkamer__zone_Huis_nr_17_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=8.120000000000006,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-224.50000000000003,147.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_17_Slaapkamer__zone_Huis_nr_17_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=5.6,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-249.00000000000003,147.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_19_Badkamer__zone_Huis_nr_21_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-39.0,168.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_19_Badkamer__zone_Huis_nr_21_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=4.479999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-39.0,151.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_19_Inkom__zone_Huis_nr_19_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.319999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-139.0,135.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_19_Inkom__zone_Huis_nr_19_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=9.239999999999997,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-155.5,145.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_19_Leefruimte__zone_Huis_nr_19_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.519999999999996,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-91.0,160.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_19_Slaapkamer__zone_Huis_nr_19_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.519999999999996,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-57.0,160.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Badkamer__zone_Huis_nr_21_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-6.000000000000001,168.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Badkamer__zone_Huis_nr_21_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=9.24)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-22.5,159.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Inkom__zone_Huis_nr_21_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.239999999999997,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={8.0,160.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Inkom__zone_Inkom_tech_ruimte_4_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={8.0,135.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Leefruimte__zone_Huis_nr_23_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={79.0,168.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Leefruimte__zone_Huis_nr_23_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.239999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={79.0,142.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Leefruimte__zone_Inkom_tech_ruimte_4_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=3.92)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={15.0,144.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Leefruimte__zone_Inkom_tech_ruimte_4_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={22.0,135.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_21_Slaapkamer__zone_Huis_nr_21_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.239999999999997,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-6.000000000000001,142.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_23_Badkamer__zone_Huis_nr_23_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={119.0,168.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_23_Badkamer__zone_Huis_nr_23_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=11.2)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={99.0,159.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_23_Leefruimte__zone_Huis_nr_29_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.999999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={210.0,164.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_23_Leefruimte__zone_Technische_ruimte_BEO_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=2.520000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={196.0,147.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_23_Leefruimte__zone_Technische_ruimte_BEO_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=3.919999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={203.0,152.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_23_Slaapkamer__zone_Huis_nr_23_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.239999999999997,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={119.0,142.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_25_Badkamer__zone_Huis_nr_25_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.6,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={358.00000000000006,-20.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_25_Slaapkamer__zone_Huis_nr_25_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=8.120000000000015)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={343.5,-10.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_25_Slaapkamer__zone_Huis_nr_25_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=10.36,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={358.00000000000006,8.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_27_Badkamer__zone_Huis_nr_25_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.6)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={329.0,-20.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_27_Badkamer__zone_Huis_nr_25_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=4.199999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={329.0,-2.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_27_Badkamer__zone_Inkom_tech_ruimte_6_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=5.039999999999992)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={320.0,5.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_27_Leefruimte__zone_Huis_nr_27_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.799999999999999,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={257.0,-12.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_27_Slaapkamer__zone_Huis_nr_27_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.799999999999999,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={311.0,-12.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_29_Badkamer__zone_Huis_nr_29_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=7.840000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={298.00000000000006,159.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_29_Badkamer__zone_Huis_nr_31_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={312.0,168.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_29_Leefruimte__zone_Huis_nr_29_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.0399999999999965,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={284.0,168.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_29_Leefruimte__zone_Huis_nr_29_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=10.079999999999998,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={284.0,141.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_29_Leefruimte__zone_Technische_ruimte_BEO_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    final custom_q50=0,
    T_start=T_start,
    A=2.520000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={210.0,147.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_29_Slaapkamer__zone_Huis_nr_31_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=4.479999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={312.0,151.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_29_Slaapkamer__zone_Inkom_tech_ruimte_5_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.6)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={312.0,133.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_31_Badkamer__zone_Huis_nr_31_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.519999999999996,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={332.0,160.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_31_Badkamer__zone_Inkom_tech_ruimte_5_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=5.6)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={322.0,143.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_31_Leefruimte__zone_Huis_nr_31_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=3.999688249,
    final custom_q50=0,
    T_start=T_start,
    A=4.8899897750404415,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-66.370622269,
        origin={376.0000000000001,180.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_31_Slaapkamer__zone_Huis_nr_31_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.519999999999996,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={368.00000000000006,160.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_31_Slaapkamer__zone_Huis_nr_31_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=10.080000000000004,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={350.0,177.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_3_Badkamer__zone_Huis_nr_3_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=7.56)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={47.5,-55.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_3_Badkamer__zone_Huis_nr_3_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.880000000000001,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={61.00000000000001,-65.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_3_Inkom__zone_Huis_nr_3_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.239999999999998,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={61.00000000000001,-38.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_3_Leefruimte__zone_Inkom_tech_lokaal_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=4.76)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={91.0,-30.500000000000004})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_3_Leefruimte__zone_Inkom_tech_lokaal_2_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=4.7600000000000025)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={99.5,-39.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_3_Slaapkamer__zone_Huis_nr_3_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.880000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={34.0,-65.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_3_Slaapkamer__zone_Huis_nr_3_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.239999999999998,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={34.0,-38.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_5_Badkamer__zone_Huis_nr_3_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.16)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-7.000000000000001,-65.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_5_Inkom__zone_Huis_nr_5_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.16,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-37.0,-65.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_5_Inkom__zone_Huis_nr_5_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=8.959999999999999,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-37.0,-38.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_5_Leefruimte__zone_Huis_nr_5_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=15.12,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-51.00000000000001,-49.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_5_Slaapkamer__zone_Huis_nr_3_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=8.959999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-7.000000000000001,-38.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_5_Slaapkamer__zone_Huis_nr_5_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=8.399999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-22.0,-54.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Badkamer__zone_Fietsenstalling_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=7.840000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-273.00000000000006,-43.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Badkamer__zone_Huis_nr_7_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.240000000000002,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-259.0,-59.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Inkom__zone_Huis_nr_7_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    final custom_q50=0,
    T_start=T_start,
    A=5.879999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-239.00000000000003,-32.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Inkom__zone_Huis_nr_7_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=8.120000000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-224.50000000000003,-22.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Leefruimte__zone_Fietsenstalling_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    final custom_q50=0,
    T_start=T_start,
    A=11.479999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-259.0,-22.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Leefruimte__zone_Fietsenstalling_2_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=7.840000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-273.00000000000006,-2.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Slaapkamer__zone_Huis_nr_7_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=8.120000000000006,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-224.50000000000003,-43.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_7_Slaapkamer__zone_Huis_nr_7_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=5.6,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-249.00000000000003,-43.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_9_Badkamer__zone_Huis_nr_9_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.720000000000001,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-368.00000000000006,-64.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_9_Badkamer__zone_Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytong constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    final custom_q50=0,
    T_start=T_start,
    A=8.399999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-383.00000000000006,-52.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_9_Leefruimte__zone_Huis_nr_7_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_33cm constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=9.240000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-287.0,-59.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Huis_nr_9_Slaapkamer__zone_Huis_nr_9_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=11.479999999999999,
    h=0.03,
    hasCavity=true,
    w=0.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-368.00000000000006,-31.500000000000004})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Inkom_tech_lokaal_1_UC__zone_Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=5.6)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-398.00000000000006,-21.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Inkom_tech_ruimte_6_UC__zone_Huis_nr_25_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Internal_wall_Ytonginsulation constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=6.16)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={329.0,16.0})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Technische_ruimte_BEO_UC__zone_Huis_nr_27_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    final custom_q50=0,
    T_start=T_start,
    A=3.640000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={210.0,61.5})));
  IDEAS.Buildings.Components.InternalWall internalWall_zone_Technische_ruimte_BEO_UC__zone_Huis_nr_27_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_internal_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    final custom_q50=0,
    T_start=T_start,
    A=9.519999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={193.0,55.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Fietsenstalling_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=11.480000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-223.0,-22.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Fietsenstalling_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=11.76000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-223.00000000000006,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_11_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=11.520000000000039)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-458.6,-47.2})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_11_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=38.4500000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-377.12500000000006,-39.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_11_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=15.359999999999957)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-429.00000000000006,-52.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_13_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=11.04000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-458.6,149.4})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_13_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=32.88000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-382.28571428571433,146.42857142857142})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_13_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=14.259999999999962)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-429.5,154.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_15_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.820000000000007)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-334.5,166.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_15_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=40.279999999999966)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-286.25,145.625})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_15_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=16.310000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-342.0,137.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_17_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=8.399999999999991)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-223.0,162.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_17_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.090000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-174.50000000000003,136.50000000000003})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_17_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=39.900000000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-198.75000000000006,112.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_17_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=14.699999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-185.40000000000003,159.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_19_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.119999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={3.799999999999999,159.8})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_19_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.269999999999989)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-105.5,135.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_19_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=35.039999999999985)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-77.85714285714289,148.42857142857144})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_19_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=11.559999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-24.000000000000004,160.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_21_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=5.939999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={27.5,168.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_21_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=7.139999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={51.0,151.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_21_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=33.68999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={92.42857142857144,150.42857142857142})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_21_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=10.889999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={24.2,142.60000000000002})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_23_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=7.199999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={149.0,168.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_23_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=37.83999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={217.00000000000003,150.55555555555554})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_23_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=13.199999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={149.0,142.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_25_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=5.800000000000011)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={393.5,-20.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_25_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=41.19000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={447.625,4.25})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_25_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=10.730000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={390.6,7.800000000000001})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_27_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.299999999999983)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={371.8,-12.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_27_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=44.16000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={271.3076923076924,30.69230769230769})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_27_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=18.89999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={334.00000000000006,-12.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_29_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=5.039999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={348.00000000000006,168.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_29_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=34.76)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={294.25000000000006,149.62500000000003})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_29_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=10.079999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={350.80000000000007,141.39999999999998})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_31_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.799999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={370.0,159.8})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_31_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=15.609999999999992)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={431.0,150.20000000000002})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_31_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=21.709999999999994)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={404.00000000000006,194.60000000000002})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_31_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=12.239999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={400.0,160.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_3_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=5.670000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={97.5,-65.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_3_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=8.909999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={97.5,-38.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_3_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=32.110000000000014)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={142.625,-46.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_3_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=22.14)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={63.50000000000001,-50.83333333333334})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_5_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.6000000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={28.0,-65.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_5_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=7.560000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={7.399999999999993,-50.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_5_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=35.74)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-41.66666666666668,-45.666666666666664})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_5_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=9.600000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={28.0,-38.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_7_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=9.240000000000009)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-223.0,-59.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_7_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=6.090000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-174.50000000000003,-32.5})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_7_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=39.41000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-198.75,-9.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_7_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=16.170000000000016)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-185.40000000000003,-56.2})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_9_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=7.200000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-333.00000000000006,-64.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_9_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=42.09)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-281.1428571428572,-44.57142857142857})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=12.300000000000011)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-336.0000000000001,-31.400000000000002})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Inkom_tech_lokaal_1_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=3.799999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-357.5,-21.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Inkom_tech_lokaal_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=2.8900000000000023)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={149.5,-30.500000000000004})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Inkom_tech_lokaal_3_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=2.8900000000000077)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-327.5,123.50000000000001})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Inkom_tech_ruimte_4_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=2.5199999999999987)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={65.0,135.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Inkom_tech_ruimte_5_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=4.0)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={372.0,133.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Inkom_tech_ruimte_6_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=3.960000000000008)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={370.0,16.0})));
  IDEAS.Buildings.Components.OuterWall ceiling_zone_Technische_ruimte_BEO_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_roof constructionType,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=1.270506037,
    T_start=T_start,
    A=30.539999999999978)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={243.0909090909091,106.72727272727273})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Fietsenstalling_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=22.799999999999997,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=13.12)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-287.0,-22.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Fietsenstalling_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=22.799999999999997,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=13.440000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-287.0,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=7.680000000000019)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-507.0,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Badkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    T_start=T_start,
    A=15.360000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-519.0,-52.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Badkamer__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=20.5,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.08)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-505.0,-28.000000000000004})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=20.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-430.50000000000006,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=18.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=12.402000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-440.0,-11.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=5.199999999999996,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=5.44)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-463.00000000000006,-19.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=20.5,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.919999999999986)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-479.00000000000006,-28.000000000000004})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_11_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=10.239999999999986)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-479.00000000000006,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=7.680000000000019)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-507.0,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Badkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    T_start=T_start,
    A=14.719999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-519.0,154.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Badkamer__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=20.700000000000003,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.08)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-505.0,131.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=20.48000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-432.0,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=19.1,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=12.72200000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-440.50000000000006,115.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=5.099999999999994,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=5.120000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-464.00000000000006,123.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=9.919999999999982)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-479.5,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_13_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=15.900000000000002,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=9.107499999999982)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-479.5,131.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_15_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=9.920000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-384.5,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_15_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=26.239999999999988)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-328.0,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_15_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=12.6,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=13.361999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-344.5,115.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_15_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=3.299999999999997,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=10.240000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-320.0,131.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_15_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=22.3,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=9.239999999999991)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-303.5,147.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_15_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=19.1,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=7.602000000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-401.50000000000006,115.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_17_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=8.960000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-273.00000000000006,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_17_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=3.8000000000000007,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=6.72)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,136.50000000000003})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_17_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=14.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=24.64000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-248.5,72.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_17_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=42.0,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=14.962000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,99.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_17_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=22.799999999999997,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=9.239999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-287.0,88.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_17_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=15.680000000000009)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-234.50000000000003,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_17_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=3.8000000000000007,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=7.281999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,162.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=5.76)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-48.00000000000001,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Badkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=16.5,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=4.5792)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-48.00000000000001,143.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=10.209999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-155.5,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Inkom__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=34.7,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.729999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-172.0,135.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=25.919999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-131.5,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=34.7,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=9.039999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-172.0,161.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=16.5,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=13.042000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-115.0,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=5.199999999999999,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.439999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-91.0,134.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=10.879999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-74.0,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_19_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=21.900000000000002,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=9.6992)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-74.0,143.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_21_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=10.560000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-22.5,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_21_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=4.48)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={0.9999999999999998,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_21_Inkom__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=14.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=4.48)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={0.9999999999999998,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_21_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=22.720000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={43.50000000000001,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_21_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=20.200000000000003,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=14.7412)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={50.50000000000001,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_21_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=14.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.242)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-22.5,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_21_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=48.00000000000001,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.439999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-39.0,134.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_23_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=12.8)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={99.0,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_23_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=29.12)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={164.5,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_23_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=13.041999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={143.0,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_23_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=6.900000000000002,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.439999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={167.0,134.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_23_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=21.6,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=8.080000000000009)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={181.5,143.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_23_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=20.200000000000003,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=11.619200000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={99.0,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_25_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=4.300000000000001,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=8.93000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={343.5,-30.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_25_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=16.33235294117647,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=12.371999999999986)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={381.50000000000006,27.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_25_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=4.300000000000001,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=22.800000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={395.50000000000006,-30.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_25_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    T_start=T_start,
    A=10.339200000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={433.00000000000006,-12.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_25_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.858540023,
    T_start=T_start,
    A=5.159844958911074)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=7.125016349,
        origin={432.0,14.000000000000002})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_25_Leefruimte__5(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=7.620000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={418.0,22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_25_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=11.600000000000001,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=6.962000000000019)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={343.5,27.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=4.300000000000001,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=5.409999999999992)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={320.0,-30.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=10.899999999999999,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.0)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={222.5,68.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__10(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=5.399999999999999,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=7.040000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={257.0,16.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    T_start=T_start,
    A=6.080000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={235.0,58.50000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    T_start=T_start,
    A=4.600000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={223.0,38.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=12.200000000000001,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=3.8399999999999976)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={229.0,49.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__5(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=69.1,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=7.4399999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={176.0,41.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__6(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=10.100000000000001,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=10.560000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={192.5,28.000000000000004})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__7(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=72.4,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=18.560000000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={209.00000000000003,-0.9999999999999987})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__8(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=4.300000000000001,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=14.160000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={233.00000000000006,-30.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Leefruimte__9(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=15.0,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.212000000000007)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={240.0,27.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=4.300000000000001,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=17.279999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={284.0,-30.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_27_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=17.2,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=14.918399999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={284.0,5.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_29_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=8.960000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={298.00000000000006,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_29_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    T_start=T_start,
    A=23.68000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={247.00000000000003,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_29_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=21.6,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=7.120000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={223.0,143.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_29_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=75.5,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=6.4)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={236.0,133.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_29_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=19.6,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=12.692000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={260.0,123.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_29_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=19.6,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=6.642000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={298.00000000000006,123.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=3.2187500000000036,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=6.4)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={322.0,177.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.602388641,
    T_start=T_start,
    A=17.635780121113456)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=21.801409486,
        origin={395.0,156.50000000000003})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Inkom__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=0.88363032,
    T_start=T_start,
    A=8.629523031752488)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-67.833654178,
        origin={392.5,123.50000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Inkom__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.42679549,
    hasBuildingShade=true,
    L=51.27395106534373,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.740160181598498)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-156.250505507,
        origin={373.5,130.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.606404683,
    T_start=T_start,
    A=11.55632386777203)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=21.571307191,
        origin={375.50000000000006,205.50000000000006})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.035189421,
    T_start=T_start,
    A=16.519564158899595)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-248.404689551,
        origin={343.00000000000006,217.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.444222919,
    hasBuildingShade=true,
    L=69.42888000463658,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=10.756951240941836)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-157.249023657,
        origin={325.50000000000006,192.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_31_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=21.6,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=9.989200000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={350.0,143.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=8.64)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={47.5,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=19.9,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.64)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={47.5,-22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=19.9,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=7.281999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={76.0,-22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=23.36)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={97.5,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    T_start=T_start,
    A=10.64)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={134.0,-57.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=21.6,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.319999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={121.00000000000001,-39.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=19.9,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=11.939200000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={13.5,-22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_3_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=13.120000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={13.5,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=9.6)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-22.0,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=19.9,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=4.480000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-44.0,-22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Inkom__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=4.480000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-44.0,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=21.6,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=7.7600000000000025)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-112.00000000000001,-39.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=39.300000000000004,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=11.84)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-126.00000000000001,-57.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=24.000000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-88.50000000000001,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=19.9,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=12.722000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-74.50000000000001,-22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Leefruimte__5(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=42.10000000000001,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.44)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-98.0,-30.500000000000004})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_5_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=19.9,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=7.282)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-22.0,-22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_7_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=8.960000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-273.00000000000006,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_7_Inkom(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=11.2,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=6.72)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,-32.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_7_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=14.6,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=24.64000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-248.5,31.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_7_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=41.900000000000006,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=14.642000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,4.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_7_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=22.799999999999997,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=9.240000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-287.0,14.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_7_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=15.680000000000009)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-234.50000000000003,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_7_Slaapkamer__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=8.399999999999999,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=8.242000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,-59.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_9_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=9.6)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-383.00000000000006,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_9_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=18.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=13.042000000000016)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-344.00000000000006,-11.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_9_Leefruimte__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=25.920000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-327.5,-76.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_9_Leefruimte__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=22.0,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=9.239999999999991)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-303.5,-43.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_9_Leefruimte__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=11.0,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=10.24)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-320.0,-27.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=18.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=7.282)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-383.00000000000006,-11.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_lokaal_1_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=18.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=6.079999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-407.5,-11.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_lokaal_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=19.9,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.440000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={99.5,-22.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_lokaal_2_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    T_start=T_start,
    A=5.090000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={108.0,-30.500000000000004})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_lokaal_3_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=19.1,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.440000000000009)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-377.5,115.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_ruimte_4_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=14.8,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=4.48)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={15.0,126.00000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_ruimte_5_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    hasBuildingShade=true,
    L=19.6,
    dh=5.2,
    hWal=2.8,
    T_start=T_start,
    A=6.050000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={322.0,123.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_ruimte_5_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    hasBuildingShade=true,
    L=7.240000000000002,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=6.4)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={332.0,133.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_ruimte_6_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=15.0,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=5.409999999999992)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={320.0,27.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Inkom_tech_ruimte_6_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=82.6,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=7.040000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={311.0,16.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Technische_ruimte_BEO_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    T_start=T_start,
    A=24.000000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={210.0,105.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Technische_ruimte_BEO_UC__2(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=71.4,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=12.480000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={199.00000000000003,123.50000000000001})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Technische_ruimte_BEO_UC__3(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    hasBuildingShade=true,
    L=7.299999999999999,
    dh=0.0,
    hWal=2.8,
    T_start=T_start,
    A=12.800000000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={179.00000000000003,104.0})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Technische_ruimte_BEO_UC__4(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    hasBuildingShade=true,
    L=67.4,
    dh=0.20000000000000018,
    hWal=2.8,
    T_start=T_start,
    A=13.012000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={159.0,79.5})));
  IDEAS.Buildings.Components.OuterWall outerWall_zone_Technische_ruimte_BEO_UC__5(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_outer_wall constructionType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    T_start=T_start,
    A=5.440000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={167.5,55.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Fietsenstalling_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=11.480000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-223.0,-22.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Fietsenstalling_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=11.76000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-223.00000000000006,126.00000000000001})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_11_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=11.520000000000039)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-458.6,-47.2})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_11_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=38.4500000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-377.12500000000006,-39.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_11_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=15.359999999999957)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-429.00000000000006,-52.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_13_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=11.04000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-458.6,149.4})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_13_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=32.88000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-382.28571428571433,146.42857142857142})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_13_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=14.259999999999962)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-429.5,154.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_15_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.820000000000007)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-334.5,166.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_15_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=40.279999999999966)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-286.25,145.625})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_15_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=16.310000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-342.0,137.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_17_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=8.399999999999991)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-223.0,162.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_17_Inkom(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.090000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-174.50000000000003,136.50000000000003})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_17_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=39.900000000000006)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-198.75000000000006,112.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_17_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=14.699999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-185.40000000000003,159.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_19_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.119999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={3.799999999999999,159.8})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_19_Inkom(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.269999999999989)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-105.5,135.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_19_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=35.039999999999985)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-77.85714285714289,148.42857142857144})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_19_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=11.559999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-24.000000000000004,160.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_21_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=5.939999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={27.5,168.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_21_Inkom(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=7.139999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={51.0,151.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_21_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=33.68999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={92.42857142857144,150.42857142857142})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_21_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=10.889999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={24.2,142.60000000000002})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_23_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=7.199999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={149.0,168.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_23_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=37.83999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={217.00000000000003,150.55555555555554})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_23_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=13.199999999999996)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={149.0,142.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_25_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=5.800000000000011)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={393.5,-20.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_25_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=41.19000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={447.625,4.25})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_25_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=10.730000000000004)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={390.6,7.800000000000001})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_27_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.299999999999983)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={371.8,-12.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_27_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=44.16000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={271.3076923076924,30.69230769230769})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_27_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=18.89999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={334.00000000000006,-12.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_29_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=5.039999999999999)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={348.00000000000006,168.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_29_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=34.76)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={294.25000000000006,149.62500000000003})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_29_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=10.079999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={350.80000000000007,141.39999999999998})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_31_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.799999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={370.0,159.8})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_31_Inkom(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=15.609999999999992)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={431.0,150.20000000000002})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_31_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=21.709999999999994)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={404.00000000000006,194.60000000000002})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_31_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=12.239999999999995)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={400.0,160.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_3_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=5.670000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={97.5,-65.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_3_Inkom(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=8.909999999999998)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={97.5,-38.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_3_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=32.110000000000014)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={142.625,-46.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_3_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=22.14)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={63.50000000000001,-50.83333333333334})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_5_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.6000000000000005)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={28.0,-65.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_5_Inkom(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=7.560000000000002)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={7.399999999999993,-50.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_5_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=35.74)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-41.66666666666668,-45.666666666666664})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_5_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=9.600000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={28.0,-38.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_7_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=9.240000000000009)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-223.0,-59.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_7_Inkom(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=6.090000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-174.50000000000003,-32.5})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_7_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=39.41000000000001)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-198.75,-9.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_7_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=16.170000000000016)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-185.40000000000003,-56.2})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_9_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=7.200000000000003)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-333.00000000000006,-64.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_9_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=42.09)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-281.1428571428572,-44.57142857142857})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare tabstype__Floor_heating_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=12.300000000000011)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-336.0000000000001,-31.400000000000002})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Inkom_tech_lokaal_1_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=3.799999999999997)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-357.5,-21.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Inkom_tech_lokaal_2_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=2.8900000000000023)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={149.5,-30.500000000000004})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Inkom_tech_lokaal_3_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=2.8900000000000077)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-327.5,123.50000000000001})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Inkom_tech_ruimte_4_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=2.5199999999999987)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={65.0,135.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Inkom_tech_ruimte_5_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=4.0)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={372.0,133.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Inkom_tech_ruimte_6_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=3.960000000000008)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={370.0,16.0})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround_zone_Technische_ruimte_BEO_UC(
    redeclare package Medium=MediumAir,
    redeclare constructiontype__Default_floor_on_ground_inv constructionType,
    inc=IDEAS.Types.Tilt.Floor,
    azi=4.412098691,
    T_start=T_start_fixed,
    A=30.539999999999978)
    "Opaque wall model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={243.0909090909091,106.72727272727273})));
  IDEAS.Buildings.Components.Window window__Window_1(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=15.900000000000002,
        dh=0.7399999999999998,
        hWin=1.32,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-501.0000000000001,131.0})));

  IDEAS.Buildings.Components.Window window__Window_1__2(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=19.0,
        dh=0.7399999999999998,
        hWin=1.32,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-305.0,147.0})));

  IDEAS.Buildings.Components.Window window__Window_1__3(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=22.799999999999997,
        dh=0.94,
        hWin=1.32,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-287.0,90.0})));

  IDEAS.Buildings.Components.Window window__Window_1__4(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=22.799999999999997,
        dh=0.94,
        hWin=1.32,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-287.0,14.0})));

  IDEAS.Buildings.Components.Window window__Window_1__5(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=15.900000000000002,
        dh=0.7399999999999998,
        hWin=1.32,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-501.0,-28.000000000000004})));

  IDEAS.Buildings.Components.Window window__Window_1__6(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=15.900000000000002,
        dh=0.7399999999999998,
        hWin=1.32,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-474.0,-28.000000000000004})));

  IDEAS.Buildings.Components.Window window__Window_1__7(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=19.0,
        dh=0.7399999999999998,
        hWin=1.32,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-304.0,-43.0})));

  IDEAS.Buildings.Components.Window window__Window_1__8(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.32,
        wWin=1,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.602388641,
    nWin=1.0,
    A=1.32)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=21.801409486,
        origin={393.65615758520676,159.85960603698322})));

  IDEAS.Buildings.Components.Window window__Window_2(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=12.6,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-433.00000000000006,115.0})));

  IDEAS.Buildings.Components.Window window__Window_2__10(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=36.9,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,96.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_2__11(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=3.8000000000000007,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,157.0})));

  IDEAS.Buildings.Components.Window window__Window_2__12(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=41.900000000000006,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,9.0})));

  IDEAS.Buildings.Components.Window window__Window_2__13(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=8.399999999999999,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={-210.0,-53.64516129032259})));

  IDEAS.Buildings.Components.Window window__Window_2__14(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=12.6,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-447.0,-11.0})));

  IDEAS.Buildings.Components.Window window__Window_2__15(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=12.6,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-386.0,-11.0})));

  IDEAS.Buildings.Components.Window window__Window_2__16(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=12.6,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-352.0,-11.0})));

  IDEAS.Buildings.Components.Window window__Window_2__17(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=14.8,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={79.0,-22.0})));

  IDEAS.Buildings.Components.Window window__Window_2__18(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=14.8,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-23.0,-22.0})));

  IDEAS.Buildings.Components.Window window__Window_2__19(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=16.5,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-80.0,-22.0})));

  IDEAS.Buildings.Components.Window window__Window_2__2(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=12.6,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-401.0,115.0})));

  IDEAS.Buildings.Components.Window window__Window_2__20(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=10.690909090909091,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={372.0,27.0})));

  IDEAS.Buildings.Components.Window window__Window_2__21(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=11.600000000000001,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={340.0,27.0})));

  IDEAS.Buildings.Components.Window window__Window_2__22(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=2.2,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={233.00000000000006,27.0})));

  IDEAS.Buildings.Components.Window window__Window_2__23(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=36.9,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={159.0,88.0})));

  IDEAS.Buildings.Components.Window window__Window_2__3(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=12.6,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-339.0,115.0})));

  IDEAS.Buildings.Components.Window window__Window_2__4(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=16.5,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-108.0,126.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_2__5(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=14.8,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-20.999999999999996,126.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_2__6(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=14.8,
        dh=0.4500000000000002,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={36.00000000000001,126.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_2__7(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={137.0,126.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_2__8(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=19.6,
        dh=5.65,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={266.0,123.0})));

  IDEAS.Buildings.Components.Window window__Window_2__9(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=19.6,
        dh=5.65,
        hWin=1.9,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.9,
        wWin=1.22,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=2.318)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={302.0,123.0})));

  IDEAS.Buildings.Components.Window window__Window_3(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=16.5,
        dh=0.6799999999999997,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-78.0,143.0})));

  IDEAS.Buildings.Components.Window window__Window_3__2(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=16.5,
        dh=0.6799999999999997,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-51.00000000000001,143.0})));

  IDEAS.Buildings.Components.Window window__Window_3__3(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=14.8,
        dh=0.6799999999999997,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={66.0,126.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_3__4(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=14.8,
        dh=0.6799999999999997,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={106.0,126.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_3__5(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=21.6,
        dh=5.88,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={344.00000000000006,143.0})));

  IDEAS.Buildings.Components.Window window__Window_3__6(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=14.8,
        dh=0.6799999999999997,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={7.000000000000001,-22.0})));

  IDEAS.Buildings.Components.Window window__Window_3__7(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=11.8,
        dh=0.6799999999999997,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={295.0,5.0})));

  IDEAS.Buildings.Components.Window window__Window_3__8(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=11.8,
        dh=0.6799999999999997,
        hWin=1.44,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={275.0,5.0})));

  IDEAS.Buildings.Components.Window window__Window_3__9(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.44,
        wWin=0.82,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=1.1807999999999998)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={433.00000000000006,-5.999999999999992})));

  IDEAS.Buildings.Components.Window window__Window_4(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-162.0,126.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_4__10(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=21.6,
        dh=6.25,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={358.00000000000006,143.0})));

  IDEAS.Buildings.Components.Window window__Window_4__11(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=10.69836764348976,
        dh=1.0499999999999998,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=0.88363032,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-67.833654178,
        origin={386.5520604448395,121.07676536641613})));

  IDEAS.Buildings.Components.Window window__Window_4__12(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=0.88363032,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-67.833654178,
        origin={398.5912611218436,125.98162490149186})));

  IDEAS.Buildings.Components.Window window__Window_4__13(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={424.0,22.0})));

  IDEAS.Buildings.Components.Window window__Window_4__14(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={414.0,22.0})));

  IDEAS.Buildings.Components.Window window__Window_4__15(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=3.8000000000000007,
        dh=1.0499999999999998,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-172.0,136.0})));

  IDEAS.Buildings.Components.Window window__Window_4__16(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={108.0,-31.0})));

  IDEAS.Buildings.Components.Window window__Window_4__2(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=4.300000000000001,
        dh=6.25,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={341.99999999999994,-30.0})));

  IDEAS.Buildings.Components.Window window__Window_4__3(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=4.300000000000001,
        dh=6.25,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={319.0,-30.0})));

  IDEAS.Buildings.Components.Window window__Window_4__4(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=67.4,
        dh=1.25,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={159.0,66.0})));

  IDEAS.Buildings.Components.Window window__Window_4__5(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=9.792592592592595,
        dh=1.0499999999999998,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={396.0,27.0})));

  IDEAS.Buildings.Components.Window window__Window_4__6(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=9.600000000000001,
        dh=1.0499999999999998,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={319.0,27.0})));

  IDEAS.Buildings.Components.Window window__Window_4__7(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=9.600000000000001,
        dh=1.0499999999999998,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={248.00000000000006,27.0})));

  IDEAS.Buildings.Components.Window window__Window_4__8(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=19.6,
        dh=6.25,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={247.00000000000003,123.0})));

  IDEAS.Buildings.Components.Window window__Window_4__9(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=19.6,
        dh=6.25,
        hWin=0.7,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=0.7,
        wWin=0.5,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=0.35)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={322.0,123.0})));

  IDEAS.Buildings.Components.Window window__Window_5(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=21.6,
        dh=6.1,
        hWin=1,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={223.0,143.0})));

  IDEAS.Buildings.Components.Window window__Window_5__2(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=21.6,
        dh=6.1,
        hWin=1,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={184.0,143.0})));

  IDEAS.Buildings.Components.Window window__Window_5__3(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=16.5,
        dh=0.8999999999999999,
        hWin=1,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=4.412098691,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=90.0,
        origin={-111.00000000000001,-39.0})));

  IDEAS.Buildings.Components.Window window__Window_5__4(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=69.1,
        dh=1.1,
        hWin=1,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={176.0,42.0})));

  IDEAS.Buildings.Components.Window window__Window_5__5(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=4.300000000000001,
        dh=6.1,
        hWin=1,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={232.00000000000003,-30.0})));

  IDEAS.Buildings.Components.Window window__Window_5__6(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=4.300000000000001,
        dh=6.1,
        hWin=1,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={402.68085106382983,-30.0})));

  IDEAS.Buildings.Components.Window window__Window_5__7(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=3.8000000000000007,
        dh=0.8999999999999999,
        hWin=1,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=2.841302364,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-180.0,
        origin={-172.0,160.0})));

  IDEAS.Buildings.Components.Window window__Window_5__8(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1,
        wWin=1.2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=1.2)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={134.0,-56.00000000000001})));

  IDEAS.Buildings.Components.Window window__Window_6(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.22,
        wWin=2,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.982895018,
    nWin=1.0,
    A=2.44)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=0.0,
        origin={223.0,38.52380952380953})));

  IDEAS.Buildings.Components.Window window__Window_7(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.None stateShading1(haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.8,
        wWin=1.8,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=5.606404683,
    nWin=1.0,
    A=3.24)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=21.571307191,
        origin={375.1761866550939,206.31905728417445})));

  IDEAS.Buildings.Components.Window window__Window_8(
    redeclare IDEAS.Buildings.Components.Shading.Interfaces.DoubleShading shaType(
      redeclare IDEAS.Buildings.Components.Shading.BuildingShade stateShading1(
        L=15.900000000000002,
        dh=0.7749999999999999,
        hWin=1.25,
        haveBoundaryPorts=false),
      redeclare IDEAS.Buildings.Components.Shading.Box stateShading2(
        hWin=1.25,
        wWin=0.65,
        wLeft=10,
        wRight=10,
        ovDep=0.2,
        ovGap=0,
        hFin=10,
        finDep=0.2,
        finGap=0)),
    redeclare package Medium=MediumAir,
    redeclare parameter glazingtype__Double_glazing glazing,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType(U_value=1.5),
    frac=0.4,
    inc=IDEAS.Types.Tilt.Wall,
    azi=1.270506037,
    nWin=1.0,
    A=0.8125)
      "Window model"
      annotation (Placement(
        transformation(
        extent={{6,-10},{-6,10}},
        rotation=-90.0,
        origin={-474.00000000000006,131.0})));

  IDEAS.Buildings.Components.Zone zone__Fietsenstalling_2_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1147,
    nPorts=nAir1147,
    V=32.14400000000001)
    "Fietsenstalling 2_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-273.0,-22.5})));
  IDEAS.Buildings.Components.Zone zone__Fietsenstalling_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1384,
    nPorts=nAir1384,
    V=32.928000000000054)
    "Fietsenstalling_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-273.00000000000006,126.00000000000001})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_11_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1014,
    nPorts=nAir1014,
    V=32.25600000000011)
    "Huis nr 11_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-508.6,-47.2})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_11_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1030,
    nPorts=nAir1030,
    V=107.66000000000028)
    "Huis nr 11_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-427.12500000000006,-39.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_11_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1021,
    nPorts=nAir1021,
    V=43.007999999999875)
    "Huis nr 11_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-479.00000000000006,-52.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_13_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1254,
    nPorts=nAir1254,
    V=30.912000000000056)
    "Huis nr 13_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-508.6,149.4})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_13_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1277,
    nPorts=nAir1277,
    V=92.0640000000001)
    "Huis nr 13_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-432.28571428571433,146.42857142857142})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_13_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1268,
    nPorts=nAir1268,
    V=39.92799999999989)
    "Huis nr 13_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-479.5,154.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_15_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1295,
    nPorts=nAir1295,
    V=19.096000000000018)
    "Huis nr 15_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-384.5,166.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_15_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1321,
    nPorts=nAir1321,
    V=112.78399999999989)
    "Huis nr 15_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-336.25,145.625})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_15_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1303,
    nPorts=nAir1303,
    V=45.668000000000006)
    "Huis nr 15_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-392.0,137.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_17_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1342,
    nPorts=nAir1342,
    V=23.519999999999975)
    "Huis nr 17_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-273.0,162.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_17_Inkom(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1358,
    nPorts=nAir1358,
    V=17.052000000000007)
    "Huis nr 17_Inkom"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-224.50000000000003,136.50000000000003})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_17_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1364,
    nPorts=nAir1364,
    V=111.72000000000001)
    "Huis nr 17_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-248.75000000000006,112.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_17_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1349,
    nPorts=nAir1349,
    V=41.15999999999998)
    "Huis nr 17_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-235.40000000000003,159.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_19_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1431,
    nPorts=nAir1431,
    V=17.135999999999985)
    "Huis nr 19_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-46.2,159.8})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_19_Inkom(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1394,
    nPorts=nAir1394,
    V=17.55599999999997)
    "Huis nr 19_Inkom"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-155.5,135.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_19_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1408,
    nPorts=nAir1408,
    V=98.11199999999995)
    "Huis nr 19_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-127.85714285714289,148.42857142857144})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_19_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1423,
    nPorts=nAir1423,
    V=32.36799999999999)
    "Huis nr 19_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-74.0,160.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_21_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1440,
    nPorts=nAir1440,
    V=16.631999999999994)
    "Huis nr 21_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-22.5,168.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_21_Inkom(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1457,
    nPorts=nAir1457,
    V=19.99199999999999)
    "Huis nr 21_Inkom"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={1.0000000000000002,151.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_21_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1466,
    nPorts=nAir1466,
    V=94.33199999999995)
    "Huis nr 21_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={42.42857142857143,150.42857142857142})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_21_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1448,
    nPorts=nAir1448,
    V=30.49199999999999)
    "Huis nr 21_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-25.8,142.60000000000002})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_23_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1488,
    nPorts=nAir1488,
    V=20.159999999999986)
    "Huis nr 23_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={99.0,168.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_23_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1503,
    nPorts=nAir1503,
    V=105.95199999999994)
    "Huis nr 23_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={167.00000000000003,150.55555555555554})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_23_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1495,
    nPorts=nAir1495,
    V=36.95999999999999)
    "Huis nr 23_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={99.0,142.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_25_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1704,
    nPorts=nAir1704,
    V=16.24000000000003)
    "Huis nr 25_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={343.5,-20.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_25_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1712,
    nPorts=nAir1712,
    V=115.33200000000002)
    "Huis nr 25_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={397.625,4.25})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_25_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1697,
    nPorts=nAir1697,
    V=30.044000000000008)
    "Huis nr 25_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={340.6,7.800000000000001})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_27_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1673,
    nPorts=nAir1673,
    V=17.63999999999995)
    "Huis nr 27_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={321.8,-12.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_27_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1632,
    nPorts=nAir1632,
    V=123.64800000000002)
    "Huis nr 27_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={221.30769230769235,30.69230769230769})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_27_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1665,
    nPorts=nAir1665,
    V=52.91999999999997)
    "Huis nr 27_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={284.0,-12.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_29_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1554,
    nPorts=nAir1554,
    V=14.111999999999997)
    "Huis nr 29_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={298.00000000000006,168.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_29_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1532,
    nPorts=nAir1532,
    V=97.32799999999999)
    "Huis nr 29_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={244.25000000000006,149.62500000000003})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_29_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1560,
    nPorts=nAir1560,
    V=28.223999999999993)
    "Huis nr 29_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={300.80000000000007,141.39999999999998})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_31_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1569,
    nPorts=nAir1569,
    V=19.039999999999992)
    "Huis nr 31_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={320.0,159.8})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_31_Inkom(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1594,
    nPorts=nAir1594,
    V=43.70799999999998)
    "Huis nr 31_Inkom"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={381.0,150.20000000000002})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_31_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1587,
    nPorts=nAir1587,
    V=60.787999999999975)
    "Huis nr 31_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={354.00000000000006,194.60000000000002})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_31_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1578,
    nPorts=nAir1578,
    V=34.271999999999984)
    "Huis nr 31_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={350.0,160.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_3_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1215,
    nPorts=nAir1215,
    V=15.876000000000003)
    "Huis nr 3_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={47.5,-65.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_3_Inkom(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1221,
    nPorts=nAir1221,
    V=24.947999999999993)
    "Huis nr 3_Inkom"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={47.5,-38.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_3_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1229,
    nPorts=nAir1229,
    V=89.90800000000003)
    "Huis nr 3_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={92.625,-46.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_3_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1206,
    nPorts=nAir1206,
    V=61.992)
    "Huis nr 3_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={13.500000000000004,-50.83333333333334})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_5_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1198,
    nPorts=nAir1198,
    V=18.48)
    "Huis nr 5_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-22.0,-65.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_5_Inkom(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1183,
    nPorts=nAir1183,
    V=21.168000000000006)
    "Huis nr 5_Inkom"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-42.60000000000001,-50.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_5_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1156,
    nPorts=nAir1156,
    V=100.072)
    "Huis  nr 5_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-91.66666666666669,-45.666666666666664})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_5_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1192,
    nPorts=nAir1192,
    V=26.880000000000003)
    "Huis nr 5_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-22.0,-38.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_7_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1087,
    nPorts=nAir1087,
    V=25.872000000000025)
    "Huis nr 7_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-273.0,-59.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_7_Inkom(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1110,
    nPorts=nAir1110,
    V=17.052000000000007)
    "Huis  nr 7_Inkom"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-224.50000000000003,-32.5})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_7_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1120,
    nPorts=nAir1120,
    V=110.34800000000003)
    "Huis  nr 7_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-248.75,-9.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_7_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1101,
    nPorts=nAir1101,
    V=45.27600000000004)
    "Huis  nr 7_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-235.40000000000003,-56.2})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_9_Badkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1055,
    nPorts=nAir1055,
    V=20.160000000000007)
    "Huis nr 9_Badkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-383.00000000000006,-64.0})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_9_Leefruimte(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1070,
    nPorts=nAir1070,
    V=117.852)
    "Huis nr 9_Leefruimte"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-331.1428571428572,-44.57142857142857})));
  IDEAS.Buildings.Components.Zone zone__Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1062,
    nPorts=nAir1062,
    V=34.440000000000026)
    "Huis nr 9_Slaapkamer"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-386.0000000000001,-31.400000000000002})));
  IDEAS.Buildings.Components.Zone zone__Inkom_tech_lokaal_1_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1046,
    nPorts=nAir1046,
    V=10.639999999999992)
    "Inkom tech lokaal 1_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-407.5,-21.0})));
  IDEAS.Buildings.Components.Zone zone__Inkom_tech_lokaal_2_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1246,
    nPorts=nAir1246,
    V=8.092000000000006)
    "Inkom tech lokaal 2_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={99.5,-30.500000000000004})));
  IDEAS.Buildings.Components.Zone zone__Inkom_tech_lokaal_3_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1335,
    nPorts=nAir1335,
    V=8.092000000000022)
    "Inkom tech lokaal 3_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-377.5,123.50000000000001})));
  IDEAS.Buildings.Components.Zone zone__Inkom_tech_ruimte_4_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1479,
    nPorts=nAir1479,
    V=7.055999999999996)
    "Inkom tech ruimte 4_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={15.0,135.0})));
  IDEAS.Buildings.Components.Zone zone__Inkom_tech_ruimte_5_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1599,
    nPorts=nAir1599,
    V=11.2)
    "Inkom tech ruimte 5_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={322.0,133.0})));
  IDEAS.Buildings.Components.Zone zone__Inkom_tech_ruimte_6_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1680,
    nPorts=nAir1680,
    V=11.088000000000022)
    "Inkom tech ruimte 6_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={320.0,16.0})));
  IDEAS.Buildings.Components.Zone zone__Technische_ruimte_BEO_UC(
    redeclare package Medium=MediumAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.AirTight interzonalAirFlow,
    allowFlowReversal=true,
    n50=3,
    final mSenFac=mSenFac,
    T_start=T_start_fixed,
    nSurf=nSurf1602,
    nPorts=nAir1602,
    V=85.51199999999993)
    "Technische ruimte BEO_UC"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={193.0909090909091,106.72727272727273})));
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_11__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.12703055555555576);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_13__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.11312777777777781);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_15__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.12329722222222217);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_17__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.13434166666666666);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_19__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.1147027777777777);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_21__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.11211666666666661);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_23__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.11324444444444438);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_25__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.11223333333333341);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_27__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.13486666666666663);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_29__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.09698888888888889);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_31__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.10958888888888886);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_3__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.13383611111111116);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_5__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.11569444444444446);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_7__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.13788055555555565);
  IDEAS.Fluid.FixedResistances.LosslessPipe floorHeating__TABS_huis_nr_9__supplyPipe(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.11975833333333336);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.00833333,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0416667,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22__ret(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.025,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_11_Badkamer__CAVr_type_15(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_13_Badkamer__CAVr_type_1(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_15_Badkamer__CAVr_type_2(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_17_Badkamer__CAVr_type_3(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_19_Badkamer__CAVr_type_4(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_21_Badkamer__CAVr_type_5(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_23_Badkamer__CAVr_type_6(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_25_Badkamer__CAVr_type_10(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_27_Badkamer__CAVr_type_9(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_29_Badkamer__CAVr_type_7(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_31_Badkamer__CAVr_type_8(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_3_Badkamer__CAVr_type_11(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_5_Badkamer__CAVr_type_12(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_7_Badkamer__CAVr_type_13(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop returnCav_zone__Huis_nr_9_Badkamer__CAVr_type_14(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.FixedResistances.PressureDrop supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14(
    redeclare package Medium=MediumAir,
    m_flow_nominal=0.0166667,
    allowFlowReversal=false,
    from_dp=true,
    dp_nominal=100);
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_11_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.022400000000000076,
    dp_nominal=20000,
    A_floor=11.520000000000039,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_11_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.07476388888888909,
    dp_nominal=20000,
    A_floor=38.4500000000001,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_11_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.029866666666666583,
    dp_nominal=20000,
    A_floor=15.359999999999957,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_13_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.021466666666666707,
    dp_nominal=20000,
    A_floor=11.04000000000002,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_13_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.0639333333333334,
    dp_nominal=20000,
    A_floor=32.88000000000004,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_13_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.027727777777777705,
    dp_nominal=20000,
    A_floor=14.259999999999962,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_15_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.013261111111111126,
    dp_nominal=20000,
    A_floor=6.820000000000007,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_15_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.07832222222222215,
    dp_nominal=20000,
    A_floor=40.279999999999966,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_15_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.031713888888888896,
    dp_nominal=20000,
    A_floor=16.310000000000002,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_17_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.016333333333333318,
    dp_nominal=20000,
    A_floor=8.399999999999991,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_17_Inkom(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.011841666666666674,
    dp_nominal=20000,
    A_floor=6.090000000000003,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_17_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.07758333333333335,
    dp_nominal=20000,
    A_floor=39.900000000000006,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_17_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.02858333333333333,
    dp_nominal=20000,
    A_floor=14.699999999999996,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_19_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.01189999999999999,
    dp_nominal=20000,
    A_floor=6.119999999999996,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_19_Inkom(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.012191666666666646,
    dp_nominal=20000,
    A_floor=6.269999999999989,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_19_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.0681333333333333,
    dp_nominal=20000,
    A_floor=35.039999999999985,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_19_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.022477777777777767,
    dp_nominal=20000,
    A_floor=11.559999999999995,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_21_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.011549999999999996,
    dp_nominal=20000,
    A_floor=5.939999999999998,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_21_Inkom(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.013883333333333327,
    dp_nominal=20000,
    A_floor=7.139999999999997,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_21_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.0655083333333333,
    dp_nominal=20000,
    A_floor=33.68999999999998,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_21_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.021174999999999992,
    dp_nominal=20000,
    A_floor=10.889999999999997,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_23_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.013999999999999992,
    dp_nominal=20000,
    A_floor=7.199999999999996,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_23_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.07357777777777774,
    dp_nominal=20000,
    A_floor=37.83999999999998,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_23_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.02566666666666666,
    dp_nominal=20000,
    A_floor=13.199999999999996,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_25_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.0112777777777778,
    dp_nominal=20000,
    A_floor=5.800000000000011,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_25_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.0800916666666667,
    dp_nominal=20000,
    A_floor=41.19000000000001,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_25_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.020863888888888897,
    dp_nominal=20000,
    A_floor=10.730000000000004,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_27_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.012249999999999968,
    dp_nominal=20000,
    A_floor=6.299999999999983,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_27_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.08586666666666669,
    dp_nominal=20000,
    A_floor=44.16000000000001,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_27_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.036749999999999984,
    dp_nominal=20000,
    A_floor=18.89999999999999,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_29_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.009799999999999998,
    dp_nominal=20000,
    A_floor=5.039999999999999,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_29_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.06758888888888889,
    dp_nominal=20000,
    A_floor=34.76,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_29_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.019599999999999996,
    dp_nominal=20000,
    A_floor=10.079999999999998,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_31_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.013222222222222217,
    dp_nominal=20000,
    A_floor=6.799999999999997,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_31_Inkom(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.030352777777777763,
    dp_nominal=20000,
    A_floor=15.609999999999992,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_31_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.042213888888888884,
    dp_nominal=20000,
    A_floor=21.709999999999994,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_31_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.02379999999999999,
    dp_nominal=20000,
    A_floor=12.239999999999995,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_3_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.011025000000000004,
    dp_nominal=20000,
    A_floor=5.670000000000002,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_3_Inkom(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.017324999999999997,
    dp_nominal=20000,
    A_floor=8.909999999999998,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_3_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.06243611111111114,
    dp_nominal=20000,
    A_floor=32.110000000000014,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_3_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.043050000000000005,
    dp_nominal=20000,
    A_floor=22.14,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_5_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.012833333333333334,
    dp_nominal=20000,
    A_floor=6.6000000000000005,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_5_Inkom(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.014700000000000005,
    dp_nominal=20000,
    A_floor=7.560000000000002,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_5_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.06949444444444444,
    dp_nominal=20000,
    A_floor=35.74,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_5_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.01866666666666667,
    dp_nominal=20000,
    A_floor=9.600000000000001,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_7_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.017966666666666683,
    dp_nominal=20000,
    A_floor=9.240000000000009,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_7_Inkom(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.011841666666666674,
    dp_nominal=20000,
    A_floor=6.090000000000003,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_7_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.07663055555555558,
    dp_nominal=20000,
    A_floor=39.41000000000001,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_7_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.0314416666666667,
    dp_nominal=20000,
    A_floor=16.170000000000016,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_9_Badkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.014000000000000005,
    dp_nominal=20000,
    A_floor=7.200000000000003,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_9_Leefruimte(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.08184166666666666,
    dp_nominal=20000,
    A_floor=42.09,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe_1_zone_Huis_nr_9_Slaapkamer(
    redeclare package Medium=MediumWater,
    m_flow_nominal=0.02391666666666669,
    dp_nominal=20000,
    A_floor=12.300000000000011,
    nParCir=1,
    nDiscr=1,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare radSlaCha__1 RadSlaCha(T = 0.15));
  IDEAS.Utilities.Time.Clock clock__1(timZon = timeZone__1);
  Modelica.Blocks.Math.RealToBoolean realToBoolean__1(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,-76.0},{503.00000000000006,-56.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__10(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,374.0},{503.00000000000006,394.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__11(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,424.0},{503.00000000000006,444.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__12(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,474.0},{503.00000000000006,494.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__13(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,524.0},{503.00000000000006,544.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__14(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,574.0},{503.00000000000006,594.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__15(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,624.0},{503.00000000000006,644.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__2(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,-26.0},{503.00000000000006,-6.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__3(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,24.0},{503.00000000000006,44.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__4(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,74.0},{503.00000000000006,94.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__5(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,124.0},{503.00000000000006,144.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__6(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,174.0},{503.00000000000006,194.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__7(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,224.0},{503.00000000000006,244.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__8(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,274.0},{503.00000000000006,294.0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean__9(
    threshold=Modelica.Constants.small,
    u=weeklyProfile__Always_on.y) annotation(Placement(transformation(extent={{483.00000000000006,324.0},{503.00000000000006,344.0}})));
  Modelica.Blocks.Sources.RealExpression weeklyProfile__Always_on(y=
    if
      (if abs(floor(clock__1.weekDay) - 1)<1e-4 then clock__1.hour >= weeklyProfile__Always_on_monday_on and clock__1.hour < weeklyProfile__Always_on_monday_off else
      if abs(floor(clock__1.weekDay) - 2)<1e-4 then clock__1.hour >= weeklyProfile__Always_on_tuesday_on and clock__1.hour < weeklyProfile__Always_on_tuesday_off else
      if abs(floor(clock__1.weekDay) - 3)<1e-4 then clock__1.hour >= weeklyProfile__Always_on_wednesday_on and clock__1.hour < weeklyProfile__Always_on_wednesday_off else
      if abs(floor(clock__1.weekDay) - 4)<1e-4 then clock__1.hour >= weeklyProfile__Always_on_thursday_on and clock__1.hour < weeklyProfile__Always_on_thursday_off else
      if abs(floor(clock__1.weekDay) - 5)<1e-4 then clock__1.hour >= weeklyProfile__Always_on_friday_on and clock__1.hour < weeklyProfile__Always_on_friday_off else
      if abs(floor(clock__1.weekDay) - 6)<1e-4 then clock__1.hour >= weeklyProfile__Always_on_saturday_on and clock__1.hour < weeklyProfile__Always_on_saturday_off else
      clock__1.hour >= weeklyProfile__Always_on_sunday_on and clock__1.hour < weeklyProfile__Always_on_sunday_off)
    then 1 else 0);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Fietsenstalling_2_UC(G=3.6736000000000004);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Fietsenstalling_UC(G=3.763200000000004);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_11_Badkamer(G=4.261600000000005);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_11_Leefruimte(G=7.079180000000006);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_11_Slaapkamer(G=3.3559999999999945);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_13_Badkamer(G=4.159200000000003);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_13_Leefruimte(G=6.761480000000006);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_13_Slaapkamer(G=3.192149999999994);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_15_Badkamer(G=1.556200000000001);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_15_Leefruimte(G=9.915479999999995);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_15_Slaapkamer(G=2.1697800000000007);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_17_Badkamer(G=1.5175999999999998);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_17_Inkom(G=1.1277000000000001);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_17_Leefruimte(G=8.642080000000002);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_17_Slaapkamer(G=3.9708800000000006);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_19_Badkamer(G=1.7880479999999994);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_19_Inkom(G=2.3938999999999986);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_19_Leefruimte(G=8.940679999999999);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_19_Slaapkamer(G=3.3144479999999996);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_21_Badkamer(G=1.5906);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_21_Inkom(G=1.4546000000000001);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_21_Leefruimte(G=6.912027999999999);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_21_Slaapkamer(G=2.64358);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_23_Badkamer(G=1.928);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_23_Leefruimte(G=9.35508);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_23_Slaapkamer(G=2.298848);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_25_Badkamer(G=1.4478000000000029);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_25_Leefruimte(G=10.249309007466607);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_25_Slaapkamer(G=1.8123800000000023);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_27_Badkamer(G=1.041599999999998);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_27_Leefruimte(G=14.418480000000002);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_27_Slaapkamer(G=5.320295999999999);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_29_Badkamer(G=1.3496000000000004);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_29_Leefruimte(G=8.555680000000002);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_29_Slaapkamer(G=1.7406800000000002);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_31_Badkamer(G=1.1239999999999999);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_31_Inkom(G=5.437319258471894);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_31_Leefruimte(G=6.433822810282649);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_31_Slaapkamer(G=2.1150480000000003);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_3_Badkamer(G=1.3419);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_3_Inkom(G=1.5039);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_3_Leefruimte(G=8.323780000000001);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_3_Slaapkamer(G=4.392248);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_5_Badkamer(G=1.506);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_5_Inkom(G=1.4756000000000005);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_5_Leefruimte(G=9.99488);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_5_Slaapkamer(G=1.79508);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_7_Badkamer(G=1.5596000000000008);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_7_Inkom(G=1.1277000000000001);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_7_Leefruimte(G=8.578380000000001);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_7_Slaapkamer(G=4.1619800000000025);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_9_Badkamer(G=1.536);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_9_Leefruimte(G=9.92758);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Huis_nr_9_Slaapkamer(G=1.9300800000000007);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Inkom_tech_lokaal_1_UC(G=1.428799999999999);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Inkom_tech_lokaal_2_UC(G=1.8740000000000008);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Inkom_tech_lokaal_3_UC(G=1.1866000000000025);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Inkom_tech_ruimte_4_UC(G=1.0023999999999997);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Inkom_tech_ruimte_5_UC(G=2.3089999999999997);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Inkom_tech_ruimte_6_UC(G=2.3018000000000005);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon_space__Technische_ruimte_BEO_UC(G=14.28128);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Fietsenstalling_2_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Fietsenstalling_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_11_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_11_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_11_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_13_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_13_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_13_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_15_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_15_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_15_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_17_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_17_Inkom(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_17_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_17_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_19_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_19_Inkom(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_19_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_19_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_21_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_21_Inkom(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_21_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_21_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_23_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_23_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_23_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_25_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_25_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_25_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_27_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_27_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_27_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_29_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_29_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_29_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_31_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_31_Inkom(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_31_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_31_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_3_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_3_Inkom(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_3_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_3_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_5_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_5_Inkom(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_5_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_5_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_7_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_7_Inkom(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_7_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_7_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_9_Badkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_9_Leefruimte(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Huis_nr_9_Slaapkamer(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Inkom_tech_lokaal_1_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Inkom_tech_lokaal_2_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Inkom_tech_lokaal_3_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Inkom_tech_ruimte_4_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Inkom_tech_ruimte_5_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Inkom_tech_ruimte_6_UC(T=sim.Te);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem_space_Technische_ruimte_BEO_UC(T=sim.Te);
  UnitTests_Simulation.Circuits.CircuitCollector collector__Heating_collector(
    redeclare package Medium=MediumWater,
    m_flow_nominal=5) annotation(Placement(transformation(extent={{483.00000000000006,674.0},{503.00000000000006,694.0}})));
  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_11(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0416667,
    m2_flow_nominal=0.0416667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=166.66680000000002,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,624.0},{503.00000000000006,644.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_13(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0583333,
    m2_flow_nominal=0.0583333,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=233.33320000000003,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,-76.0},{503.00000000000006,-56.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_15(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0416667,
    m2_flow_nominal=0.0416667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=166.66680000000002,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,-26.0},{503.00000000000006,-6.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_17(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0666667,
    m2_flow_nominal=0.0666667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=266.6668,
    n_in=3,
    n_out=3) annotation(Placement(transformation(extent={{483.00000000000006,24.0},{503.00000000000006,44.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_19(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.05,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=200.00000000000006,
    n_in=3,
    n_out=3) annotation(Placement(transformation(extent={{483.00000000000006,74.0},{503.00000000000006,94.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_21(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.05,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=200.00000000000006,
    n_in=3,
    n_out=3) annotation(Placement(transformation(extent={{483.00000000000006,124.0},{503.00000000000006,144.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_23(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0416667,
    m2_flow_nominal=0.0416667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=166.66680000000002,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,174.0},{503.00000000000006,194.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_25(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0583333,
    m2_flow_nominal=0.0583333,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=233.33320000000003,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,374.0},{503.00000000000006,394.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_27(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0583333,
    m2_flow_nominal=0.0583333,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=233.33320000000003,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,324.0},{503.00000000000006,344.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_29(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0416667,
    m2_flow_nominal=0.0416667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=166.66680000000002,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,224.0},{503.00000000000006,244.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_3(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.05,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=200.00000000000006,
    n_in=3,
    n_out=3) annotation(Placement(transformation(extent={{483.00000000000006,424.0},{503.00000000000006,444.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_31(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0666667,
    m2_flow_nominal=0.0666667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=266.6668,
    n_in=3,
    n_out=3) annotation(Placement(transformation(extent={{483.00000000000006,274.0},{503.00000000000006,294.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_5(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.05,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=200.00000000000006,
    n_in=3,
    n_out=3) annotation(Placement(transformation(extent={{483.00000000000006,474.0},{503.00000000000006,494.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_7(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0666667,
    m2_flow_nominal=0.0666667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=266.6668,
    n_in=3,
    n_out=3) annotation(Placement(transformation(extent={{483.00000000000006,524.0},{503.00000000000006,544.0}})));

  IOCSmod.Simulation.SimpleAhu airHandlingUnit__AHU_huis_nr_9(
    redeclare package Medium=MediumAir,
    m1_flow_nominal=0.0416667,
    m2_flow_nominal=0.0416667,
    dp_fanRet=100,
    dp_fanSup=100,
    dp1_nominal=100,
    dp2_nominal=100,
    UA=166.66680000000002,
    n_in=2,
    n_out=2) annotation(Placement(transformation(extent={{483.00000000000006,574.0},{503.00000000000006,594.0}})));

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_11__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.12703055555555576,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.4461411967716038);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_13__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.11312777777777781,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.2878691998801746);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_15__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.12329722222222217,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.403640185018938);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_17__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.13434166666666666,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.5293723447872332);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_19__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.1147027777777777,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.305799314213328);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_21__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.11211666666666661,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.2763585091971605);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_23__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.11324444444444438,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.2891973564974442);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_25__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.11223333333333341,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.2776866658144328);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_27__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.13486666666666663,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.535349049564951);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_29__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.09698888888888889,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.1041408678243914);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_31__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.10958888888888886,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.2475817824896287);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_3__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.13383611111111116,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.5236169994457274);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_5__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.11569444444444446,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.3170886454601303);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_7__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.13788055555555565,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.5696597621777795);

  UnitTests_Simulation.Components.TwoWayLinear floorHeating__TABS_huis_nr_9__valve(
    redeclare package Medium=MediumWater,
    from_dp=true,
    m_flow_nominal=0.11975833333333336,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=1.3633527676283936);

  parameter Modelica.Units.SI.Time timeZone__1 = 0 "Time zone";
  record constructiontype__Default_floor_above_outside
     "Default floor above outside"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Ceiling,
    final mats={
      material__Tile(d=0.02),
      material__Screed(d=0.08),
      material__PUR(d=0.1),
      material__Concrete(d=0.15)});
  end constructiontype__Default_floor_above_outside;

  record constructiontype__Default_floor_above_outside_inv
     "Default floor above outside"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Floor,
    final mats={
      material__Concrete(d=0.15),
      material__PUR(d=0.1),
      material__Screed(d=0.08),
      material__Tile(d=0.02)});
  end constructiontype__Default_floor_above_outside_inv;

  record constructiontype__Default_floor_on_ground
     "Default floor on ground"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Ceiling,
    final mats={
      material__Tile(d=0.015),
      material__Screed(d=0.075),
      material__EPS(d=0.08),
      material__Concrete(d=0.12)});
  end constructiontype__Default_floor_on_ground;

  record constructiontype__Default_floor_on_ground_inv
     "Default floor on ground"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Floor,
    final mats={
      material__Concrete(d=0.12),
      material__EPS(d=0.08),
      material__Screed(d=0.075),
      material__Tile(d=0.015)});
  end constructiontype__Default_floor_on_ground_inv;

  record constructiontype__Default_internal_floor
     "Default internal floor"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Ceiling,
    final mats={
      material__Plywood(d=0.02),
      material__Rockwool(d=0.22),
      material__Gypsum(d=0.02)});
  end constructiontype__Default_internal_floor;

  record constructiontype__Default_internal_floor_inv
     "Default internal floor"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Floor,
    final mats={
      material__Gypsum(d=0.02),
      material__Rockwool(d=0.22),
      material__Plywood(d=0.02)});
  end constructiontype__Default_internal_floor_inv;

  record constructiontype__Default_internal_wall
     "Default internal wall"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Minerale_isolatieplaat(d=0.05),
      material__Brick(d=0.21),
      material__Minerale_isolatieplaat(d=0.05)});
  end constructiontype__Default_internal_wall;

  record constructiontype__Default_internal_wall_inv
     "Default internal wall"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Minerale_isolatieplaat(d=0.05),
      material__Brick(d=0.21),
      material__Minerale_isolatieplaat(d=0.05)});
  end constructiontype__Default_internal_wall_inv;

  record constructiontype__Default_outer_wall
     "Default outer wall"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Brick(d=0.33),
      material__Minerale_isolatieplaat(d=0.14)});
  end constructiontype__Default_outer_wall;

  record constructiontype__Default_outer_wall_inv
     "Default outer wall"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Minerale_isolatieplaat(d=0.14),
      material__Brick(d=0.33)});
  end constructiontype__Default_outer_wall_inv;

  record constructiontype__Default_roof
     "Default roof"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Ceiling,
    final mats={
      material__Plywood(d=0.02),
      material__Rockwool(d=0.22),
      material__Gypsum(d=0.02)});
  end constructiontype__Default_roof;

  record constructiontype__Default_roof_inv
     "Default roof"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Floor,
    final mats={
      material__Gypsum(d=0.02),
      material__Rockwool(d=0.22),
      material__Plywood(d=0.02)});
  end constructiontype__Default_roof_inv;

  record constructiontype__Internal_wall_33cm
     "Internal wall_33cm"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Minerale_isolatieplaat(d=0.05),
      material__Brick(d=0.33),
      material__Minerale_isolatieplaat(d=0.05)});
  end constructiontype__Internal_wall_33cm;

  record constructiontype__Internal_wall_33cm_inv
     "Internal wall_33cm"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Minerale_isolatieplaat(d=0.05),
      material__Brick(d=0.33),
      material__Minerale_isolatieplaat(d=0.05)});
  end constructiontype__Internal_wall_33cm_inv;

  record constructiontype__Internal_wall_Ytong
     "Internal wall_Ytong"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Ytong(d=0.1)});
  end constructiontype__Internal_wall_Ytong;

  record constructiontype__Internal_wall_Ytong_inv
     "Internal wall_Ytong"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Ytong(d=0.1)});
  end constructiontype__Internal_wall_Ytong_inv;

  record constructiontype__Internal_wall_Ytonginsulation
     "Internal wall_Ytong+insulation"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Ytong(d=0.1),
      material__Rockwool(d=0.05),
      material__Ytong(d=0.1)});
  end constructiontype__Internal_wall_Ytonginsulation;

  record constructiontype__Internal_wall_Ytonginsulation_inv
     "Internal wall_Ytong+insulation"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
     incLastLay=IDEAS.Types.Tilt.Wall,
    final mats={
      material__Ytong(d=0.1),
      material__Rockwool(d=0.05),
      material__Ytong(d=0.1)});
  end constructiontype__Internal_wall_Ytonginsulation_inv;

  record glazingtype__Double_glazing=IDEAS.Buildings.Data.Glazing.Ins2Ar2020;
  record material__Brick = IDEAS.Buildings.Data.Interfaces.Material (k=0.89, c=800, rho=1920, epsLw=0.88, epsSw=0.55, gas=false) "Brick";
  record material__Concrete = IDEAS.Buildings.Data.Interfaces.Material (k=1.4, c=900, rho=2240, epsLw=0.88, epsSw=0.55, gas=false) "Concrete";
  record material__EPS = IDEAS.Buildings.Data.Interfaces.Material (k=0.036, c=1470, rho=26, epsLw=0.8, epsSw=0.8, gas=false) "EPS";
  record material__Gypsum = IDEAS.Buildings.Data.Interfaces.Material (k=0.38, c=840, rho=1120, epsLw=0.85, epsSw=0.65, gas=false) "Gypsum";
  record material__Minerale_isolatieplaat =
      IDEAS.Buildings.Data.Interfaces.Material (                                      k=0.043, c=840, rho=115, epsLw=0.8, epsSw=0.8, gas=false) "Minerale isolatieplaat";
  record material__PUR = IDEAS.Buildings.Data.Interfaces.Material (k=0.025, c=1470, rho=30, epsLw=0.8, epsSw=0.8, gas=false) "PUR";
  record material__Plywood = IDEAS.Buildings.Data.Interfaces.Material (k=0.15, c=1880, rho=540, epsLw=0.86, epsSw=0.44, gas=false) "Plywood";
  record material__Rockwool = IDEAS.Buildings.Data.Interfaces.Material (k=0.036, c=840, rho=110, epsLw=0.8, epsSw=0.8, gas=false) "Rockwool";
  record material__Screed = IDEAS.Buildings.Data.Interfaces.Material (k=0.45, c=840, rho=2100, epsLw=0.88, epsSw=0.55, gas=false) "Screed";
  record material__Tile = IDEAS.Buildings.Data.Interfaces.Material (k=1.4, c=840, rho=2100, epsLw=0.88, epsSw=0.55, gas=false) "Tile";
  record material__Ytong = IDEAS.Buildings.Data.Interfaces.Material (k=0.09, c=1000, rho=350, epsLw=0.8, epsSw=0.8, gas=false) "Ytong";
  record radSlaCha__1 "Tabs properties"
    extends IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar(
      tabs = true,
      d_a = 0.02,
      s_r = 0.0023,
      lambda_r = 0.35,
      S_1 = 0.15,
      S_2 = 0.15,
      lambda_b = 1.4,
      c_b = 840,
      rho_b = 2100);
     parameter Real m_flow_nominal_spe(unit="kg/(s.m2)") = 5 / 3600
      "Nominal mass flow rate per square meter floor heating";

  end radSlaCha__1;

  record tabstype__Floor_heating
     "Floor heating"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
      locGain={2},
      incLastLay=IDEAS.Types.Tilt.Ceiling,
      final mats={
        material__Tile(d=0.015),
        material__Screed(d=0.075),
        material__EPS(d=0.08),
        material__Concrete(d=0.12)});
  end tabstype__Floor_heating;

  record tabstype__Floor_heating_inv
     "Floor heating"
    extends IDEAS.Buildings.Data.Interfaces.Construction(
      locGain={2},
      incLastLay=IDEAS.Types.Tilt.Floor,
      final mats={
        material__Concrete(d=0.12),
        material__EPS(d=0.08),
        material__Screed(d=0.075),
        material__Tile(d=0.015)});
  end tabstype__Floor_heating_inv;
  // final declarations part 0
  final parameter Integer nAir1014 = 1 "Number of air connections to zone zone__Huis_nr_11_Badkamer";
  final parameter Integer nAir1021 = 1 "Number of air connections to zone zone__Huis_nr_11_Slaapkamer";
  final parameter Integer nAir1030 = 2 "Number of air connections to zone zone__Huis_nr_11_Leefruimte";
  final parameter Integer nAir1046 = 0 "Number of air connections to zone zone__Inkom_tech_lokaal_1_UC";
  final parameter Integer nAir1055 = 1 "Number of air connections to zone zone__Huis_nr_9_Badkamer";
  final parameter Integer nAir1062 = 1 "Number of air connections to zone zone__Huis_nr_9_Slaapkamer";
  final parameter Integer nAir1070 = 2 "Number of air connections to zone zone__Huis_nr_9_Leefruimte";
  final parameter Integer nAir1087 = 1 "Number of air connections to zone zone__Huis_nr_7_Badkamer";
  final parameter Integer nAir1101 = 1 "Number of air connections to zone zone__Huis_nr_7_Slaapkamer";
  final parameter Integer nAir1110 = 2 "Number of air connections to zone zone__Huis_nr_7_Inkom";
  final parameter Integer nAir1120 = 2 "Number of air connections to zone zone__Huis_nr_7_Leefruimte";
  final parameter Integer nAir1147 = 0 "Number of air connections to zone zone__Fietsenstalling_2_UC";
  final parameter Integer nAir1156 = 2 "Number of air connections to zone zone__Huis_nr_5_Leefruimte";
  final parameter Integer nAir1183 = 2 "Number of air connections to zone zone__Huis_nr_5_Inkom";
  final parameter Integer nAir1192 = 1 "Number of air connections to zone zone__Huis_nr_5_Slaapkamer";
  final parameter Integer nAir1198 = 1 "Number of air connections to zone zone__Huis_nr_5_Badkamer";
  final parameter Integer nAir1206 = 1 "Number of air connections to zone zone__Huis_nr_3_Slaapkamer";
  final parameter Integer nAir1215 = 1 "Number of air connections to zone zone__Huis_nr_3_Badkamer";
  final parameter Integer nAir1221 = 2 "Number of air connections to zone zone__Huis_nr_3_Inkom";
  final parameter Integer nAir1229 = 2 "Number of air connections to zone zone__Huis_nr_3_Leefruimte";
  final parameter Integer nAir1246 = 0 "Number of air connections to zone zone__Inkom_tech_lokaal_2_UC";
  final parameter Integer nAir1254 = 1 "Number of air connections to zone zone__Huis_nr_13_Badkamer";
  final parameter Integer nAir1268 = 1 "Number of air connections to zone zone__Huis_nr_13_Slaapkamer";
  final parameter Integer nAir1277 = 2 "Number of air connections to zone zone__Huis_nr_13_Leefruimte";
  final parameter Integer nAir1295 = 1 "Number of air connections to zone zone__Huis_nr_15_Badkamer";
  final parameter Integer nAir1303 = 1 "Number of air connections to zone zone__Huis_nr_15_Slaapkamer";
  final parameter Integer nAir1321 = 2 "Number of air connections to zone zone__Huis_nr_15_Leefruimte";
  final parameter Integer nAir1335 = 0 "Number of air connections to zone zone__Inkom_tech_lokaal_3_UC";
  final parameter Integer nAir1342 = 1 "Number of air connections to zone zone__Huis_nr_17_Badkamer";
  final parameter Integer nAir1349 = 1 "Number of air connections to zone zone__Huis_nr_17_Slaapkamer";
  final parameter Integer nAir1358 = 2 "Number of air connections to zone zone__Huis_nr_17_Inkom";
  final parameter Integer nAir1364 = 2 "Number of air connections to zone zone__Huis_nr_17_Leefruimte";
  final parameter Integer nAir1384 = 0 "Number of air connections to zone zone__Fietsenstalling_UC";
  final parameter Integer nAir1394 = 2 "Number of air connections to zone zone__Huis_nr_19_Inkom";
  final parameter Integer nAir1408 = 2 "Number of air connections to zone zone__Huis_nr_19_Leefruimte";
  final parameter Integer nAir1423 = 1 "Number of air connections to zone zone__Huis_nr_19_Slaapkamer";
  final parameter Integer nAir1431 = 1 "Number of air connections to zone zone__Huis_nr_19_Badkamer";
  final parameter Integer nAir1440 = 1 "Number of air connections to zone zone__Huis_nr_21_Badkamer";
  final parameter Integer nAir1448 = 1 "Number of air connections to zone zone__Huis_nr_21_Slaapkamer";
  final parameter Integer nAir1457 = 2 "Number of air connections to zone zone__Huis_nr_21_Inkom";
  final parameter Integer nAir1466 = 2 "Number of air connections to zone zone__Huis_nr_21_Leefruimte";
  final parameter Integer nAir1479 = 0 "Number of air connections to zone zone__Inkom_tech_ruimte_4_UC";
  final parameter Integer nAir1488 = 1 "Number of air connections to zone zone__Huis_nr_23_Badkamer";
  final parameter Integer nAir1495 = 1 "Number of air connections to zone zone__Huis_nr_23_Slaapkamer";
  final parameter Integer nAir1503 = 2 "Number of air connections to zone zone__Huis_nr_23_Leefruimte";
  final parameter Integer nAir1532 = 2 "Number of air connections to zone zone__Huis_nr_29_Leefruimte";
  final parameter Integer nAir1554 = 1 "Number of air connections to zone zone__Huis_nr_29_Badkamer";
  final parameter Integer nAir1560 = 1 "Number of air connections to zone zone__Huis_nr_29_Slaapkamer";
  final parameter Integer nAir1569 = 1 "Number of air connections to zone zone__Huis_nr_31_Badkamer";
  final parameter Integer nAir1578 = 1 "Number of air connections to zone zone__Huis_nr_31_Slaapkamer";
  final parameter Integer nAir1587 = 2 "Number of air connections to zone zone__Huis_nr_31_Leefruimte";
  final parameter Integer nAir1594 = 2 "Number of air connections to zone zone__Huis_nr_31_Inkom";
  final parameter Integer nAir1599 = 0 "Number of air connections to zone zone__Inkom_tech_ruimte_5_UC";
  final parameter Integer nAir1602 = 0 "Number of air connections to zone zone__Technische_ruimte_BEO_UC";
  final parameter Integer nAir1632 = 2 "Number of air connections to zone zone__Huis_nr_27_Leefruimte";
  final parameter Integer nAir1665 = 1 "Number of air connections to zone zone__Huis_nr_27_Slaapkamer";
  final parameter Integer nAir1673 = 1 "Number of air connections to zone zone__Huis_nr_27_Badkamer";
  final parameter Integer nAir1680 = 0 "Number of air connections to zone zone__Inkom_tech_ruimte_6_UC";
  final parameter Integer nAir1697 = 1 "Number of air connections to zone zone__Huis_nr_25_Slaapkamer";
  final parameter Integer nAir1704 = 1 "Number of air connections to zone zone__Huis_nr_25_Badkamer";
  final parameter Integer nAir1712 = 2 "Number of air connections to zone zone__Huis_nr_25_Leefruimte";
  final parameter Integer nSurf1014 = 7 "Number of connections to zone zone__Huis_nr_11_Badkamer";
  final parameter Integer nSurf1021 = 7 "Number of connections to zone zone__Huis_nr_11_Slaapkamer";
  final parameter Integer nSurf1030 = 11 "Number of connections to zone zone__Huis_nr_11_Leefruimte";
  final parameter Integer nSurf1046 = 6 "Number of connections to zone zone__Inkom_tech_lokaal_1_UC";
  final parameter Integer nSurf1055 = 6 "Number of connections to zone zone__Huis_nr_9_Badkamer";
  final parameter Integer nSurf1062 = 8 "Number of connections to zone zone__Huis_nr_9_Slaapkamer";
  final parameter Integer nSurf1070 = 11 "Number of connections to zone zone__Huis_nr_9_Leefruimte";
  final parameter Integer nSurf1087 = 6 "Number of connections to zone zone__Huis_nr_7_Badkamer";
  final parameter Integer nSurf1101 = 8 "Number of connections to zone zone__Huis_nr_7_Slaapkamer";
  final parameter Integer nSurf1110 = 6 "Number of connections to zone zone__Huis_nr_7_Inkom";
  final parameter Integer nSurf1120 = 12 "Number of connections to zone zone__Huis_nr_7_Leefruimte";
  final parameter Integer nSurf1147 = 6 "Number of connections to zone zone__Fietsenstalling_2_UC";
  final parameter Integer nSurf1156 = 10 "Number of connections to zone zone__Huis_nr_5_Leefruimte";
  final parameter Integer nSurf1183 = 7 "Number of connections to zone zone__Huis_nr_5_Inkom";
  final parameter Integer nSurf1192 = 7 "Number of connections to zone zone__Huis_nr_5_Slaapkamer";
  final parameter Integer nSurf1198 = 6 "Number of connections to zone zone__Huis_nr_5_Badkamer";
  final parameter Integer nSurf1206 = 9 "Number of connections to zone zone__Huis_nr_3_Slaapkamer";
  final parameter Integer nSurf1215 = 6 "Number of connections to zone zone__Huis_nr_3_Badkamer";
  final parameter Integer nSurf1221 = 6 "Number of connections to zone zone__Huis_nr_3_Inkom";
  final parameter Integer nSurf1229 = 12 "Number of connections to zone zone__Huis_nr_3_Leefruimte";
  final parameter Integer nSurf1246 = 7 "Number of connections to zone zone__Inkom_tech_lokaal_2_UC";
  final parameter Integer nSurf1254 = 7 "Number of connections to zone zone__Huis_nr_13_Badkamer";
  final parameter Integer nSurf1268 = 7 "Number of connections to zone zone__Huis_nr_13_Slaapkamer";
  final parameter Integer nSurf1277 = 10 "Number of connections to zone zone__Huis_nr_13_Leefruimte";
  final parameter Integer nSurf1295 = 6 "Number of connections to zone zone__Huis_nr_15_Badkamer";
  final parameter Integer nSurf1303 = 10 "Number of connections to zone zone__Huis_nr_15_Slaapkamer";
  final parameter Integer nSurf1321 = 12 "Number of connections to zone zone__Huis_nr_15_Leefruimte";
  final parameter Integer nSurf1335 = 6 "Number of connections to zone zone__Inkom_tech_lokaal_3_UC";
  final parameter Integer nSurf1342 = 6 "Number of connections to zone zone__Huis_nr_17_Badkamer";
  final parameter Integer nSurf1349 = 8 "Number of connections to zone zone__Huis_nr_17_Slaapkamer";
  final parameter Integer nSurf1358 = 6 "Number of connections to zone zone__Huis_nr_17_Inkom";
  final parameter Integer nSurf1364 = 12 "Number of connections to zone zone__Huis_nr_17_Leefruimte";
  final parameter Integer nSurf1384 = 6 "Number of connections to zone zone__Fietsenstalling_UC";
  final parameter Integer nSurf1394 = 8 "Number of connections to zone zone__Huis_nr_19_Inkom";
  final parameter Integer nSurf1408 = 11 "Number of connections to zone zone__Huis_nr_19_Leefruimte";
  final parameter Integer nSurf1423 = 7 "Number of connections to zone zone__Huis_nr_19_Slaapkamer";
  final parameter Integer nSurf1431 = 8 "Number of connections to zone zone__Huis_nr_19_Badkamer";
  final parameter Integer nSurf1440 = 6 "Number of connections to zone zone__Huis_nr_21_Badkamer";
  final parameter Integer nSurf1448 = 8 "Number of connections to zone zone__Huis_nr_21_Slaapkamer";
  final parameter Integer nSurf1457 = 8 "Number of connections to zone zone__Huis_nr_21_Inkom";
  final parameter Integer nSurf1466 = 11 "Number of connections to zone zone__Huis_nr_21_Leefruimte";
  final parameter Integer nSurf1479 = 6 "Number of connections to zone zone__Inkom_tech_ruimte_4_UC";
  final parameter Integer nSurf1488 = 6 "Number of connections to zone zone__Huis_nr_23_Badkamer";
  final parameter Integer nSurf1495 = 7 "Number of connections to zone zone__Huis_nr_23_Slaapkamer";
  final parameter Integer nSurf1503 = 13 "Number of connections to zone zone__Huis_nr_23_Leefruimte";
  final parameter Integer nSurf1532 = 13 "Number of connections to zone zone__Huis_nr_29_Leefruimte";
  final parameter Integer nSurf1554 = 6 "Number of connections to zone zone__Huis_nr_29_Badkamer";
  final parameter Integer nSurf1560 = 8 "Number of connections to zone zone__Huis_nr_29_Slaapkamer";
  final parameter Integer nSurf1569 = 7 "Number of connections to zone zone__Huis_nr_31_Badkamer";
  final parameter Integer nSurf1578 = 8 "Number of connections to zone zone__Huis_nr_31_Slaapkamer";
  final parameter Integer nSurf1587 = 8 "Number of connections to zone zone__Huis_nr_31_Leefruimte";
  final parameter Integer nSurf1594 = 10 "Number of connections to zone zone__Huis_nr_31_Inkom";
  final parameter Integer nSurf1599 = 7 "Number of connections to zone zone__Inkom_tech_ruimte_5_UC";
  final parameter Integer nSurf1602 = 14 "Number of connections to zone zone__Technische_ruimte_BEO_UC";
  final parameter Integer nSurf1632 = 20 "Number of connections to zone zone__Huis_nr_27_Leefruimte";
  final parameter Integer nSurf1665 = 8 "Number of connections to zone zone__Huis_nr_27_Slaapkamer";
  final parameter Integer nSurf1673 = 8 "Number of connections to zone zone__Huis_nr_27_Badkamer";
  final parameter Integer nSurf1680 = 7 "Number of connections to zone zone__Inkom_tech_ruimte_6_UC";
  final parameter Integer nSurf1697 = 8 "Number of connections to zone zone__Huis_nr_25_Slaapkamer";
  final parameter Integer nSurf1704 = 7 "Number of connections to zone zone__Huis_nr_25_Badkamer";
  final parameter Integer nSurf1712 = 15 "Number of connections to zone zone__Huis_nr_25_Leefruimte";
initial equation
                 // part 0
  (, T_start_exists) = jsonReader__1.getReal("T_start");
  T_start = Modelica.Units.Conversions.from_degC(jsonReader__1.getReal("T_start"));
  if not T_start_exists then
    Modelica.Utilities.Streams.error("Error: The identifier T_start does not exist in the json file.");
  end if;
  (, weeklyProfile_Always_on_friday_off_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_friday_off");
  (, weeklyProfile_Always_on_friday_on_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_friday_on");
  (, weeklyProfile_Always_on_monday_off_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_monday_off");
  (, weeklyProfile_Always_on_monday_on_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_monday_on");
  (, weeklyProfile_Always_on_saturday_off_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_saturday_off");
  (, weeklyProfile_Always_on_saturday_on_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_saturday_on");
  (, weeklyProfile_Always_on_sunday_off_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_sunday_off");
  (, weeklyProfile_Always_on_sunday_on_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_sunday_on");
  (, weeklyProfile_Always_on_thursday_off_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_thursday_off");
  (, weeklyProfile_Always_on_thursday_on_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_thursday_on");
  (, weeklyProfile_Always_on_tuesday_off_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_tuesday_off");
  (, weeklyProfile_Always_on_tuesday_on_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_tuesday_on");
  (, weeklyProfile_Always_on_wednesday_off_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_wednesday_off");
  (, weeklyProfile_Always_on_wednesday_on_exists) = jsonReader__1.getReal("weeklyProfile__Always_on_wednesday_on");
  if not weeklyProfile_Always_on_friday_off_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_friday_off does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_friday_on_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_friday_on does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_monday_off_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_monday_off does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_monday_on_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_monday_on does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_saturday_off_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_saturday_off does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_saturday_on_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_saturday_on does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_sunday_off_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_sunday_off does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_sunday_on_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_sunday_on does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_thursday_off_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_thursday_off does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_thursday_on_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_thursday_on does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_tuesday_off_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_tuesday_off does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_tuesday_on_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_tuesday_on does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_wednesday_off_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_wednesday_off does not exist in the json file.");
  end if;
  if not weeklyProfile_Always_on_wednesday_on_exists then
    Modelica.Utilities.Streams.error("Error: The identifier weeklyProfile__Always_on_wednesday_on does not exist in the json file.");
  end if;
  weeklyProfile__Always_on_friday_off = jsonReader__1.getReal("weeklyProfile__Always_on_friday_off");
  weeklyProfile__Always_on_friday_on = jsonReader__1.getReal("weeklyProfile__Always_on_friday_on");
  weeklyProfile__Always_on_monday_off = jsonReader__1.getReal("weeklyProfile__Always_on_monday_off");
  weeklyProfile__Always_on_monday_on = jsonReader__1.getReal("weeklyProfile__Always_on_monday_on");
  weeklyProfile__Always_on_saturday_off = jsonReader__1.getReal("weeklyProfile__Always_on_saturday_off");
  weeklyProfile__Always_on_saturday_on = jsonReader__1.getReal("weeklyProfile__Always_on_saturday_on");
  weeklyProfile__Always_on_sunday_off = jsonReader__1.getReal("weeklyProfile__Always_on_sunday_off");
  weeklyProfile__Always_on_sunday_on = jsonReader__1.getReal("weeklyProfile__Always_on_sunday_on");
  weeklyProfile__Always_on_thursday_off = jsonReader__1.getReal("weeklyProfile__Always_on_thursday_off");
  weeklyProfile__Always_on_thursday_on = jsonReader__1.getReal("weeklyProfile__Always_on_thursday_on");
  weeklyProfile__Always_on_tuesday_off = jsonReader__1.getReal("weeklyProfile__Always_on_tuesday_off");
  weeklyProfile__Always_on_tuesday_on = jsonReader__1.getReal("weeklyProfile__Always_on_tuesday_on");
  weeklyProfile__Always_on_wednesday_off = jsonReader__1.getReal("weeklyProfile__Always_on_wednesday_off");
  weeklyProfile__Always_on_wednesday_on = jsonReader__1.getReal("weeklyProfile__Always_on_wednesday_on");
equation
         // part 0
  connect(cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23.port_a,airHandlingUnit__AHU_huis_nr_11.port_b[2]);
  connect(cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23.port_b,zone__Huis_nr_11_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23__ret.port_a,zone__Huis_nr_11_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_11_Leefruimte__CAVsCAVr_type_23__ret.port_b,airHandlingUnit__AHU_huis_nr_11.port_a[2]);
  connect(cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2.port_a,airHandlingUnit__AHU_huis_nr_13.port_b[2]);
  connect(cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2.port_b,zone__Huis_nr_13_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2__ret.port_a,zone__Huis_nr_13_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_13_Leefruimte__CAVsCAVr_type_2__ret.port_b,airHandlingUnit__AHU_huis_nr_13.port_a[2]);
  connect(cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3.port_a,airHandlingUnit__AHU_huis_nr_15.port_b[2]);
  connect(cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3.port_b,zone__Huis_nr_15_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3__ret.port_a,zone__Huis_nr_15_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_15_Leefruimte__CAVsCAVr_type_3__ret.port_b,airHandlingUnit__AHU_huis_nr_15.port_a[2]);
  connect(cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5.port_a,airHandlingUnit__AHU_huis_nr_17.port_b[3]);
  connect(cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5.port_b,zone__Huis_nr_17_Inkom.ports[1]);
  connect(cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5__ret.port_a,zone__Huis_nr_17_Inkom.ports[2]);
  connect(cavs_zone__Huis_nr_17_Inkom__CAVsCAVr_type_5__ret.port_b,airHandlingUnit__AHU_huis_nr_17.port_a[3]);
  connect(cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4.port_a,airHandlingUnit__AHU_huis_nr_17.port_b[2]);
  connect(cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4.port_b,zone__Huis_nr_17_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4__ret.port_a,zone__Huis_nr_17_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_17_Leefruimte__CAVsCAVr_type_4__ret.port_b,airHandlingUnit__AHU_huis_nr_17.port_a[2]);
  connect(cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7.port_a,airHandlingUnit__AHU_huis_nr_19.port_b[3]);
  connect(cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7.port_b,zone__Huis_nr_19_Inkom.ports[1]);
  connect(cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7__ret.port_a,zone__Huis_nr_19_Inkom.ports[2]);
  connect(cavs_zone__Huis_nr_19_Inkom__CAVsCAVr_type_7__ret.port_b,airHandlingUnit__AHU_huis_nr_19.port_a[3]);
  connect(cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6.port_a,airHandlingUnit__AHU_huis_nr_19.port_b[2]);
  connect(cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6.port_b,zone__Huis_nr_19_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6__ret.port_a,zone__Huis_nr_19_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_19_Leefruimte__CAVsCAVr_type_6__ret.port_b,airHandlingUnit__AHU_huis_nr_19.port_a[2]);
  connect(cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8.port_a,airHandlingUnit__AHU_huis_nr_21.port_b[2]);
  connect(cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8.port_b,zone__Huis_nr_21_Inkom.ports[1]);
  connect(cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8__ret.port_a,zone__Huis_nr_21_Inkom.ports[2]);
  connect(cavs_zone__Huis_nr_21_Inkom__CAVsCAVr_type_8__ret.port_b,airHandlingUnit__AHU_huis_nr_21.port_a[2]);
  connect(cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9.port_a,airHandlingUnit__AHU_huis_nr_21.port_b[3]);
  connect(cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9.port_b,zone__Huis_nr_21_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9__ret.port_a,zone__Huis_nr_21_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_21_Leefruimte__CAVsCAVr_type_9__ret.port_b,airHandlingUnit__AHU_huis_nr_21.port_a[3]);
  connect(cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10.port_a,airHandlingUnit__AHU_huis_nr_23.port_b[2]);
  connect(cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10.port_b,zone__Huis_nr_23_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10__ret.port_a,zone__Huis_nr_23_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_23_Leefruimte__CAVsCAVr_type_10__ret.port_b,airHandlingUnit__AHU_huis_nr_23.port_a[2]);
  connect(cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14.port_a,airHandlingUnit__AHU_huis_nr_25.port_b[2]);
  connect(cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14.port_b,zone__Huis_nr_25_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14__ret.port_a,zone__Huis_nr_25_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_25_Leefruimte__CAVsCAVr_type_14__ret.port_b,airHandlingUnit__AHU_huis_nr_25.port_a[2]);
  connect(cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13.port_a,airHandlingUnit__AHU_huis_nr_27.port_b[2]);
  connect(cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13.port_b,zone__Huis_nr_27_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13__ret.port_a,zone__Huis_nr_27_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_27_Leefruimte__CAVsCAVr_type_13__ret.port_b,airHandlingUnit__AHU_huis_nr_27.port_a[2]);
  connect(cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11.port_a,airHandlingUnit__AHU_huis_nr_29.port_b[2]);
  connect(cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11.port_b,zone__Huis_nr_29_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11__ret.port_a,zone__Huis_nr_29_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_29_Leefruimte__CAVsCAVr_type_11__ret.port_b,airHandlingUnit__AHU_huis_nr_29.port_a[2]);
  connect(cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12.port_a,airHandlingUnit__AHU_huis_nr_31.port_b[3]);
  connect(cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12.port_b,zone__Huis_nr_31_Inkom.ports[1]);
  connect(cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12__ret.port_a,zone__Huis_nr_31_Inkom.ports[2]);
  connect(cavs_zone__Huis_nr_31_Inkom__CAVsCAVr_type_12__ret.port_b,airHandlingUnit__AHU_huis_nr_31.port_a[3]);
  connect(cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12.port_a,airHandlingUnit__AHU_huis_nr_31.port_b[2]);
  connect(cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12.port_b,zone__Huis_nr_31_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12__ret.port_a,zone__Huis_nr_31_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_31_Leefruimte__CAVsCAVr_type_12__ret.port_b,airHandlingUnit__AHU_huis_nr_31.port_a[2]);
  connect(cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16.port_a,airHandlingUnit__AHU_huis_nr_3.port_b[3]);
  connect(cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16.port_b,zone__Huis_nr_3_Inkom.ports[1]);
  connect(cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16__ret.port_a,zone__Huis_nr_3_Inkom.ports[2]);
  connect(cavs_zone__Huis_nr_3_Inkom__CAVsCAVr_type_16__ret.port_b,airHandlingUnit__AHU_huis_nr_3.port_a[3]);
  connect(cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15.port_a,airHandlingUnit__AHU_huis_nr_3.port_b[2]);
  connect(cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15.port_b,zone__Huis_nr_3_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15__ret.port_a,zone__Huis_nr_3_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_3_Leefruimte__CAVsCAVr_type_15__ret.port_b,airHandlingUnit__AHU_huis_nr_3.port_a[2]);
  connect(cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18.port_a,airHandlingUnit__AHU_huis_nr_5.port_b[2]);
  connect(cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18.port_b,zone__Huis_nr_5_Inkom.ports[1]);
  connect(cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18__ret.port_a,zone__Huis_nr_5_Inkom.ports[2]);
  connect(cavs_zone__Huis_nr_5_Inkom__CAVsCAVr_type_18__ret.port_b,airHandlingUnit__AHU_huis_nr_5.port_a[2]);
  connect(cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19.port_a,airHandlingUnit__AHU_huis_nr_5.port_b[3]);
  connect(cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19.port_b,zone__Huis_nr_5_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19__ret.port_a,zone__Huis_nr_5_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_5_Leefruimte__CAVsCAVr_type_19__ret.port_b,airHandlingUnit__AHU_huis_nr_5.port_a[3]);
  connect(cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21.port_a,airHandlingUnit__AHU_huis_nr_7.port_b[3]);
  connect(cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21.port_b,zone__Huis_nr_7_Inkom.ports[1]);
  connect(cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21__ret.port_a,zone__Huis_nr_7_Inkom.ports[2]);
  connect(cavs_zone__Huis_nr_7_Inkom__CAVsCAVr_type_21__ret.port_b,airHandlingUnit__AHU_huis_nr_7.port_a[3]);
  connect(cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20.port_a,airHandlingUnit__AHU_huis_nr_7.port_b[2]);
  connect(cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20.port_b,zone__Huis_nr_7_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20__ret.port_a,zone__Huis_nr_7_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_7_Leefruimte__CAVsCAVr_type_20__ret.port_b,airHandlingUnit__AHU_huis_nr_7.port_a[2]);
  connect(cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22.port_a,airHandlingUnit__AHU_huis_nr_9.port_b[2]);
  connect(cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22.port_b,zone__Huis_nr_9_Leefruimte.ports[1]);
  connect(cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22__ret.port_a,zone__Huis_nr_9_Leefruimte.ports[2]);
  connect(cavs_zone__Huis_nr_9_Leefruimte__CAVsCAVr_type_22__ret.port_b,airHandlingUnit__AHU_huis_nr_9.port_a[2]);
  connect(ceiling_zone_Fietsenstalling_2_UC.propsBus_a,zone__Fietsenstalling_2_UC.propsBus[2]);
  connect(ceiling_zone_Fietsenstalling_UC.propsBus_a,zone__Fietsenstalling_UC.propsBus[2]);
  connect(ceiling_zone_Huis_nr_11_Badkamer.propsBus_a,zone__Huis_nr_11_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_11_Leefruimte.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_11_Slaapkamer.propsBus_a,zone__Huis_nr_11_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_13_Badkamer.propsBus_a,zone__Huis_nr_13_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_13_Leefruimte.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_13_Slaapkamer.propsBus_a,zone__Huis_nr_13_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_15_Badkamer.propsBus_a,zone__Huis_nr_15_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_15_Leefruimte.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_15_Slaapkamer.propsBus_a,zone__Huis_nr_15_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_17_Badkamer.propsBus_a,zone__Huis_nr_17_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_17_Inkom.propsBus_a,zone__Huis_nr_17_Inkom.propsBus[2]);
  connect(ceiling_zone_Huis_nr_17_Leefruimte.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_17_Slaapkamer.propsBus_a,zone__Huis_nr_17_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_19_Badkamer.propsBus_a,zone__Huis_nr_19_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_19_Inkom.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[2]);
  connect(ceiling_zone_Huis_nr_19_Leefruimte.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_19_Slaapkamer.propsBus_a,zone__Huis_nr_19_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_21_Badkamer.propsBus_a,zone__Huis_nr_21_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_21_Inkom.propsBus_a,zone__Huis_nr_21_Inkom.propsBus[2]);
  connect(ceiling_zone_Huis_nr_21_Leefruimte.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_21_Slaapkamer.propsBus_a,zone__Huis_nr_21_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_23_Badkamer.propsBus_a,zone__Huis_nr_23_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_23_Leefruimte.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_23_Slaapkamer.propsBus_a,zone__Huis_nr_23_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_25_Badkamer.propsBus_a,zone__Huis_nr_25_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_25_Leefruimte.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_25_Slaapkamer.propsBus_a,zone__Huis_nr_25_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_27_Badkamer.propsBus_a,zone__Huis_nr_27_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_27_Leefruimte.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_27_Slaapkamer.propsBus_a,zone__Huis_nr_27_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_29_Badkamer.propsBus_a,zone__Huis_nr_29_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_29_Leefruimte.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_29_Slaapkamer.propsBus_a,zone__Huis_nr_29_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_31_Badkamer.propsBus_a,zone__Huis_nr_31_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_31_Inkom.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[2]);
  connect(ceiling_zone_Huis_nr_31_Leefruimte.propsBus_a,zone__Huis_nr_31_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_31_Slaapkamer.propsBus_a,zone__Huis_nr_31_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_3_Badkamer.propsBus_a,zone__Huis_nr_3_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_3_Inkom.propsBus_a,zone__Huis_nr_3_Inkom.propsBus[2]);
  connect(ceiling_zone_Huis_nr_3_Leefruimte.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_3_Slaapkamer.propsBus_a,zone__Huis_nr_3_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_5_Badkamer.propsBus_a,zone__Huis_nr_5_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_5_Inkom.propsBus_a,zone__Huis_nr_5_Inkom.propsBus[2]);
  connect(ceiling_zone_Huis_nr_5_Leefruimte.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_5_Slaapkamer.propsBus_a,zone__Huis_nr_5_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_7_Badkamer.propsBus_a,zone__Huis_nr_7_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_7_Inkom.propsBus_a,zone__Huis_nr_7_Inkom.propsBus[2]);
  connect(ceiling_zone_Huis_nr_7_Leefruimte.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_7_Slaapkamer.propsBus_a,zone__Huis_nr_7_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_9_Badkamer.propsBus_a,zone__Huis_nr_9_Badkamer.propsBus[2]);
  connect(ceiling_zone_Huis_nr_9_Leefruimte.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[2]);
  connect(ceiling_zone_Huis_nr_9_Slaapkamer.propsBus_a,zone__Huis_nr_9_Slaapkamer.propsBus[2]);
  connect(ceiling_zone_Inkom_tech_lokaal_1_UC.propsBus_a,zone__Inkom_tech_lokaal_1_UC.propsBus[2]);
  connect(ceiling_zone_Inkom_tech_lokaal_2_UC.propsBus_a,zone__Inkom_tech_lokaal_2_UC.propsBus[2]);
  connect(ceiling_zone_Inkom_tech_lokaal_3_UC.propsBus_a,zone__Inkom_tech_lokaal_3_UC.propsBus[2]);
  connect(ceiling_zone_Inkom_tech_ruimte_4_UC.propsBus_a,zone__Inkom_tech_ruimte_4_UC.propsBus[2]);
  connect(ceiling_zone_Inkom_tech_ruimte_5_UC.propsBus_a,zone__Inkom_tech_ruimte_5_UC.propsBus[2]);
  connect(ceiling_zone_Inkom_tech_ruimte_6_UC.propsBus_a,zone__Inkom_tech_ruimte_6_UC.propsBus[2]);
  connect(ceiling_zone_Technische_ruimte_BEO_UC.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[2]);
  connect(embeddedPipe_1_zone_Huis_nr_11_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_11_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_11_Badkamer.port_a,floorHeating__TABS_huis_nr_11__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_11_Badkamer.port_b,floorHeating__TABS_huis_nr_11__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_11_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_11_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_11_Leefruimte.port_a,floorHeating__TABS_huis_nr_11__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_11_Leefruimte.port_b,floorHeating__TABS_huis_nr_11__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_11_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_11_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_11_Slaapkamer.port_a,floorHeating__TABS_huis_nr_11__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_11_Slaapkamer.port_b,floorHeating__TABS_huis_nr_11__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_13_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_13_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_13_Badkamer.port_a,floorHeating__TABS_huis_nr_13__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_13_Badkamer.port_b,floorHeating__TABS_huis_nr_13__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_13_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_13_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_13_Leefruimte.port_a,floorHeating__TABS_huis_nr_13__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_13_Leefruimte.port_b,floorHeating__TABS_huis_nr_13__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_13_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_13_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_13_Slaapkamer.port_a,floorHeating__TABS_huis_nr_13__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_13_Slaapkamer.port_b,floorHeating__TABS_huis_nr_13__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_15_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_15_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_15_Badkamer.port_a,floorHeating__TABS_huis_nr_15__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_15_Badkamer.port_b,floorHeating__TABS_huis_nr_15__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_15_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_15_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_15_Leefruimte.port_a,floorHeating__TABS_huis_nr_15__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_15_Leefruimte.port_b,floorHeating__TABS_huis_nr_15__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_15_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_15_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_15_Slaapkamer.port_a,floorHeating__TABS_huis_nr_15__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_15_Slaapkamer.port_b,floorHeating__TABS_huis_nr_15__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_17_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_17_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_17_Badkamer.port_a,floorHeating__TABS_huis_nr_17__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_17_Badkamer.port_b,floorHeating__TABS_huis_nr_17__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_17_Inkom.heatPortEmb[1],slabOnGround_zone_Huis_nr_17_Inkom.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_17_Inkom.port_a,floorHeating__TABS_huis_nr_17__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_17_Inkom.port_b,floorHeating__TABS_huis_nr_17__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_17_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_17_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_17_Leefruimte.port_a,floorHeating__TABS_huis_nr_17__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_17_Leefruimte.port_b,floorHeating__TABS_huis_nr_17__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_17_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_17_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_17_Slaapkamer.port_a,floorHeating__TABS_huis_nr_17__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_17_Slaapkamer.port_b,floorHeating__TABS_huis_nr_17__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_19_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_19_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_19_Badkamer.port_a,floorHeating__TABS_huis_nr_19__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_19_Badkamer.port_b,floorHeating__TABS_huis_nr_19__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_19_Inkom.heatPortEmb[1],slabOnGround_zone_Huis_nr_19_Inkom.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_19_Inkom.port_a,floorHeating__TABS_huis_nr_19__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_19_Inkom.port_b,floorHeating__TABS_huis_nr_19__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_19_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_19_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_19_Leefruimte.port_a,floorHeating__TABS_huis_nr_19__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_19_Leefruimte.port_b,floorHeating__TABS_huis_nr_19__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_19_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_19_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_19_Slaapkamer.port_a,floorHeating__TABS_huis_nr_19__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_19_Slaapkamer.port_b,floorHeating__TABS_huis_nr_19__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_21_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_21_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_21_Badkamer.port_a,floorHeating__TABS_huis_nr_21__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_21_Badkamer.port_b,floorHeating__TABS_huis_nr_21__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_21_Inkom.heatPortEmb[1],slabOnGround_zone_Huis_nr_21_Inkom.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_21_Inkom.port_a,floorHeating__TABS_huis_nr_21__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_21_Inkom.port_b,floorHeating__TABS_huis_nr_21__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_21_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_21_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_21_Leefruimte.port_a,floorHeating__TABS_huis_nr_21__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_21_Leefruimte.port_b,floorHeating__TABS_huis_nr_21__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_21_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_21_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_21_Slaapkamer.port_a,floorHeating__TABS_huis_nr_21__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_21_Slaapkamer.port_b,floorHeating__TABS_huis_nr_21__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_23_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_23_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_23_Badkamer.port_a,floorHeating__TABS_huis_nr_23__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_23_Badkamer.port_b,floorHeating__TABS_huis_nr_23__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_23_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_23_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_23_Leefruimte.port_a,floorHeating__TABS_huis_nr_23__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_23_Leefruimte.port_b,floorHeating__TABS_huis_nr_23__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_23_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_23_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_23_Slaapkamer.port_a,floorHeating__TABS_huis_nr_23__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_23_Slaapkamer.port_b,floorHeating__TABS_huis_nr_23__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_25_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_25_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_25_Badkamer.port_a,floorHeating__TABS_huis_nr_25__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_25_Badkamer.port_b,floorHeating__TABS_huis_nr_25__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_25_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_25_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_25_Leefruimte.port_a,floorHeating__TABS_huis_nr_25__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_25_Leefruimte.port_b,floorHeating__TABS_huis_nr_25__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_25_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_25_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_25_Slaapkamer.port_a,floorHeating__TABS_huis_nr_25__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_25_Slaapkamer.port_b,floorHeating__TABS_huis_nr_25__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_27_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_27_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_27_Badkamer.port_a,floorHeating__TABS_huis_nr_27__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_27_Badkamer.port_b,floorHeating__TABS_huis_nr_27__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_27_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_27_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_27_Leefruimte.port_a,floorHeating__TABS_huis_nr_27__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_27_Leefruimte.port_b,floorHeating__TABS_huis_nr_27__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_27_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_27_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_27_Slaapkamer.port_a,floorHeating__TABS_huis_nr_27__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_27_Slaapkamer.port_b,floorHeating__TABS_huis_nr_27__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_29_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_29_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_29_Badkamer.port_a,floorHeating__TABS_huis_nr_29__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_29_Badkamer.port_b,floorHeating__TABS_huis_nr_29__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_29_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_29_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_29_Leefruimte.port_a,floorHeating__TABS_huis_nr_29__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_29_Leefruimte.port_b,floorHeating__TABS_huis_nr_29__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_29_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_29_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_29_Slaapkamer.port_a,floorHeating__TABS_huis_nr_29__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_29_Slaapkamer.port_b,floorHeating__TABS_huis_nr_29__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_31_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_31_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_31_Badkamer.port_a,floorHeating__TABS_huis_nr_31__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_31_Badkamer.port_b,floorHeating__TABS_huis_nr_31__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_31_Inkom.heatPortEmb[1],slabOnGround_zone_Huis_nr_31_Inkom.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_31_Inkom.port_a,floorHeating__TABS_huis_nr_31__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_31_Inkom.port_b,floorHeating__TABS_huis_nr_31__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_31_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_31_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_31_Leefruimte.port_a,floorHeating__TABS_huis_nr_31__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_31_Leefruimte.port_b,floorHeating__TABS_huis_nr_31__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_31_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_31_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_31_Slaapkamer.port_a,floorHeating__TABS_huis_nr_31__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_31_Slaapkamer.port_b,floorHeating__TABS_huis_nr_31__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_3_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_3_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_3_Badkamer.port_a,floorHeating__TABS_huis_nr_3__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_3_Badkamer.port_b,floorHeating__TABS_huis_nr_3__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_3_Inkom.heatPortEmb[1],slabOnGround_zone_Huis_nr_3_Inkom.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_3_Inkom.port_a,floorHeating__TABS_huis_nr_3__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_3_Inkom.port_b,floorHeating__TABS_huis_nr_3__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_3_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_3_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_3_Leefruimte.port_a,floorHeating__TABS_huis_nr_3__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_3_Leefruimte.port_b,floorHeating__TABS_huis_nr_3__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_3_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_3_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_3_Slaapkamer.port_a,floorHeating__TABS_huis_nr_3__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_3_Slaapkamer.port_b,floorHeating__TABS_huis_nr_3__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_5_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_5_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_5_Badkamer.port_a,floorHeating__TABS_huis_nr_5__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_5_Badkamer.port_b,floorHeating__TABS_huis_nr_5__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_5_Inkom.heatPortEmb[1],slabOnGround_zone_Huis_nr_5_Inkom.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_5_Inkom.port_a,floorHeating__TABS_huis_nr_5__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_5_Inkom.port_b,floorHeating__TABS_huis_nr_5__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_5_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_5_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_5_Leefruimte.port_a,floorHeating__TABS_huis_nr_5__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_5_Leefruimte.port_b,floorHeating__TABS_huis_nr_5__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_5_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_5_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_5_Slaapkamer.port_a,floorHeating__TABS_huis_nr_5__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_5_Slaapkamer.port_b,floorHeating__TABS_huis_nr_5__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_7_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_7_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_7_Badkamer.port_a,floorHeating__TABS_huis_nr_7__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_7_Badkamer.port_b,floorHeating__TABS_huis_nr_7__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_7_Inkom.heatPortEmb[1],slabOnGround_zone_Huis_nr_7_Inkom.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_7_Inkom.port_a,floorHeating__TABS_huis_nr_7__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_7_Inkom.port_b,floorHeating__TABS_huis_nr_7__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_7_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_7_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_7_Leefruimte.port_a,floorHeating__TABS_huis_nr_7__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_7_Leefruimte.port_b,floorHeating__TABS_huis_nr_7__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_7_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_7_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_7_Slaapkamer.port_a,floorHeating__TABS_huis_nr_7__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_7_Slaapkamer.port_b,floorHeating__TABS_huis_nr_7__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_9_Badkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_9_Badkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_9_Badkamer.port_a,floorHeating__TABS_huis_nr_9__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_9_Badkamer.port_b,floorHeating__TABS_huis_nr_9__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_9_Leefruimte.heatPortEmb[1],slabOnGround_zone_Huis_nr_9_Leefruimte.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_9_Leefruimte.port_a,floorHeating__TABS_huis_nr_9__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_9_Leefruimte.port_b,floorHeating__TABS_huis_nr_9__valve.port_a);
  connect(embeddedPipe_1_zone_Huis_nr_9_Slaapkamer.heatPortEmb[1],slabOnGround_zone_Huis_nr_9_Slaapkamer.port_emb[1]);
  connect(embeddedPipe_1_zone_Huis_nr_9_Slaapkamer.port_a,floorHeating__TABS_huis_nr_9__supplyPipe.port_b);
  connect(embeddedPipe_1_zone_Huis_nr_9_Slaapkamer.port_b,floorHeating__TABS_huis_nr_9__valve.port_a);
  connect(floorHeating__TABS_huis_nr_11__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_11__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_13__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_13__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_15__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_15__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_17__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_17__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_19__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_19__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_21__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_21__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_23__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_23__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_25__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_25__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_27__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_27__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_29__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_29__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_31__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_31__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_3__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_3__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_5__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_5__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_7__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_7__valve.port_b,collector__Heating_collector.port_a2);
  connect(floorHeating__TABS_huis_nr_9__supplyPipe.port_a,collector__Heating_collector.port_b2);
  connect(floorHeating__TABS_huis_nr_9__valve.port_b,collector__Heating_collector.port_a2);
  connect(internalWall_zone_Huis_nr_11_Badkamer__zone_Huis_nr_11_Slaapkamer.propsBus_a,zone__Huis_nr_11_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_11_Badkamer__zone_Huis_nr_11_Slaapkamer.propsBus_b,zone__Huis_nr_11_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Huis_nr_9_Badkamer.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Huis_nr_9_Badkamer.propsBus_b,zone__Huis_nr_9_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Huis_nr_9_Slaapkamer.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[10]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Huis_nr_9_Slaapkamer.propsBus_b,zone__Huis_nr_9_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Inkom_tech_lokaal_1_UC.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[7]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Inkom_tech_lokaal_1_UC.propsBus_b,zone__Inkom_tech_lokaal_1_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Inkom_tech_lokaal_1_UC__2.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[8]);
  connect(internalWall_zone_Huis_nr_11_Leefruimte__zone_Inkom_tech_lokaal_1_UC__2.propsBus_b,zone__Inkom_tech_lokaal_1_UC.propsBus[4]);
  connect(internalWall_zone_Huis_nr_11_Slaapkamer__zone_Huis_nr_11_Leefruimte.propsBus_a,zone__Huis_nr_11_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_11_Slaapkamer__zone_Huis_nr_11_Leefruimte.propsBus_b,zone__Huis_nr_11_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_13_Badkamer__zone_Huis_nr_13_Slaapkamer.propsBus_a,zone__Huis_nr_13_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_13_Badkamer__zone_Huis_nr_13_Slaapkamer.propsBus_b,zone__Huis_nr_13_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Badkamer.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[8]);
  connect(internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Badkamer.propsBus_b,zone__Huis_nr_15_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Slaapkamer.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[7]);
  connect(internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Slaapkamer.propsBus_b,zone__Huis_nr_15_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Slaapkamer__2.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_13_Leefruimte__zone_Huis_nr_15_Slaapkamer__2.propsBus_b,zone__Huis_nr_15_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_13_Slaapkamer__zone_Huis_nr_13_Leefruimte.propsBus_a,zone__Huis_nr_13_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_13_Slaapkamer__zone_Huis_nr_13_Leefruimte.propsBus_b,zone__Huis_nr_13_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_15_Badkamer__zone_Huis_nr_15_Leefruimte.propsBus_a,zone__Huis_nr_15_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_15_Badkamer__zone_Huis_nr_15_Leefruimte.propsBus_b,zone__Huis_nr_15_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_15_Badkamer__zone_Huis_nr_15_Slaapkamer.propsBus_a,zone__Huis_nr_15_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_15_Badkamer__zone_Huis_nr_15_Slaapkamer.propsBus_b,zone__Huis_nr_15_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_15_Leefruimte__zone_Huis_nr_17_Badkamer.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[10]);
  connect(internalWall_zone_Huis_nr_15_Leefruimte__zone_Huis_nr_17_Badkamer.propsBus_b,zone__Huis_nr_17_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_15_Leefruimte__zone_Inkom_tech_lokaal_3_UC.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[7]);
  connect(internalWall_zone_Huis_nr_15_Leefruimte__zone_Inkom_tech_lokaal_3_UC.propsBus_b,zone__Inkom_tech_lokaal_3_UC.propsBus[5]);
  connect(internalWall_zone_Huis_nr_15_Slaapkamer__zone_Huis_nr_15_Leefruimte.propsBus_a,zone__Huis_nr_15_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_15_Slaapkamer__zone_Huis_nr_15_Leefruimte.propsBus_b,zone__Huis_nr_15_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_15_Slaapkamer__zone_Inkom_tech_lokaal_3_UC.propsBus_a,zone__Huis_nr_15_Slaapkamer.propsBus[8]);
  connect(internalWall_zone_Huis_nr_15_Slaapkamer__zone_Inkom_tech_lokaal_3_UC.propsBus_b,zone__Inkom_tech_lokaal_3_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_15_Slaapkamer__zone_Inkom_tech_lokaal_3_UC__2.propsBus_a,zone__Huis_nr_15_Slaapkamer.propsBus[9]);
  connect(internalWall_zone_Huis_nr_15_Slaapkamer__zone_Inkom_tech_lokaal_3_UC__2.propsBus_b,zone__Inkom_tech_lokaal_3_UC.propsBus[4]);
  connect(internalWall_zone_Huis_nr_17_Badkamer__zone_Fietsenstalling_UC.propsBus_a,zone__Huis_nr_17_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_17_Badkamer__zone_Fietsenstalling_UC.propsBus_b,zone__Fietsenstalling_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_17_Badkamer__zone_Huis_nr_17_Slaapkamer.propsBus_a,zone__Huis_nr_17_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_17_Badkamer__zone_Huis_nr_17_Slaapkamer.propsBus_b,zone__Huis_nr_17_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_17_Inkom__zone_Huis_nr_17_Leefruimte.propsBus_a,zone__Huis_nr_17_Inkom.propsBus[4]);
  connect(internalWall_zone_Huis_nr_17_Inkom__zone_Huis_nr_17_Leefruimte.propsBus_b,zone__Huis_nr_17_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_17_Inkom__zone_Huis_nr_17_Leefruimte__2.propsBus_a,zone__Huis_nr_17_Inkom.propsBus[5]);
  connect(internalWall_zone_Huis_nr_17_Inkom__zone_Huis_nr_17_Leefruimte__2.propsBus_b,zone__Huis_nr_17_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_17_Leefruimte__zone_Fietsenstalling_UC.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[6]);
  connect(internalWall_zone_Huis_nr_17_Leefruimte__zone_Fietsenstalling_UC.propsBus_b,zone__Fietsenstalling_UC.propsBus[4]);
  connect(internalWall_zone_Huis_nr_17_Leefruimte__zone_Fietsenstalling_UC__2.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_17_Leefruimte__zone_Fietsenstalling_UC__2.propsBus_b,zone__Fietsenstalling_UC.propsBus[5]);
  connect(internalWall_zone_Huis_nr_17_Slaapkamer__zone_Huis_nr_17_Inkom.propsBus_a,zone__Huis_nr_17_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_17_Slaapkamer__zone_Huis_nr_17_Inkom.propsBus_b,zone__Huis_nr_17_Inkom.propsBus[3]);
  connect(internalWall_zone_Huis_nr_17_Slaapkamer__zone_Huis_nr_17_Leefruimte.propsBus_a,zone__Huis_nr_17_Slaapkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_17_Slaapkamer__zone_Huis_nr_17_Leefruimte.propsBus_b,zone__Huis_nr_17_Leefruimte.propsBus[5]);
  connect(internalWall_zone_Huis_nr_19_Badkamer__zone_Huis_nr_21_Badkamer.propsBus_a,zone__Huis_nr_19_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_19_Badkamer__zone_Huis_nr_21_Badkamer.propsBus_b,zone__Huis_nr_21_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_19_Badkamer__zone_Huis_nr_21_Slaapkamer.propsBus_a,zone__Huis_nr_19_Badkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_19_Badkamer__zone_Huis_nr_21_Slaapkamer.propsBus_b,zone__Huis_nr_21_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_19_Inkom__zone_Huis_nr_19_Leefruimte.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[3]);
  connect(internalWall_zone_Huis_nr_19_Inkom__zone_Huis_nr_19_Leefruimte.propsBus_b,zone__Huis_nr_19_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_19_Inkom__zone_Huis_nr_19_Leefruimte__2.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[5]);
  connect(internalWall_zone_Huis_nr_19_Inkom__zone_Huis_nr_19_Leefruimte__2.propsBus_b,zone__Huis_nr_19_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_19_Leefruimte__zone_Huis_nr_19_Slaapkamer.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[8]);
  connect(internalWall_zone_Huis_nr_19_Leefruimte__zone_Huis_nr_19_Slaapkamer.propsBus_b,zone__Huis_nr_19_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_19_Slaapkamer__zone_Huis_nr_19_Badkamer.propsBus_a,zone__Huis_nr_19_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_19_Slaapkamer__zone_Huis_nr_19_Badkamer.propsBus_b,zone__Huis_nr_19_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_21_Badkamer__zone_Huis_nr_21_Inkom.propsBus_a,zone__Huis_nr_21_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_21_Badkamer__zone_Huis_nr_21_Inkom.propsBus_b,zone__Huis_nr_21_Inkom.propsBus[3]);
  connect(internalWall_zone_Huis_nr_21_Badkamer__zone_Huis_nr_21_Slaapkamer.propsBus_a,zone__Huis_nr_21_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_21_Badkamer__zone_Huis_nr_21_Slaapkamer.propsBus_b,zone__Huis_nr_21_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_21_Inkom__zone_Huis_nr_21_Leefruimte.propsBus_a,zone__Huis_nr_21_Inkom.propsBus[7]);
  connect(internalWall_zone_Huis_nr_21_Inkom__zone_Huis_nr_21_Leefruimte.propsBus_b,zone__Huis_nr_21_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_21_Inkom__zone_Inkom_tech_ruimte_4_UC.propsBus_a,zone__Huis_nr_21_Inkom.propsBus[8]);
  connect(internalWall_zone_Huis_nr_21_Inkom__zone_Inkom_tech_ruimte_4_UC.propsBus_b,zone__Inkom_tech_ruimte_4_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Huis_nr_23_Badkamer.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Huis_nr_23_Badkamer.propsBus_b,zone__Huis_nr_23_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Huis_nr_23_Slaapkamer.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[8]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Huis_nr_23_Slaapkamer.propsBus_b,zone__Huis_nr_23_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Inkom_tech_ruimte_4_UC.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[5]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Inkom_tech_ruimte_4_UC.propsBus_b,zone__Inkom_tech_ruimte_4_UC.propsBus[4]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Inkom_tech_ruimte_4_UC__2.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[6]);
  connect(internalWall_zone_Huis_nr_21_Leefruimte__zone_Inkom_tech_ruimte_4_UC__2.propsBus_b,zone__Inkom_tech_ruimte_4_UC.propsBus[5]);
  connect(internalWall_zone_Huis_nr_21_Slaapkamer__zone_Huis_nr_21_Inkom.propsBus_a,zone__Huis_nr_21_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_21_Slaapkamer__zone_Huis_nr_21_Inkom.propsBus_b,zone__Huis_nr_21_Inkom.propsBus[4]);
  connect(internalWall_zone_Huis_nr_23_Badkamer__zone_Huis_nr_23_Leefruimte.propsBus_a,zone__Huis_nr_23_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_23_Badkamer__zone_Huis_nr_23_Leefruimte.propsBus_b,zone__Huis_nr_23_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_23_Badkamer__zone_Huis_nr_23_Slaapkamer.propsBus_a,zone__Huis_nr_23_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_23_Badkamer__zone_Huis_nr_23_Slaapkamer.propsBus_b,zone__Huis_nr_23_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_23_Leefruimte__zone_Huis_nr_29_Leefruimte.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[11]);
  connect(internalWall_zone_Huis_nr_23_Leefruimte__zone_Huis_nr_29_Leefruimte.propsBus_b,zone__Huis_nr_29_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_23_Leefruimte__zone_Technische_ruimte_BEO_UC.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_23_Leefruimte__zone_Technische_ruimte_BEO_UC.propsBus_b,zone__Technische_ruimte_BEO_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_23_Leefruimte__zone_Technische_ruimte_BEO_UC__2.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[10]);
  connect(internalWall_zone_Huis_nr_23_Leefruimte__zone_Technische_ruimte_BEO_UC__2.propsBus_b,zone__Technische_ruimte_BEO_UC.propsBus[4]);
  connect(internalWall_zone_Huis_nr_23_Slaapkamer__zone_Huis_nr_23_Leefruimte.propsBus_a,zone__Huis_nr_23_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_23_Slaapkamer__zone_Huis_nr_23_Leefruimte.propsBus_b,zone__Huis_nr_23_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_25_Badkamer__zone_Huis_nr_25_Leefruimte.propsBus_a,zone__Huis_nr_25_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_25_Badkamer__zone_Huis_nr_25_Leefruimte.propsBus_b,zone__Huis_nr_25_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_25_Slaapkamer__zone_Huis_nr_25_Badkamer.propsBus_a,zone__Huis_nr_25_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_25_Slaapkamer__zone_Huis_nr_25_Badkamer.propsBus_b,zone__Huis_nr_25_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_25_Slaapkamer__zone_Huis_nr_25_Leefruimte.propsBus_a,zone__Huis_nr_25_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_25_Slaapkamer__zone_Huis_nr_25_Leefruimte.propsBus_b,zone__Huis_nr_25_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_27_Badkamer__zone_Huis_nr_25_Badkamer.propsBus_a,zone__Huis_nr_27_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_27_Badkamer__zone_Huis_nr_25_Badkamer.propsBus_b,zone__Huis_nr_25_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_27_Badkamer__zone_Huis_nr_25_Slaapkamer.propsBus_a,zone__Huis_nr_27_Badkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_27_Badkamer__zone_Huis_nr_25_Slaapkamer.propsBus_b,zone__Huis_nr_25_Slaapkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_27_Badkamer__zone_Inkom_tech_ruimte_6_UC.propsBus_a,zone__Huis_nr_27_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_27_Badkamer__zone_Inkom_tech_ruimte_6_UC.propsBus_b,zone__Inkom_tech_ruimte_6_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_27_Leefruimte__zone_Huis_nr_27_Slaapkamer.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[13]);
  connect(internalWall_zone_Huis_nr_27_Leefruimte__zone_Huis_nr_27_Slaapkamer.propsBus_b,zone__Huis_nr_27_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_27_Slaapkamer__zone_Huis_nr_27_Badkamer.propsBus_a,zone__Huis_nr_27_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_27_Slaapkamer__zone_Huis_nr_27_Badkamer.propsBus_b,zone__Huis_nr_27_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_29_Badkamer__zone_Huis_nr_29_Slaapkamer.propsBus_a,zone__Huis_nr_29_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_29_Badkamer__zone_Huis_nr_29_Slaapkamer.propsBus_b,zone__Huis_nr_29_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_29_Badkamer__zone_Huis_nr_31_Badkamer.propsBus_a,zone__Huis_nr_29_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_29_Badkamer__zone_Huis_nr_31_Badkamer.propsBus_b,zone__Huis_nr_31_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_29_Leefruimte__zone_Huis_nr_29_Badkamer.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_29_Leefruimte__zone_Huis_nr_29_Badkamer.propsBus_b,zone__Huis_nr_29_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_29_Leefruimte__zone_Huis_nr_29_Slaapkamer.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[10]);
  connect(internalWall_zone_Huis_nr_29_Leefruimte__zone_Huis_nr_29_Slaapkamer.propsBus_b,zone__Huis_nr_29_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_29_Leefruimte__zone_Technische_ruimte_BEO_UC.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[5]);
  connect(internalWall_zone_Huis_nr_29_Leefruimte__zone_Technische_ruimte_BEO_UC.propsBus_b,zone__Technische_ruimte_BEO_UC.propsBus[5]);
  connect(internalWall_zone_Huis_nr_29_Slaapkamer__zone_Huis_nr_31_Badkamer.propsBus_a,zone__Huis_nr_29_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_29_Slaapkamer__zone_Huis_nr_31_Badkamer.propsBus_b,zone__Huis_nr_31_Badkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_29_Slaapkamer__zone_Inkom_tech_ruimte_5_UC.propsBus_a,zone__Huis_nr_29_Slaapkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_29_Slaapkamer__zone_Inkom_tech_ruimte_5_UC.propsBus_b,zone__Inkom_tech_ruimte_5_UC.propsBus[4]);
  connect(internalWall_zone_Huis_nr_31_Badkamer__zone_Huis_nr_31_Slaapkamer.propsBus_a,zone__Huis_nr_31_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_31_Badkamer__zone_Huis_nr_31_Slaapkamer.propsBus_b,zone__Huis_nr_31_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_31_Badkamer__zone_Inkom_tech_ruimte_5_UC.propsBus_a,zone__Huis_nr_31_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_31_Badkamer__zone_Inkom_tech_ruimte_5_UC.propsBus_b,zone__Inkom_tech_ruimte_5_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_31_Leefruimte__zone_Huis_nr_31_Inkom.propsBus_a,zone__Huis_nr_31_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_31_Leefruimte__zone_Huis_nr_31_Inkom.propsBus_b,zone__Huis_nr_31_Inkom.propsBus[4]);
  connect(internalWall_zone_Huis_nr_31_Slaapkamer__zone_Huis_nr_31_Inkom.propsBus_a,zone__Huis_nr_31_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_31_Slaapkamer__zone_Huis_nr_31_Inkom.propsBus_b,zone__Huis_nr_31_Inkom.propsBus[3]);
  connect(internalWall_zone_Huis_nr_31_Slaapkamer__zone_Huis_nr_31_Leefruimte.propsBus_a,zone__Huis_nr_31_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_31_Slaapkamer__zone_Huis_nr_31_Leefruimte.propsBus_b,zone__Huis_nr_31_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_3_Badkamer__zone_Huis_nr_3_Inkom.propsBus_a,zone__Huis_nr_3_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_3_Badkamer__zone_Huis_nr_3_Inkom.propsBus_b,zone__Huis_nr_3_Inkom.propsBus[3]);
  connect(internalWall_zone_Huis_nr_3_Badkamer__zone_Huis_nr_3_Leefruimte.propsBus_a,zone__Huis_nr_3_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_3_Badkamer__zone_Huis_nr_3_Leefruimte.propsBus_b,zone__Huis_nr_3_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_3_Inkom__zone_Huis_nr_3_Leefruimte.propsBus_a,zone__Huis_nr_3_Inkom.propsBus[6]);
  connect(internalWall_zone_Huis_nr_3_Inkom__zone_Huis_nr_3_Leefruimte.propsBus_b,zone__Huis_nr_3_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_3_Leefruimte__zone_Inkom_tech_lokaal_2_UC.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[8]);
  connect(internalWall_zone_Huis_nr_3_Leefruimte__zone_Inkom_tech_lokaal_2_UC.propsBus_b,zone__Inkom_tech_lokaal_2_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_3_Leefruimte__zone_Inkom_tech_lokaal_2_UC__2.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_3_Leefruimte__zone_Inkom_tech_lokaal_2_UC__2.propsBus_b,zone__Inkom_tech_lokaal_2_UC.propsBus[6]);
  connect(internalWall_zone_Huis_nr_3_Slaapkamer__zone_Huis_nr_3_Badkamer.propsBus_a,zone__Huis_nr_3_Slaapkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_3_Slaapkamer__zone_Huis_nr_3_Badkamer.propsBus_b,zone__Huis_nr_3_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_3_Slaapkamer__zone_Huis_nr_3_Inkom.propsBus_a,zone__Huis_nr_3_Slaapkamer.propsBus[8]);
  connect(internalWall_zone_Huis_nr_3_Slaapkamer__zone_Huis_nr_3_Inkom.propsBus_b,zone__Huis_nr_3_Inkom.propsBus[4]);
  connect(internalWall_zone_Huis_nr_5_Badkamer__zone_Huis_nr_3_Slaapkamer.propsBus_a,zone__Huis_nr_5_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_5_Badkamer__zone_Huis_nr_3_Slaapkamer.propsBus_b,zone__Huis_nr_3_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_5_Inkom__zone_Huis_nr_5_Badkamer.propsBus_a,zone__Huis_nr_5_Inkom.propsBus[7]);
  connect(internalWall_zone_Huis_nr_5_Inkom__zone_Huis_nr_5_Badkamer.propsBus_b,zone__Huis_nr_5_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_5_Inkom__zone_Huis_nr_5_Slaapkamer.propsBus_a,zone__Huis_nr_5_Inkom.propsBus[6]);
  connect(internalWall_zone_Huis_nr_5_Inkom__zone_Huis_nr_5_Slaapkamer.propsBus_b,zone__Huis_nr_5_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_5_Leefruimte__zone_Huis_nr_5_Inkom.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[6]);
  connect(internalWall_zone_Huis_nr_5_Leefruimte__zone_Huis_nr_5_Inkom.propsBus_b,zone__Huis_nr_5_Inkom.propsBus[3]);
  connect(internalWall_zone_Huis_nr_5_Slaapkamer__zone_Huis_nr_3_Slaapkamer.propsBus_a,zone__Huis_nr_5_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_5_Slaapkamer__zone_Huis_nr_3_Slaapkamer.propsBus_b,zone__Huis_nr_3_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_5_Slaapkamer__zone_Huis_nr_5_Badkamer.propsBus_a,zone__Huis_nr_5_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_5_Slaapkamer__zone_Huis_nr_5_Badkamer.propsBus_b,zone__Huis_nr_5_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_7_Badkamer__zone_Fietsenstalling_2_UC.propsBus_a,zone__Huis_nr_7_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_7_Badkamer__zone_Fietsenstalling_2_UC.propsBus_b,zone__Fietsenstalling_2_UC.propsBus[3]);
  connect(internalWall_zone_Huis_nr_7_Badkamer__zone_Huis_nr_7_Slaapkamer.propsBus_a,zone__Huis_nr_7_Badkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_7_Badkamer__zone_Huis_nr_7_Slaapkamer.propsBus_b,zone__Huis_nr_7_Slaapkamer.propsBus[6]);
  connect(internalWall_zone_Huis_nr_7_Inkom__zone_Huis_nr_7_Leefruimte.propsBus_a,zone__Huis_nr_7_Inkom.propsBus[4]);
  connect(internalWall_zone_Huis_nr_7_Inkom__zone_Huis_nr_7_Leefruimte.propsBus_b,zone__Huis_nr_7_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Huis_nr_7_Inkom__zone_Huis_nr_7_Leefruimte__2.propsBus_a,zone__Huis_nr_7_Inkom.propsBus[5]);
  connect(internalWall_zone_Huis_nr_7_Inkom__zone_Huis_nr_7_Leefruimte__2.propsBus_b,zone__Huis_nr_7_Leefruimte.propsBus[5]);
  connect(internalWall_zone_Huis_nr_7_Leefruimte__zone_Fietsenstalling_2_UC.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[8]);
  connect(internalWall_zone_Huis_nr_7_Leefruimte__zone_Fietsenstalling_2_UC.propsBus_b,zone__Fietsenstalling_2_UC.propsBus[4]);
  connect(internalWall_zone_Huis_nr_7_Leefruimte__zone_Fietsenstalling_2_UC__2.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[9]);
  connect(internalWall_zone_Huis_nr_7_Leefruimte__zone_Fietsenstalling_2_UC__2.propsBus_b,zone__Fietsenstalling_2_UC.propsBus[5]);
  connect(internalWall_zone_Huis_nr_7_Slaapkamer__zone_Huis_nr_7_Inkom.propsBus_a,zone__Huis_nr_7_Slaapkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_7_Slaapkamer__zone_Huis_nr_7_Inkom.propsBus_b,zone__Huis_nr_7_Inkom.propsBus[3]);
  connect(internalWall_zone_Huis_nr_7_Slaapkamer__zone_Huis_nr_7_Leefruimte.propsBus_a,zone__Huis_nr_7_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_7_Slaapkamer__zone_Huis_nr_7_Leefruimte.propsBus_b,zone__Huis_nr_7_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_9_Badkamer__zone_Huis_nr_9_Leefruimte.propsBus_a,zone__Huis_nr_9_Badkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_9_Badkamer__zone_Huis_nr_9_Leefruimte.propsBus_b,zone__Huis_nr_9_Leefruimte.propsBus[3]);
  connect(internalWall_zone_Huis_nr_9_Badkamer__zone_Huis_nr_9_Slaapkamer.propsBus_a,zone__Huis_nr_9_Badkamer.propsBus[5]);
  connect(internalWall_zone_Huis_nr_9_Badkamer__zone_Huis_nr_9_Slaapkamer.propsBus_b,zone__Huis_nr_9_Slaapkamer.propsBus[4]);
  connect(internalWall_zone_Huis_nr_9_Leefruimte__zone_Huis_nr_7_Badkamer.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[7]);
  connect(internalWall_zone_Huis_nr_9_Leefruimte__zone_Huis_nr_7_Badkamer.propsBus_b,zone__Huis_nr_7_Badkamer.propsBus[3]);
  connect(internalWall_zone_Huis_nr_9_Slaapkamer__zone_Huis_nr_9_Leefruimte.propsBus_a,zone__Huis_nr_9_Slaapkamer.propsBus[7]);
  connect(internalWall_zone_Huis_nr_9_Slaapkamer__zone_Huis_nr_9_Leefruimte.propsBus_b,zone__Huis_nr_9_Leefruimte.propsBus[4]);
  connect(internalWall_zone_Inkom_tech_lokaal_1_UC__zone_Huis_nr_9_Slaapkamer.propsBus_a,zone__Inkom_tech_lokaal_1_UC.propsBus[6]);
  connect(internalWall_zone_Inkom_tech_lokaal_1_UC__zone_Huis_nr_9_Slaapkamer.propsBus_b,zone__Huis_nr_9_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Inkom_tech_ruimte_6_UC__zone_Huis_nr_25_Slaapkamer.propsBus_a,zone__Inkom_tech_ruimte_6_UC.propsBus[4]);
  connect(internalWall_zone_Inkom_tech_ruimte_6_UC__zone_Huis_nr_25_Slaapkamer.propsBus_b,zone__Huis_nr_25_Slaapkamer.propsBus[3]);
  connect(internalWall_zone_Technische_ruimte_BEO_UC__zone_Huis_nr_27_Leefruimte.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[10]);
  connect(internalWall_zone_Technische_ruimte_BEO_UC__zone_Huis_nr_27_Leefruimte.propsBus_b,zone__Huis_nr_27_Leefruimte.propsBus[5]);
  connect(internalWall_zone_Technische_ruimte_BEO_UC__zone_Huis_nr_27_Leefruimte__2.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[11]);
  connect(internalWall_zone_Technische_ruimte_BEO_UC__zone_Huis_nr_27_Leefruimte__2.propsBus_b,zone__Huis_nr_27_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Fietsenstalling_2_UC.propsBus_a,zone__Fietsenstalling_2_UC.propsBus[6]);
  connect(outerWall_zone_Fietsenstalling_UC.propsBus_a,zone__Fietsenstalling_UC.propsBus[6]);
  connect(outerWall_zone_Huis_nr_11_Badkamer.propsBus_a,zone__Huis_nr_11_Badkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_11_Badkamer__2.propsBus_a,zone__Huis_nr_11_Badkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_11_Badkamer__3.propsBus_a,zone__Huis_nr_11_Badkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_11_Leefruimte.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[4]);
  connect(outerWall_zone_Huis_nr_11_Leefruimte__2.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_11_Leefruimte__3.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_11_Slaapkamer.propsBus_a,zone__Huis_nr_11_Slaapkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_11_Slaapkamer__2.propsBus_a,zone__Huis_nr_11_Slaapkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_13_Badkamer.propsBus_a,zone__Huis_nr_13_Badkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_13_Badkamer__2.propsBus_a,zone__Huis_nr_13_Badkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_13_Badkamer__3.propsBus_a,zone__Huis_nr_13_Badkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_13_Leefruimte.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[4]);
  connect(outerWall_zone_Huis_nr_13_Leefruimte__2.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_13_Leefruimte__3.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_13_Slaapkamer.propsBus_a,zone__Huis_nr_13_Slaapkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_13_Slaapkamer__2.propsBus_a,zone__Huis_nr_13_Slaapkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_15_Badkamer.propsBus_a,zone__Huis_nr_15_Badkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_15_Leefruimte.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_15_Leefruimte__2.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_15_Leefruimte__3.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Huis_nr_15_Leefruimte__4.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[9]);
  connect(outerWall_zone_Huis_nr_15_Slaapkamer.propsBus_a,zone__Huis_nr_15_Slaapkamer.propsBus[7]);
  connect(outerWall_zone_Huis_nr_17_Badkamer.propsBus_a,zone__Huis_nr_17_Badkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_17_Inkom.propsBus_a,zone__Huis_nr_17_Inkom.propsBus[6]);
  connect(outerWall_zone_Huis_nr_17_Leefruimte.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_17_Leefruimte__2.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Huis_nr_17_Leefruimte__3.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[10]);
  connect(outerWall_zone_Huis_nr_17_Slaapkamer.propsBus_a,zone__Huis_nr_17_Slaapkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_17_Slaapkamer__2.propsBus_a,zone__Huis_nr_17_Slaapkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_19_Badkamer.propsBus_a,zone__Huis_nr_19_Badkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_19_Badkamer__2.propsBus_a,zone__Huis_nr_19_Badkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_19_Inkom.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[4]);
  connect(outerWall_zone_Huis_nr_19_Inkom__2.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[6]);
  connect(outerWall_zone_Huis_nr_19_Leefruimte.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_19_Leefruimte__2.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_19_Leefruimte__3.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_19_Leefruimte__4.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[9]);
  connect(outerWall_zone_Huis_nr_19_Slaapkamer.propsBus_a,zone__Huis_nr_19_Slaapkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_19_Slaapkamer__2.propsBus_a,zone__Huis_nr_19_Slaapkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_21_Badkamer.propsBus_a,zone__Huis_nr_21_Badkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_21_Inkom.propsBus_a,zone__Huis_nr_21_Inkom.propsBus[5]);
  connect(outerWall_zone_Huis_nr_21_Inkom__2.propsBus_a,zone__Huis_nr_21_Inkom.propsBus[6]);
  connect(outerWall_zone_Huis_nr_21_Leefruimte.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[3]);
  connect(outerWall_zone_Huis_nr_21_Leefruimte__2.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_21_Slaapkamer.propsBus_a,zone__Huis_nr_21_Slaapkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_21_Slaapkamer__2.propsBus_a,zone__Huis_nr_21_Slaapkamer.propsBus[7]);
  connect(outerWall_zone_Huis_nr_23_Badkamer.propsBus_a,zone__Huis_nr_23_Badkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_23_Leefruimte.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_23_Leefruimte__2.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_23_Leefruimte__3.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_23_Leefruimte__4.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Huis_nr_23_Slaapkamer.propsBus_a,zone__Huis_nr_23_Slaapkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_25_Badkamer.propsBus_a,zone__Huis_nr_25_Badkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_25_Leefruimte.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_25_Leefruimte__2.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_25_Leefruimte__3.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_25_Leefruimte__4.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Huis_nr_25_Leefruimte__5.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[9]);
  connect(outerWall_zone_Huis_nr_25_Slaapkamer.propsBus_a,zone__Huis_nr_25_Slaapkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_27_Badkamer.propsBus_a,zone__Huis_nr_27_Badkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[3]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__10.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[15]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__2.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[4]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__3.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__4.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__5.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[9]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__6.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[10]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__7.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[11]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__8.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[12]);
  connect(outerWall_zone_Huis_nr_27_Leefruimte__9.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[14]);
  connect(outerWall_zone_Huis_nr_27_Slaapkamer.propsBus_a,zone__Huis_nr_27_Slaapkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_27_Slaapkamer__2.propsBus_a,zone__Huis_nr_27_Slaapkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_29_Badkamer.propsBus_a,zone__Huis_nr_29_Badkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_29_Leefruimte.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[4]);
  connect(outerWall_zone_Huis_nr_29_Leefruimte__2.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_29_Leefruimte__3.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_29_Leefruimte__4.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Huis_nr_29_Slaapkamer.propsBus_a,zone__Huis_nr_29_Slaapkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_31_Badkamer.propsBus_a,zone__Huis_nr_31_Badkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_31_Inkom.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[5]);
  connect(outerWall_zone_Huis_nr_31_Inkom__2.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[6]);
  connect(outerWall_zone_Huis_nr_31_Inkom__3.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[7]);
  connect(outerWall_zone_Huis_nr_31_Leefruimte.propsBus_a,zone__Huis_nr_31_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_31_Leefruimte__2.propsBus_a,zone__Huis_nr_31_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_31_Leefruimte__3.propsBus_a,zone__Huis_nr_31_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_31_Slaapkamer.propsBus_a,zone__Huis_nr_31_Slaapkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_3_Badkamer.propsBus_a,zone__Huis_nr_3_Badkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_3_Inkom.propsBus_a,zone__Huis_nr_3_Inkom.propsBus[5]);
  connect(outerWall_zone_Huis_nr_3_Leefruimte.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_3_Leefruimte__2.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_3_Leefruimte__3.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_3_Leefruimte__4.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[10]);
  connect(outerWall_zone_Huis_nr_3_Slaapkamer.propsBus_a,zone__Huis_nr_3_Slaapkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_3_Slaapkamer__2.propsBus_a,zone__Huis_nr_3_Slaapkamer.propsBus[6]);
  connect(outerWall_zone_Huis_nr_5_Badkamer.propsBus_a,zone__Huis_nr_5_Badkamer.propsBus[5]);
  connect(outerWall_zone_Huis_nr_5_Inkom.propsBus_a,zone__Huis_nr_5_Inkom.propsBus[4]);
  connect(outerWall_zone_Huis_nr_5_Inkom__2.propsBus_a,zone__Huis_nr_5_Inkom.propsBus[5]);
  connect(outerWall_zone_Huis_nr_5_Leefruimte.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[3]);
  connect(outerWall_zone_Huis_nr_5_Leefruimte__2.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[4]);
  connect(outerWall_zone_Huis_nr_5_Leefruimte__3.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_5_Leefruimte__4.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_5_Leefruimte__5.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Huis_nr_5_Slaapkamer.propsBus_a,zone__Huis_nr_5_Slaapkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_7_Badkamer.propsBus_a,zone__Huis_nr_7_Badkamer.propsBus[4]);
  connect(outerWall_zone_Huis_nr_7_Inkom.propsBus_a,zone__Huis_nr_7_Inkom.propsBus[6]);
  connect(outerWall_zone_Huis_nr_7_Leefruimte.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_7_Leefruimte__2.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[7]);
  connect(outerWall_zone_Huis_nr_7_Leefruimte__3.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[10]);
  connect(outerWall_zone_Huis_nr_7_Slaapkamer.propsBus_a,zone__Huis_nr_7_Slaapkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_7_Slaapkamer__2.propsBus_a,zone__Huis_nr_7_Slaapkamer.propsBus[7]);
  connect(outerWall_zone_Huis_nr_9_Badkamer.propsBus_a,zone__Huis_nr_9_Badkamer.propsBus[3]);
  connect(outerWall_zone_Huis_nr_9_Leefruimte.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[5]);
  connect(outerWall_zone_Huis_nr_9_Leefruimte__2.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[6]);
  connect(outerWall_zone_Huis_nr_9_Leefruimte__3.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[8]);
  connect(outerWall_zone_Huis_nr_9_Leefruimte__4.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[9]);
  connect(outerWall_zone_Huis_nr_9_Slaapkamer.propsBus_a,zone__Huis_nr_9_Slaapkamer.propsBus[6]);
  connect(outerWall_zone_Inkom_tech_lokaal_1_UC.propsBus_a,zone__Inkom_tech_lokaal_1_UC.propsBus[5]);
  connect(outerWall_zone_Inkom_tech_lokaal_2_UC.propsBus_a,zone__Inkom_tech_lokaal_2_UC.propsBus[4]);
  connect(outerWall_zone_Inkom_tech_lokaal_2_UC__2.propsBus_a,zone__Inkom_tech_lokaal_2_UC.propsBus[5]);
  connect(outerWall_zone_Inkom_tech_lokaal_3_UC.propsBus_a,zone__Inkom_tech_lokaal_3_UC.propsBus[6]);
  connect(outerWall_zone_Inkom_tech_ruimte_4_UC.propsBus_a,zone__Inkom_tech_ruimte_4_UC.propsBus[6]);
  connect(outerWall_zone_Inkom_tech_ruimte_5_UC.propsBus_a,zone__Inkom_tech_ruimte_5_UC.propsBus[5]);
  connect(outerWall_zone_Inkom_tech_ruimte_5_UC__2.propsBus_a,zone__Inkom_tech_ruimte_5_UC.propsBus[6]);
  connect(outerWall_zone_Inkom_tech_ruimte_6_UC.propsBus_a,zone__Inkom_tech_ruimte_6_UC.propsBus[5]);
  connect(outerWall_zone_Inkom_tech_ruimte_6_UC__2.propsBus_a,zone__Inkom_tech_ruimte_6_UC.propsBus[6]);
  connect(outerWall_zone_Technische_ruimte_BEO_UC.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[6]);
  connect(outerWall_zone_Technische_ruimte_BEO_UC__2.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[7]);
  connect(outerWall_zone_Technische_ruimte_BEO_UC__3.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[8]);
  connect(outerWall_zone_Technische_ruimte_BEO_UC__4.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[9]);
  connect(outerWall_zone_Technische_ruimte_BEO_UC__5.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[12]);
  connect(returnCav_zone__Huis_nr_11_Badkamer__CAVr_type_15.port_a,zone__Huis_nr_11_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_11_Badkamer__CAVr_type_15.port_b,airHandlingUnit__AHU_huis_nr_11.port_a[1]);
  connect(returnCav_zone__Huis_nr_13_Badkamer__CAVr_type_1.port_a,zone__Huis_nr_13_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_13_Badkamer__CAVr_type_1.port_b,airHandlingUnit__AHU_huis_nr_13.port_a[1]);
  connect(returnCav_zone__Huis_nr_15_Badkamer__CAVr_type_2.port_a,zone__Huis_nr_15_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_15_Badkamer__CAVr_type_2.port_b,airHandlingUnit__AHU_huis_nr_15.port_a[1]);
  connect(returnCav_zone__Huis_nr_17_Badkamer__CAVr_type_3.port_a,zone__Huis_nr_17_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_17_Badkamer__CAVr_type_3.port_b,airHandlingUnit__AHU_huis_nr_17.port_a[1]);
  connect(returnCav_zone__Huis_nr_19_Badkamer__CAVr_type_4.port_a,zone__Huis_nr_19_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_19_Badkamer__CAVr_type_4.port_b,airHandlingUnit__AHU_huis_nr_19.port_a[1]);
  connect(returnCav_zone__Huis_nr_21_Badkamer__CAVr_type_5.port_a,zone__Huis_nr_21_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_21_Badkamer__CAVr_type_5.port_b,airHandlingUnit__AHU_huis_nr_21.port_a[1]);
  connect(returnCav_zone__Huis_nr_23_Badkamer__CAVr_type_6.port_a,zone__Huis_nr_23_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_23_Badkamer__CAVr_type_6.port_b,airHandlingUnit__AHU_huis_nr_23.port_a[1]);
  connect(returnCav_zone__Huis_nr_25_Badkamer__CAVr_type_10.port_a,zone__Huis_nr_25_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_25_Badkamer__CAVr_type_10.port_b,airHandlingUnit__AHU_huis_nr_25.port_a[1]);
  connect(returnCav_zone__Huis_nr_27_Badkamer__CAVr_type_9.port_a,zone__Huis_nr_27_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_27_Badkamer__CAVr_type_9.port_b,airHandlingUnit__AHU_huis_nr_27.port_a[1]);
  connect(returnCav_zone__Huis_nr_29_Badkamer__CAVr_type_7.port_a,zone__Huis_nr_29_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_29_Badkamer__CAVr_type_7.port_b,airHandlingUnit__AHU_huis_nr_29.port_a[1]);
  connect(returnCav_zone__Huis_nr_31_Badkamer__CAVr_type_8.port_a,zone__Huis_nr_31_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_31_Badkamer__CAVr_type_8.port_b,airHandlingUnit__AHU_huis_nr_31.port_a[1]);
  connect(returnCav_zone__Huis_nr_3_Badkamer__CAVr_type_11.port_a,zone__Huis_nr_3_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_3_Badkamer__CAVr_type_11.port_b,airHandlingUnit__AHU_huis_nr_3.port_a[1]);
  connect(returnCav_zone__Huis_nr_5_Badkamer__CAVr_type_12.port_a,zone__Huis_nr_5_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_5_Badkamer__CAVr_type_12.port_b,airHandlingUnit__AHU_huis_nr_5.port_a[1]);
  connect(returnCav_zone__Huis_nr_7_Badkamer__CAVr_type_13.port_a,zone__Huis_nr_7_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_7_Badkamer__CAVr_type_13.port_b,airHandlingUnit__AHU_huis_nr_7.port_a[1]);
  connect(returnCav_zone__Huis_nr_9_Badkamer__CAVr_type_14.port_a,zone__Huis_nr_9_Badkamer.ports[1]);
  connect(returnCav_zone__Huis_nr_9_Badkamer__CAVr_type_14.port_b,airHandlingUnit__AHU_huis_nr_9.port_a[1]);
  connect(slabOnGround_zone_Fietsenstalling_2_UC.propsBus_a,zone__Fietsenstalling_2_UC.propsBus[1]);
  connect(slabOnGround_zone_Fietsenstalling_UC.propsBus_a,zone__Fietsenstalling_UC.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_11_Badkamer.propsBus_a,zone__Huis_nr_11_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_11_Leefruimte.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_11_Slaapkamer.propsBus_a,zone__Huis_nr_11_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_13_Badkamer.propsBus_a,zone__Huis_nr_13_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_13_Leefruimte.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_13_Slaapkamer.propsBus_a,zone__Huis_nr_13_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_15_Badkamer.propsBus_a,zone__Huis_nr_15_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_15_Leefruimte.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_15_Slaapkamer.propsBus_a,zone__Huis_nr_15_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_17_Badkamer.propsBus_a,zone__Huis_nr_17_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_17_Inkom.propsBus_a,zone__Huis_nr_17_Inkom.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_17_Leefruimte.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_17_Slaapkamer.propsBus_a,zone__Huis_nr_17_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_19_Badkamer.propsBus_a,zone__Huis_nr_19_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_19_Inkom.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_19_Leefruimte.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_19_Slaapkamer.propsBus_a,zone__Huis_nr_19_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_21_Badkamer.propsBus_a,zone__Huis_nr_21_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_21_Inkom.propsBus_a,zone__Huis_nr_21_Inkom.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_21_Leefruimte.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_21_Slaapkamer.propsBus_a,zone__Huis_nr_21_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_23_Badkamer.propsBus_a,zone__Huis_nr_23_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_23_Leefruimte.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_23_Slaapkamer.propsBus_a,zone__Huis_nr_23_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_25_Badkamer.propsBus_a,zone__Huis_nr_25_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_25_Leefruimte.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_25_Slaapkamer.propsBus_a,zone__Huis_nr_25_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_27_Badkamer.propsBus_a,zone__Huis_nr_27_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_27_Leefruimte.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_27_Slaapkamer.propsBus_a,zone__Huis_nr_27_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_29_Badkamer.propsBus_a,zone__Huis_nr_29_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_29_Leefruimte.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_29_Slaapkamer.propsBus_a,zone__Huis_nr_29_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_31_Badkamer.propsBus_a,zone__Huis_nr_31_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_31_Inkom.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_31_Leefruimte.propsBus_a,zone__Huis_nr_31_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_31_Slaapkamer.propsBus_a,zone__Huis_nr_31_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_3_Badkamer.propsBus_a,zone__Huis_nr_3_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_3_Inkom.propsBus_a,zone__Huis_nr_3_Inkom.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_3_Leefruimte.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_3_Slaapkamer.propsBus_a,zone__Huis_nr_3_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_5_Badkamer.propsBus_a,zone__Huis_nr_5_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_5_Inkom.propsBus_a,zone__Huis_nr_5_Inkom.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_5_Leefruimte.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_5_Slaapkamer.propsBus_a,zone__Huis_nr_5_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_7_Badkamer.propsBus_a,zone__Huis_nr_7_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_7_Inkom.propsBus_a,zone__Huis_nr_7_Inkom.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_7_Leefruimte.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_7_Slaapkamer.propsBus_a,zone__Huis_nr_7_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_9_Badkamer.propsBus_a,zone__Huis_nr_9_Badkamer.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_9_Leefruimte.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[1]);
  connect(slabOnGround_zone_Huis_nr_9_Slaapkamer.propsBus_a,zone__Huis_nr_9_Slaapkamer.propsBus[1]);
  connect(slabOnGround_zone_Inkom_tech_lokaal_1_UC.propsBus_a,zone__Inkom_tech_lokaal_1_UC.propsBus[1]);
  connect(slabOnGround_zone_Inkom_tech_lokaal_2_UC.propsBus_a,zone__Inkom_tech_lokaal_2_UC.propsBus[1]);
  connect(slabOnGround_zone_Inkom_tech_lokaal_3_UC.propsBus_a,zone__Inkom_tech_lokaal_3_UC.propsBus[1]);
  connect(slabOnGround_zone_Inkom_tech_ruimte_4_UC.propsBus_a,zone__Inkom_tech_ruimte_4_UC.propsBus[1]);
  connect(slabOnGround_zone_Inkom_tech_ruimte_5_UC.propsBus_a,zone__Inkom_tech_ruimte_5_UC.propsBus[1]);
  connect(slabOnGround_zone_Inkom_tech_ruimte_6_UC.propsBus_a,zone__Inkom_tech_ruimte_6_UC.propsBus[1]);
  connect(slabOnGround_zone_Technische_ruimte_BEO_UC.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[1]);
  connect(supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15.port_a,airHandlingUnit__AHU_huis_nr_11.port_b[1]);
  connect(supplyCav_zone__Huis_nr_11_Slaapkamer__CAVs_type_15.port_b,zone__Huis_nr_11_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1.port_a,airHandlingUnit__AHU_huis_nr_13.port_b[1]);
  connect(supplyCav_zone__Huis_nr_13_Slaapkamer__CAVs_type_1.port_b,zone__Huis_nr_13_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2.port_a,airHandlingUnit__AHU_huis_nr_15.port_b[1]);
  connect(supplyCav_zone__Huis_nr_15_Slaapkamer__CAVs_type_2.port_b,zone__Huis_nr_15_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3.port_a,airHandlingUnit__AHU_huis_nr_17.port_b[1]);
  connect(supplyCav_zone__Huis_nr_17_Slaapkamer__CAVs_type_3.port_b,zone__Huis_nr_17_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4.port_a,airHandlingUnit__AHU_huis_nr_19.port_b[1]);
  connect(supplyCav_zone__Huis_nr_19_Slaapkamer__CAVs_type_4.port_b,zone__Huis_nr_19_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5.port_a,airHandlingUnit__AHU_huis_nr_21.port_b[1]);
  connect(supplyCav_zone__Huis_nr_21_Slaapkamer__CAVs_type_5.port_b,zone__Huis_nr_21_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6.port_a,airHandlingUnit__AHU_huis_nr_23.port_b[1]);
  connect(supplyCav_zone__Huis_nr_23_Slaapkamer__CAVs_type_6.port_b,zone__Huis_nr_23_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10.port_a,airHandlingUnit__AHU_huis_nr_25.port_b[1]);
  connect(supplyCav_zone__Huis_nr_25_Slaapkamer__CAVs_type_10.port_b,zone__Huis_nr_25_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9.port_a,airHandlingUnit__AHU_huis_nr_27.port_b[1]);
  connect(supplyCav_zone__Huis_nr_27_Slaapkamer__CAVs_type_9.port_b,zone__Huis_nr_27_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7.port_a,airHandlingUnit__AHU_huis_nr_29.port_b[1]);
  connect(supplyCav_zone__Huis_nr_29_Slaapkamer__CAVs_type_7.port_b,zone__Huis_nr_29_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8.port_a,airHandlingUnit__AHU_huis_nr_31.port_b[1]);
  connect(supplyCav_zone__Huis_nr_31_Slaapkamer__CAVs_type_8.port_b,zone__Huis_nr_31_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11.port_a,airHandlingUnit__AHU_huis_nr_3.port_b[1]);
  connect(supplyCav_zone__Huis_nr_3_Slaapkamer__CAVs_type_11.port_b,zone__Huis_nr_3_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12.port_a,airHandlingUnit__AHU_huis_nr_5.port_b[1]);
  connect(supplyCav_zone__Huis_nr_5_Slaapkamer__CAVs_type_12.port_b,zone__Huis_nr_5_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13.port_a,airHandlingUnit__AHU_huis_nr_7.port_b[1]);
  connect(supplyCav_zone__Huis_nr_7_Slaapkamer__CAVs_type_13.port_b,zone__Huis_nr_7_Slaapkamer.ports[1]);
  connect(supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14.port_a,airHandlingUnit__AHU_huis_nr_9.port_b[1]);
  connect(supplyCav_zone__Huis_nr_9_Slaapkamer__CAVs_type_14.port_b,zone__Huis_nr_9_Slaapkamer.ports[1]);
  connect(theCon_space__Fietsenstalling_2_UC.port_a,preTem_space_Fietsenstalling_2_UC.port);
  connect(theCon_space__Fietsenstalling_2_UC.port_b,zone__Fietsenstalling_2_UC.gainCon);
  connect(theCon_space__Fietsenstalling_UC.port_a,preTem_space_Fietsenstalling_UC.port);
  connect(theCon_space__Fietsenstalling_UC.port_b,zone__Fietsenstalling_UC.gainCon);
  connect(theCon_space__Huis_nr_11_Badkamer.port_a,preTem_space_Huis_nr_11_Badkamer.port);
  connect(theCon_space__Huis_nr_11_Badkamer.port_b,zone__Huis_nr_11_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_11_Leefruimte.port_a,preTem_space_Huis_nr_11_Leefruimte.port);
  connect(theCon_space__Huis_nr_11_Leefruimte.port_b,zone__Huis_nr_11_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_11_Slaapkamer.port_a,preTem_space_Huis_nr_11_Slaapkamer.port);
  connect(theCon_space__Huis_nr_11_Slaapkamer.port_b,zone__Huis_nr_11_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_13_Badkamer.port_a,preTem_space_Huis_nr_13_Badkamer.port);
  connect(theCon_space__Huis_nr_13_Badkamer.port_b,zone__Huis_nr_13_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_13_Leefruimte.port_a,preTem_space_Huis_nr_13_Leefruimte.port);
  connect(theCon_space__Huis_nr_13_Leefruimte.port_b,zone__Huis_nr_13_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_13_Slaapkamer.port_a,preTem_space_Huis_nr_13_Slaapkamer.port);
  connect(theCon_space__Huis_nr_13_Slaapkamer.port_b,zone__Huis_nr_13_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_15_Badkamer.port_a,preTem_space_Huis_nr_15_Badkamer.port);
  connect(theCon_space__Huis_nr_15_Badkamer.port_b,zone__Huis_nr_15_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_15_Leefruimte.port_a,preTem_space_Huis_nr_15_Leefruimte.port);
  connect(theCon_space__Huis_nr_15_Leefruimte.port_b,zone__Huis_nr_15_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_15_Slaapkamer.port_a,preTem_space_Huis_nr_15_Slaapkamer.port);
  connect(theCon_space__Huis_nr_15_Slaapkamer.port_b,zone__Huis_nr_15_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_17_Badkamer.port_a,preTem_space_Huis_nr_17_Badkamer.port);
  connect(theCon_space__Huis_nr_17_Badkamer.port_b,zone__Huis_nr_17_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_17_Inkom.port_a,preTem_space_Huis_nr_17_Inkom.port);
  connect(theCon_space__Huis_nr_17_Inkom.port_b,zone__Huis_nr_17_Inkom.gainCon);
  connect(theCon_space__Huis_nr_17_Leefruimte.port_a,preTem_space_Huis_nr_17_Leefruimte.port);
  connect(theCon_space__Huis_nr_17_Leefruimte.port_b,zone__Huis_nr_17_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_17_Slaapkamer.port_a,preTem_space_Huis_nr_17_Slaapkamer.port);
  connect(theCon_space__Huis_nr_17_Slaapkamer.port_b,zone__Huis_nr_17_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_19_Badkamer.port_a,preTem_space_Huis_nr_19_Badkamer.port);
  connect(theCon_space__Huis_nr_19_Badkamer.port_b,zone__Huis_nr_19_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_19_Inkom.port_a,preTem_space_Huis_nr_19_Inkom.port);
  connect(theCon_space__Huis_nr_19_Inkom.port_b,zone__Huis_nr_19_Inkom.gainCon);
  connect(theCon_space__Huis_nr_19_Leefruimte.port_a,preTem_space_Huis_nr_19_Leefruimte.port);
  connect(theCon_space__Huis_nr_19_Leefruimte.port_b,zone__Huis_nr_19_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_19_Slaapkamer.port_a,preTem_space_Huis_nr_19_Slaapkamer.port);
  connect(theCon_space__Huis_nr_19_Slaapkamer.port_b,zone__Huis_nr_19_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_21_Badkamer.port_a,preTem_space_Huis_nr_21_Badkamer.port);
  connect(theCon_space__Huis_nr_21_Badkamer.port_b,zone__Huis_nr_21_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_21_Inkom.port_a,preTem_space_Huis_nr_21_Inkom.port);
  connect(theCon_space__Huis_nr_21_Inkom.port_b,zone__Huis_nr_21_Inkom.gainCon);
  connect(theCon_space__Huis_nr_21_Leefruimte.port_a,preTem_space_Huis_nr_21_Leefruimte.port);
  connect(theCon_space__Huis_nr_21_Leefruimte.port_b,zone__Huis_nr_21_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_21_Slaapkamer.port_a,preTem_space_Huis_nr_21_Slaapkamer.port);
  connect(theCon_space__Huis_nr_21_Slaapkamer.port_b,zone__Huis_nr_21_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_23_Badkamer.port_a,preTem_space_Huis_nr_23_Badkamer.port);
  connect(theCon_space__Huis_nr_23_Badkamer.port_b,zone__Huis_nr_23_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_23_Leefruimte.port_a,preTem_space_Huis_nr_23_Leefruimte.port);
  connect(theCon_space__Huis_nr_23_Leefruimte.port_b,zone__Huis_nr_23_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_23_Slaapkamer.port_a,preTem_space_Huis_nr_23_Slaapkamer.port);
  connect(theCon_space__Huis_nr_23_Slaapkamer.port_b,zone__Huis_nr_23_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_25_Badkamer.port_a,preTem_space_Huis_nr_25_Badkamer.port);
  connect(theCon_space__Huis_nr_25_Badkamer.port_b,zone__Huis_nr_25_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_25_Leefruimte.port_a,preTem_space_Huis_nr_25_Leefruimte.port);
  connect(theCon_space__Huis_nr_25_Leefruimte.port_b,zone__Huis_nr_25_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_25_Slaapkamer.port_a,preTem_space_Huis_nr_25_Slaapkamer.port);
  connect(theCon_space__Huis_nr_25_Slaapkamer.port_b,zone__Huis_nr_25_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_27_Badkamer.port_a,preTem_space_Huis_nr_27_Badkamer.port);
  connect(theCon_space__Huis_nr_27_Badkamer.port_b,zone__Huis_nr_27_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_27_Leefruimte.port_a,preTem_space_Huis_nr_27_Leefruimte.port);
  connect(theCon_space__Huis_nr_27_Leefruimte.port_b,zone__Huis_nr_27_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_27_Slaapkamer.port_a,preTem_space_Huis_nr_27_Slaapkamer.port);
  connect(theCon_space__Huis_nr_27_Slaapkamer.port_b,zone__Huis_nr_27_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_29_Badkamer.port_a,preTem_space_Huis_nr_29_Badkamer.port);
  connect(theCon_space__Huis_nr_29_Badkamer.port_b,zone__Huis_nr_29_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_29_Leefruimte.port_a,preTem_space_Huis_nr_29_Leefruimte.port);
  connect(theCon_space__Huis_nr_29_Leefruimte.port_b,zone__Huis_nr_29_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_29_Slaapkamer.port_a,preTem_space_Huis_nr_29_Slaapkamer.port);
  connect(theCon_space__Huis_nr_29_Slaapkamer.port_b,zone__Huis_nr_29_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_31_Badkamer.port_a,preTem_space_Huis_nr_31_Badkamer.port);
  connect(theCon_space__Huis_nr_31_Badkamer.port_b,zone__Huis_nr_31_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_31_Inkom.port_a,preTem_space_Huis_nr_31_Inkom.port);
  connect(theCon_space__Huis_nr_31_Inkom.port_b,zone__Huis_nr_31_Inkom.gainCon);
  connect(theCon_space__Huis_nr_31_Leefruimte.port_a,preTem_space_Huis_nr_31_Leefruimte.port);
  connect(theCon_space__Huis_nr_31_Leefruimte.port_b,zone__Huis_nr_31_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_31_Slaapkamer.port_a,preTem_space_Huis_nr_31_Slaapkamer.port);
  connect(theCon_space__Huis_nr_31_Slaapkamer.port_b,zone__Huis_nr_31_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_3_Badkamer.port_a,preTem_space_Huis_nr_3_Badkamer.port);
  connect(theCon_space__Huis_nr_3_Badkamer.port_b,zone__Huis_nr_3_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_3_Inkom.port_a,preTem_space_Huis_nr_3_Inkom.port);
  connect(theCon_space__Huis_nr_3_Inkom.port_b,zone__Huis_nr_3_Inkom.gainCon);
  connect(theCon_space__Huis_nr_3_Leefruimte.port_a,preTem_space_Huis_nr_3_Leefruimte.port);
  connect(theCon_space__Huis_nr_3_Leefruimte.port_b,zone__Huis_nr_3_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_3_Slaapkamer.port_a,preTem_space_Huis_nr_3_Slaapkamer.port);
  connect(theCon_space__Huis_nr_3_Slaapkamer.port_b,zone__Huis_nr_3_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_5_Badkamer.port_a,preTem_space_Huis_nr_5_Badkamer.port);
  connect(theCon_space__Huis_nr_5_Badkamer.port_b,zone__Huis_nr_5_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_5_Inkom.port_a,preTem_space_Huis_nr_5_Inkom.port);
  connect(theCon_space__Huis_nr_5_Inkom.port_b,zone__Huis_nr_5_Inkom.gainCon);
  connect(theCon_space__Huis_nr_5_Leefruimte.port_a,preTem_space_Huis_nr_5_Leefruimte.port);
  connect(theCon_space__Huis_nr_5_Leefruimte.port_b,zone__Huis_nr_5_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_5_Slaapkamer.port_a,preTem_space_Huis_nr_5_Slaapkamer.port);
  connect(theCon_space__Huis_nr_5_Slaapkamer.port_b,zone__Huis_nr_5_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_7_Badkamer.port_a,preTem_space_Huis_nr_7_Badkamer.port);
  connect(theCon_space__Huis_nr_7_Badkamer.port_b,zone__Huis_nr_7_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_7_Inkom.port_a,preTem_space_Huis_nr_7_Inkom.port);
  connect(theCon_space__Huis_nr_7_Inkom.port_b,zone__Huis_nr_7_Inkom.gainCon);
  connect(theCon_space__Huis_nr_7_Leefruimte.port_a,preTem_space_Huis_nr_7_Leefruimte.port);
  connect(theCon_space__Huis_nr_7_Leefruimte.port_b,zone__Huis_nr_7_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_7_Slaapkamer.port_a,preTem_space_Huis_nr_7_Slaapkamer.port);
  connect(theCon_space__Huis_nr_7_Slaapkamer.port_b,zone__Huis_nr_7_Slaapkamer.gainCon);
  connect(theCon_space__Huis_nr_9_Badkamer.port_a,preTem_space_Huis_nr_9_Badkamer.port);
  connect(theCon_space__Huis_nr_9_Badkamer.port_b,zone__Huis_nr_9_Badkamer.gainCon);
  connect(theCon_space__Huis_nr_9_Leefruimte.port_a,preTem_space_Huis_nr_9_Leefruimte.port);
  connect(theCon_space__Huis_nr_9_Leefruimte.port_b,zone__Huis_nr_9_Leefruimte.gainCon);
  connect(theCon_space__Huis_nr_9_Slaapkamer.port_a,preTem_space_Huis_nr_9_Slaapkamer.port);
  connect(theCon_space__Huis_nr_9_Slaapkamer.port_b,zone__Huis_nr_9_Slaapkamer.gainCon);
  connect(theCon_space__Inkom_tech_lokaal_1_UC.port_a,preTem_space_Inkom_tech_lokaal_1_UC.port);
  connect(theCon_space__Inkom_tech_lokaal_1_UC.port_b,zone__Inkom_tech_lokaal_1_UC.gainCon);
  connect(theCon_space__Inkom_tech_lokaal_2_UC.port_a,preTem_space_Inkom_tech_lokaal_2_UC.port);
  connect(theCon_space__Inkom_tech_lokaal_2_UC.port_b,zone__Inkom_tech_lokaal_2_UC.gainCon);
  connect(theCon_space__Inkom_tech_lokaal_3_UC.port_a,preTem_space_Inkom_tech_lokaal_3_UC.port);
  connect(theCon_space__Inkom_tech_lokaal_3_UC.port_b,zone__Inkom_tech_lokaal_3_UC.gainCon);
  connect(theCon_space__Inkom_tech_ruimte_4_UC.port_a,preTem_space_Inkom_tech_ruimte_4_UC.port);
  connect(theCon_space__Inkom_tech_ruimte_4_UC.port_b,zone__Inkom_tech_ruimte_4_UC.gainCon);
  connect(theCon_space__Inkom_tech_ruimte_5_UC.port_a,preTem_space_Inkom_tech_ruimte_5_UC.port);
  connect(theCon_space__Inkom_tech_ruimte_5_UC.port_b,zone__Inkom_tech_ruimte_5_UC.gainCon);
  connect(theCon_space__Inkom_tech_ruimte_6_UC.port_a,preTem_space_Inkom_tech_ruimte_6_UC.port);
  connect(theCon_space__Inkom_tech_ruimte_6_UC.port_b,zone__Inkom_tech_ruimte_6_UC.gainCon);
  connect(theCon_space__Technische_ruimte_BEO_UC.port_a,preTem_space_Technische_ruimte_BEO_UC.port);
  connect(theCon_space__Technische_ruimte_BEO_UC.port_b,zone__Technische_ruimte_BEO_UC.gainCon);
  connect(window__Window_1.propsBus_a,zone__Huis_nr_13_Badkamer.propsBus[7]);
  connect(window__Window_1__2.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[11]);
  connect(window__Window_1__3.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[12]);
  connect(window__Window_1__4.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[12]);
  connect(window__Window_1__5.propsBus_a,zone__Huis_nr_11_Badkamer.propsBus[7]);
  connect(window__Window_1__6.propsBus_a,zone__Huis_nr_11_Slaapkamer.propsBus[7]);
  connect(window__Window_1__7.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[11]);
  connect(window__Window_1__8.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[10]);
  connect(window__Window_2.propsBus_a,zone__Huis_nr_13_Leefruimte.propsBus[10]);
  connect(window__Window_2__10.propsBus_a,zone__Huis_nr_17_Leefruimte.propsBus[11]);
  connect(window__Window_2__11.propsBus_a,zone__Huis_nr_17_Slaapkamer.propsBus[8]);
  connect(window__Window_2__12.propsBus_a,zone__Huis_nr_7_Leefruimte.propsBus[11]);
  connect(window__Window_2__13.propsBus_a,zone__Huis_nr_7_Slaapkamer.propsBus[8]);
  connect(window__Window_2__14.propsBus_a,zone__Huis_nr_11_Leefruimte.propsBus[11]);
  connect(window__Window_2__15.propsBus_a,zone__Huis_nr_9_Slaapkamer.propsBus[8]);
  connect(window__Window_2__16.propsBus_a,zone__Huis_nr_9_Leefruimte.propsBus[10]);
  connect(window__Window_2__17.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[11]);
  connect(window__Window_2__18.propsBus_a,zone__Huis_nr_5_Slaapkamer.propsBus[7]);
  connect(window__Window_2__19.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[9]);
  connect(window__Window_2__2.propsBus_a,zone__Huis_nr_15_Slaapkamer.propsBus[10]);
  connect(window__Window_2__20.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[10]);
  connect(window__Window_2__21.propsBus_a,zone__Huis_nr_25_Slaapkamer.propsBus[8]);
  connect(window__Window_2__22.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[16]);
  connect(window__Window_2__23.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[13]);
  connect(window__Window_2__3.propsBus_a,zone__Huis_nr_15_Leefruimte.propsBus[12]);
  connect(window__Window_2__4.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[10]);
  connect(window__Window_2__5.propsBus_a,zone__Huis_nr_21_Slaapkamer.propsBus[8]);
  connect(window__Window_2__6.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[10]);
  connect(window__Window_2__7.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[12]);
  connect(window__Window_2__8.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[11]);
  connect(window__Window_2__9.propsBus_a,zone__Huis_nr_29_Slaapkamer.propsBus[8]);
  connect(window__Window_3.propsBus_a,zone__Huis_nr_19_Slaapkamer.propsBus[7]);
  connect(window__Window_3__2.propsBus_a,zone__Huis_nr_19_Badkamer.propsBus[8]);
  connect(window__Window_3__3.propsBus_a,zone__Huis_nr_21_Leefruimte.propsBus[11]);
  connect(window__Window_3__4.propsBus_a,zone__Huis_nr_23_Slaapkamer.propsBus[7]);
  connect(window__Window_3__5.propsBus_a,zone__Huis_nr_31_Slaapkamer.propsBus[7]);
  connect(window__Window_3__6.propsBus_a,zone__Huis_nr_3_Slaapkamer.propsBus[9]);
  connect(window__Window_3__7.propsBus_a,zone__Huis_nr_27_Slaapkamer.propsBus[7]);
  connect(window__Window_3__8.propsBus_a,zone__Huis_nr_27_Slaapkamer.propsBus[8]);
  connect(window__Window_3__9.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[15]);
  connect(window__Window_4.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[7]);
  connect(window__Window_4__10.propsBus_a,zone__Huis_nr_31_Slaapkamer.propsBus[8]);
  connect(window__Window_4__11.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[8]);
  connect(window__Window_4__12.propsBus_a,zone__Huis_nr_31_Inkom.propsBus[9]);
  connect(window__Window_4__13.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[13]);
  connect(window__Window_4__14.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[14]);
  connect(window__Window_4__15.propsBus_a,zone__Huis_nr_19_Inkom.propsBus[8]);
  connect(window__Window_4__16.propsBus_a,zone__Inkom_tech_lokaal_2_UC.propsBus[7]);
  connect(window__Window_4__2.propsBus_a,zone__Huis_nr_25_Badkamer.propsBus[7]);
  connect(window__Window_4__3.propsBus_a,zone__Huis_nr_27_Badkamer.propsBus[8]);
  connect(window__Window_4__4.propsBus_a,zone__Technische_ruimte_BEO_UC.propsBus[14]);
  connect(window__Window_4__5.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[12]);
  connect(window__Window_4__6.propsBus_a,zone__Inkom_tech_ruimte_6_UC.propsBus[7]);
  connect(window__Window_4__7.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[19]);
  connect(window__Window_4__8.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[13]);
  connect(window__Window_4__9.propsBus_a,zone__Inkom_tech_ruimte_5_UC.propsBus[7]);
  connect(window__Window_5.propsBus_a,zone__Huis_nr_29_Leefruimte.propsBus[12]);
  connect(window__Window_5__2.propsBus_a,zone__Huis_nr_23_Leefruimte.propsBus[13]);
  connect(window__Window_5__3.propsBus_a,zone__Huis_nr_5_Leefruimte.propsBus[10]);
  connect(window__Window_5__4.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[17]);
  connect(window__Window_5__5.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[18]);
  connect(window__Window_5__6.propsBus_a,zone__Huis_nr_25_Leefruimte.propsBus[11]);
  connect(window__Window_5__7.propsBus_a,zone__Huis_nr_19_Leefruimte.propsBus[11]);
  connect(window__Window_5__8.propsBus_a,zone__Huis_nr_3_Leefruimte.propsBus[12]);
  connect(window__Window_6.propsBus_a,zone__Huis_nr_27_Leefruimte.propsBus[20]);
  connect(window__Window_7.propsBus_a,zone__Huis_nr_31_Leefruimte.propsBus[8]);
  connect(window__Window_8.propsBus_a,zone__Huis_nr_13_Slaapkamer.propsBus[7]);

    connect(fixedHeatFlow_Huis_nr_11_Badkamer_conv.port, zone__Huis_nr_11_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_11_Badkamer_rad.port, zone__Huis_nr_11_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_11_Leefruimte_conv.port, zone__Huis_nr_11_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_11_Leefruimte_rad.port, zone__Huis_nr_11_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_11_Slaapkamer_conv.port, zone__Huis_nr_11_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_11_Slaapkamer_rad.port, zone__Huis_nr_11_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_13_Badkamer_conv.port, zone__Huis_nr_13_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_13_Badkamer_rad.port, zone__Huis_nr_13_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_13_Leefruimte_conv.port, zone__Huis_nr_13_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_13_Leefruimte_rad.port, zone__Huis_nr_13_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_13_Slaapkamer_conv.port, zone__Huis_nr_13_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_13_Slaapkamer_rad.port, zone__Huis_nr_13_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_15_Badkamer_conv.port, zone__Huis_nr_15_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_15_Badkamer_rad.port, zone__Huis_nr_15_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_15_Leefruimte_conv.port, zone__Huis_nr_15_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_15_Leefruimte_rad.port, zone__Huis_nr_15_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_15_Slaapkamer_conv.port, zone__Huis_nr_15_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_15_Slaapkamer_rad.port, zone__Huis_nr_15_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_17_Badkamer_conv.port, zone__Huis_nr_17_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_17_Badkamer_rad.port, zone__Huis_nr_17_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_17_Leefruimte_conv.port, zone__Huis_nr_17_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_17_Leefruimte_rad.port, zone__Huis_nr_17_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_17_Slaapkamer_conv.port, zone__Huis_nr_17_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_17_Slaapkamer_rad.port, zone__Huis_nr_17_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_19_Badkamer_conv.port, zone__Huis_nr_19_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_19_Badkamer_rad.port, zone__Huis_nr_19_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_19_Leefruimte_conv.port, zone__Huis_nr_19_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_19_Leefruimte_rad.port, zone__Huis_nr_19_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_19_Slaapkamer_conv.port, zone__Huis_nr_19_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_19_Slaapkamer_rad.port, zone__Huis_nr_19_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_21_Badkamer_conv.port, zone__Huis_nr_21_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_21_Badkamer_rad.port, zone__Huis_nr_21_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_21_Leefruimte_conv.port, zone__Huis_nr_21_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_21_Leefruimte_rad.port, zone__Huis_nr_21_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_21_Slaapkamer_conv.port, zone__Huis_nr_21_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_21_Slaapkamer_rad.port, zone__Huis_nr_21_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_23_Badkamer_conv.port, zone__Huis_nr_23_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_23_Badkamer_rad.port, zone__Huis_nr_23_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_23_Leefruimte_conv.port, zone__Huis_nr_23_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_23_Leefruimte_rad.port, zone__Huis_nr_23_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_23_Slaapkamer_conv.port, zone__Huis_nr_23_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_23_Slaapkamer_rad.port, zone__Huis_nr_23_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_25_Badkamer_conv.port, zone__Huis_nr_25_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_25_Badkamer_rad.port, zone__Huis_nr_25_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_25_Leefruimte_conv.port, zone__Huis_nr_25_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_25_Leefruimte_rad.port, zone__Huis_nr_25_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_25_Slaapkamer_conv.port, zone__Huis_nr_25_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_25_Slaapkamer_rad.port, zone__Huis_nr_25_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_27_Badkamer_conv.port, zone__Huis_nr_27_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_27_Badkamer_rad.port, zone__Huis_nr_27_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_27_Leefruimte_conv.port, zone__Huis_nr_27_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_27_Leefruimte_rad.port, zone__Huis_nr_27_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_27_Slaapkamer_conv.port, zone__Huis_nr_27_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_27_Slaapkamer_rad.port, zone__Huis_nr_27_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_29_Badkamer_conv.port, zone__Huis_nr_29_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_29_Badkamer_rad.port, zone__Huis_nr_29_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_29_Leefruimte_conv.port, zone__Huis_nr_29_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_29_Leefruimte_rad.port, zone__Huis_nr_29_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_29_Slaapkamer_conv.port, zone__Huis_nr_29_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_29_Slaapkamer_rad.port, zone__Huis_nr_29_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_31_Badkamer_conv.port, zone__Huis_nr_31_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_31_Badkamer_rad.port, zone__Huis_nr_31_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_31_Leefruimte_conv.port, zone__Huis_nr_31_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_31_Leefruimte_rad.port, zone__Huis_nr_31_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_31_Slaapkamer_conv.port, zone__Huis_nr_31_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_31_Slaapkamer_rad.port, zone__Huis_nr_31_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_3_Badkamer_conv.port, zone__Huis_nr_3_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_3_Badkamer_rad.port, zone__Huis_nr_3_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_3_Leefruimte_conv.port, zone__Huis_nr_3_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_3_Leefruimte_rad.port, zone__Huis_nr_3_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_3_Slaapkamer_conv.port, zone__Huis_nr_3_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_3_Slaapkamer_rad.port, zone__Huis_nr_3_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_5_Badkamer_conv.port, zone__Huis_nr_5_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_5_Badkamer_rad.port, zone__Huis_nr_5_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_5_Leefruimte_conv.port, zone__Huis_nr_5_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_5_Leefruimte_rad.port, zone__Huis_nr_5_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_5_Slaapkamer_conv.port, zone__Huis_nr_5_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_5_Slaapkamer_rad.port, zone__Huis_nr_5_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_7_Badkamer_conv.port, zone__Huis_nr_7_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_7_Badkamer_rad.port, zone__Huis_nr_7_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_7_Leefruimte_conv.port, zone__Huis_nr_7_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_7_Leefruimte_rad.port, zone__Huis_nr_7_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_7_Slaapkamer_conv.port, zone__Huis_nr_7_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_7_Slaapkamer_rad.port, zone__Huis_nr_7_Slaapkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_9_Badkamer_conv.port, zone__Huis_nr_9_Badkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_9_Badkamer_rad.port, zone__Huis_nr_9_Badkamer.gainRad);
  connect(fixedHeatFlow_Huis_nr_9_Leefruimte_conv.port, zone__Huis_nr_9_Leefruimte.gainCon);
  connect(fixedHeatFlow_Huis_nr_9_Leefruimte_rad.port, zone__Huis_nr_9_Leefruimte.gainRad);
  connect(fixedHeatFlow_Huis_nr_9_Slaapkamer_conv.port, zone__Huis_nr_9_Slaapkamer.gainCon);
  connect(fixedHeatFlow_Huis_nr_9_Slaapkamer_rad.port, zone__Huis_nr_9_Slaapkamer.gainRad);

  annotation (Diagram(coordinateSystem(extent={{-519.0,-76.0},{503.00000000000006,770}},initialScale=0.1),
    graphics={
      Line(points={{-519.0,-76.0},{-495.0,-76.0}},  color={28,108,200}),
      Line(points={{-495.0,-76.0},{-495.0,-28.000000000000004}},  color={28,108,200}),
      Line(points={{-519.0,-28.000000000000004},{-519.0,-76.0}},  color={28,108,200}),
      Line(points={{-495.0,-28.000000000000004},{-463.00000000000006,-28.000000000000004}},  color={28,108,200}),
      Line(points={{-463.00000000000006,-28.000000000000004},{-463.00000000000006,-76.0}},  color={28,108,200}),
      Line(points={{-463.00000000000006,-76.0},{-495.0,-76.0}},  color={28,108,200}),
      Line(points={{-463.00000000000006,-76.0},{-398.00000000000006,-76.0}},  color={28,108,200}),
      Line(points={{-417.0,-11.0},{-463.00000000000006,-11.0}},  color={28,108,200}),
      Line(points={{-463.00000000000006,-11.0},{-463.00000000000006,-28.000000000000004}},  color={28,108,200}),
      Line(points={{-398.00000000000006,-31.0},{-417.0,-31.0}},  color={28,108,200}),
      Line(points={{-417.0,-31.0},{-417.0,-11.0}},  color={28,108,200}),
      Line(points={{-417.0,-11.0},{-398.00000000000006,-11.0}},  color={28,108,200}),
      Line(points={{-398.00000000000006,-11.0},{-398.00000000000006,-31.0}},  color={28,108,200}),
      Line(points={{-398.00000000000006,-76.0},{-368.00000000000006,-76.0}},  color={28,108,200}),
      Line(points={{-368.00000000000006,-76.0},{-368.00000000000006,-52.0}},  color={28,108,200}),
      Line(points={{-368.00000000000006,-52.0},{-398.00000000000006,-52.0}},  color={28,108,200}),
      Line(points={{-398.00000000000006,-52.0},{-398.00000000000006,-76.0}},  color={28,108,200}),
      Line(points={{-398.00000000000006,-52.0},{-398.00000000000006,-31.0}},  color={28,108,200}),
      Line(points={{-398.00000000000006,-11.0},{-368.00000000000006,-11.0}},  color={28,108,200}),
      Line(points={{-368.00000000000006,-11.0},{-368.00000000000006,-52.0}},  color={28,108,200}),
      Line(points={{-368.00000000000006,-11.0},{-320.0,-11.0}},  color={28,108,200}),
      Line(points={{-368.00000000000006,-76.0},{-287.0,-76.0}},  color={28,108,200}),
      Line(points={{-287.0,-76.0},{-287.0,-43.0}},  color={28,108,200}),
      Line(points={{-287.0,-43.0},{-320.0,-43.0}},  color={28,108,200}),
      Line(points={{-320.0,-43.0},{-320.0,-11.0}},  color={28,108,200}),
      Line(points={{-287.0,-76.0},{-259.0,-76.0}},  color={28,108,200}),
      Line(points={{-259.0,-43.0},{-287.0,-43.0}},  color={28,108,200}),
      Line(points={{-259.0,-76.0},{-210.0,-76.0}},  color={28,108,200}),
      Line(points={{-259.0,-43.0},{-239.00000000000003,-43.0}},  color={28,108,200}),
      Line(points={{-210.0,-43.0},{-239.00000000000003,-43.0}},  color={28,108,200}),
      Line(points={{-239.00000000000003,-43.0},{-239.00000000000003,-22.0}},  color={28,108,200}),
      Line(points={{-239.00000000000003,-22.0},{-210.0,-22.0}},  color={28,108,200}),
      Line(points={{-210.0,-22.0},{-210.0,-43.0}},  color={28,108,200}),
      Line(points={{-210.0,31.0},{-287.0,31.0}},  color={28,108,200}),
      Line(points={{-210.0,31.0},{-210.0,-22.0}},  color={28,108,200}),
      Line(points={{-259.0,-43.0},{-259.0,-2.0}},  color={28,108,200}),
      Line(points={{-259.0,-76.0},{-259.0,-43.0}},  color={28,108,200}),
      Line(points={{-287.0,-2.0},{-259.0,-2.0}},  color={28,108,200}),
      Line(points={{-287.0,31.0},{-287.0,-2.0}},  color={28,108,200}),
      Line(points={{-287.0,-43.0},{-287.0,-2.0}},  color={28,108,200}),
      Line(points={{-210.0,-76.0},{-210.0,-43.0}},  color={28,108,200}),
      Line(points={{-98.0,-39.0},{-126.00000000000001,-39.0}},  color={28,108,200}),
      Line(points={{-126.00000000000001,-39.0},{-126.00000000000001,-76.0}},  color={28,108,200}),
      Line(points={{-126.00000000000001,-76.0},{-51.00000000000001,-76.0}},  color={28,108,200}),
      Line(points={{-51.00000000000001,-76.0},{-51.00000000000001,-22.0}},  color={28,108,200}),
      Line(points={{-51.00000000000001,-22.0},{-98.0,-22.0}},  color={28,108,200}),
      Line(points={{-98.0,-22.0},{-98.0,-39.0}},  color={28,108,200}),
      Line(points={{-51.00000000000001,-22.0},{-37.0,-22.0}},  color={28,108,200}),
      Line(points={{-37.0,-76.0},{-51.00000000000001,-76.0}},  color={28,108,200}),
      Line(points={{-37.0,-22.0},{-7.000000000000001,-22.0}},  color={28,108,200}),
      Line(points={{-7.000000000000001,-22.0},{-7.000000000000001,-54.0}},  color={28,108,200}),
      Line(points={{-7.000000000000001,-54.0},{-37.0,-54.0}},  color={28,108,200}),
      Line(points={{-37.0,-54.0},{-37.0,-22.0}},  color={28,108,200}),
      Line(points={{-37.0,-54.0},{-37.0,-76.0}},  color={28,108,200}),
      Line(points={{-37.0,-76.0},{-7.000000000000001,-76.0}},  color={28,108,200}),
      Line(points={{-7.000000000000001,-76.0},{-7.000000000000001,-54.0}},  color={28,108,200}),
      Line(points={{-7.000000000000001,-22.0},{34.0,-22.0}},  color={28,108,200}),
      Line(points={{34.0,-76.0},{-7.000000000000001,-76.0}},  color={28,108,200}),
      Line(points={{34.0,-76.0},{61.00000000000001,-76.0}},  color={28,108,200}),
      Line(points={{61.00000000000001,-76.0},{61.00000000000001,-55.0}},  color={28,108,200}),
      Line(points={{61.00000000000001,-55.0},{34.0,-55.0}},  color={28,108,200}),
      Line(points={{34.0,-55.0},{34.0,-76.0}},  color={28,108,200}),
      Line(points={{34.0,-22.0},{34.0,-55.0}},  color={28,108,200}),
      Line(points={{34.0,-22.0},{61.00000000000001,-22.0}},  color={28,108,200}),
      Line(points={{61.00000000000001,-22.0},{61.00000000000001,-55.0}},  color={28,108,200}),
      Line(points={{61.00000000000001,-22.0},{91.0,-22.0}},  color={28,108,200}),
      Line(points={{61.00000000000001,-76.0},{134.0,-76.0}},  color={28,108,200}),
      Line(points={{134.0,-76.0},{134.0,-39.0}},  color={28,108,200}),
      Line(points={{91.0,-39.0},{91.0,-22.0}},  color={28,108,200}),
      Line(points={{91.0,-22.0},{108.0,-22.0}},  color={28,108,200}),
      Line(points={{108.0,-22.0},{108.0,-39.0}},  color={28,108,200}),
      Line(points={{108.0,-39.0},{91.0,-39.0}},  color={28,108,200}),
      Line(points={{134.0,-39.0},{108.0,-39.0}},  color={28,108,200}),
      Line(points={{-495.0,177.0},{-519.0,177.0}},  color={28,108,200}),
      Line(points={{-495.0,131.0},{-495.0,177.0}},  color={28,108,200}),
      Line(points={{-519.0,177.0},{-519.0,131.0}},  color={28,108,200}),
      Line(points={{-495.0,177.0},{-464.00000000000006,177.0}},  color={28,108,200}),
      Line(points={{-464.00000000000006,177.0},{-464.00000000000006,131.0}},  color={28,108,200}),
      Line(points={{-464.00000000000006,131.0},{-495.0,131.0}},  color={28,108,200}),
      Line(points={{-464.00000000000006,177.0},{-400.0,177.0}},  color={28,108,200}),
      Line(points={{-417.0,115.0},{-464.00000000000006,115.0}},  color={28,108,200}),
      Line(points={{-464.00000000000006,115.0},{-464.00000000000006,131.0}},  color={28,108,200}),
      Line(points={{-417.0,155.0},{-400.0,155.0}},  color={28,108,200}),
      Line(points={{-400.0,155.0},{-400.0,177.0}},  color={28,108,200}),
      Line(points={{-400.0,177.0},{-369.0,177.0}},  color={28,108,200}),
      Line(points={{-369.0,177.0},{-369.0,155.0}},  color={28,108,200}),
      Line(points={{-369.0,155.0},{-400.0,155.0}},  color={28,108,200}),
      Line(points={{-369.0,155.0},{-369.0,132.0}},  color={28,108,200}),
      Line(points={{-417.0,155.0},{-417.0,115.0}},  color={28,108,200}),
      Line(points={{-417.0,115.0},{-386.0,115.0}},  color={28,108,200}),
      Line(points={{-386.0,115.0},{-386.0,132.0}},  color={28,108,200}),
      Line(points={{-386.0,132.0},{-369.0,132.0}},  color={28,108,200}),
      Line(points={{-369.0,177.0},{-287.0,177.0}},  color={28,108,200}),
      Line(points={{-320.0,115.0},{-369.0,115.0}},  color={28,108,200}),
      Line(points={{-369.0,115.0},{-369.0,132.0}},  color={28,108,200}),
      Line(points={{-320.0,115.0},{-320.0,147.0}},  color={28,108,200}),
      Line(points={{-320.0,147.0},{-287.0,147.0}},  color={28,108,200}),
      Line(points={{-287.0,147.0},{-287.0,177.0}},  color={28,108,200}),
      Line(points={{-369.0,115.0},{-386.0,115.0}},  color={28,108,200}),
      Line(points={{-287.0,177.0},{-259.0,177.0}},  color={28,108,200}),
      Line(points={{-259.0,177.0},{-259.0,147.0}},  color={28,108,200}),
      Line(points={{-259.0,147.0},{-287.0,147.0}},  color={28,108,200}),
      Line(points={{-259.0,177.0},{-210.0,177.0}},  color={28,108,200}),
      Line(points={{-210.0,177.0},{-210.0,147.0}},  color={28,108,200}),
      Line(points={{-210.0,147.0},{-239.00000000000003,147.0}},  color={28,108,200}),
      Line(points={{-239.00000000000003,147.0},{-239.00000000000003,126.00000000000001}},  color={28,108,200}),
      Line(points={{-239.00000000000003,126.00000000000001},{-210.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{-239.00000000000003,147.0},{-259.0,147.0}},  color={28,108,200}),
      Line(points={{-259.0,147.0},{-259.0,105.0}},  color={28,108,200}),
      Line(points={{-210.0,72.0},{-287.0,72.0}},  color={28,108,200}),
      Line(points={{-210.0,72.0},{-210.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{-259.0,105.0},{-287.0,105.0}},  color={28,108,200}),
      Line(points={{-287.0,105.0},{-287.0,72.0}},  color={28,108,200}),
      Line(points={{-287.0,147.0},{-287.0,105.0}},  color={28,108,200}),
      Line(points={{-139.0,126.00000000000001},{-139.0,145.0}},  color={28,108,200}),
      Line(points={{-210.0,126.00000000000001},{-210.0,147.0}},  color={28,108,200}),
      Line(points={{-172.0,126.00000000000001},{-139.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{-139.0,145.0},{-172.0,145.0}},  color={28,108,200}),
      Line(points={{-172.0,145.0},{-172.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{-172.0,177.0},{-91.0,177.0}},  color={28,108,200}),
      Line(points={{-172.0,177.0},{-172.0,145.0}},  color={28,108,200}),
      Line(points={{-139.0,126.00000000000001},{-91.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{-91.0,177.0},{-57.0,177.0}},  color={28,108,200}),
      Line(points={{-57.0,177.0},{-57.0,143.0}},  color={28,108,200}),
      Line(points={{-57.0,143.0},{-91.0,143.0}},  color={28,108,200}),
      Line(points={{-91.0,143.0},{-91.0,177.0}},  color={28,108,200}),
      Line(points={{-91.0,126.00000000000001},{-91.0,143.0}},  color={28,108,200}),
      Line(points={{-57.0,177.0},{-39.0,177.0}},  color={28,108,200}),
      Line(points={{-39.0,143.0},{-57.0,143.0}},  color={28,108,200}),
      Line(points={{-39.0,177.0},{-6.000000000000001,177.0}},  color={28,108,200}),
      Line(points={{-6.000000000000001,177.0},{-6.000000000000001,159.0}},  color={28,108,200}),
      Line(points={{-6.000000000000001,159.0},{-39.0,159.0}},  color={28,108,200}),
      Line(points={{-39.0,159.0},{-39.0,177.0}},  color={28,108,200}),
      Line(points={{-39.0,159.0},{-39.0,143.0}},  color={28,108,200}),
      Line(points={{-6.000000000000001,159.0},{-6.000000000000001,126.00000000000001}},  color={28,108,200}),
      Line(points={{-6.000000000000001,126.00000000000001},{-39.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{-39.0,126.00000000000001},{-39.0,143.0}},  color={28,108,200}),
      Line(points={{-6.000000000000001,177.0},{8.0,177.0}},  color={28,108,200}),
      Line(points={{8.0,126.00000000000001},{-6.000000000000001,126.00000000000001}},  color={28,108,200}),
      Line(points={{8.0,177.0},{79.0,177.0}},  color={28,108,200}),
      Line(points={{8.0,144.0},{8.0,177.0}},  color={28,108,200}),
      Line(points={{8.0,144.0},{8.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{8.0,144.0},{22.0,144.0}},  color={28,108,200}),
      Line(points={{22.0,144.0},{22.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{22.0,126.00000000000001},{79.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{79.0,126.00000000000001},{79.0,159.0}},  color={28,108,200}),
      Line(points={{22.0,126.00000000000001},{8.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{79.0,177.0},{119.0,177.0}},  color={28,108,200}),
      Line(points={{119.0,177.0},{119.0,159.0}},  color={28,108,200}),
      Line(points={{119.0,159.0},{79.0,159.0}},  color={28,108,200}),
      Line(points={{79.0,159.0},{79.0,177.0}},  color={28,108,200}),
      Line(points={{119.0,159.0},{119.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{119.0,126.00000000000001},{79.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{119.0,177.0},{210.0,177.0}},  color={28,108,200}),
      Line(points={{167.0,126.00000000000001},{119.0,126.00000000000001}},  color={28,108,200}),
      Line(points={{167.0,126.00000000000001},{167.0,143.0}},  color={28,108,200}),
      Line(points={{167.0,143.0},{196.0,143.0}},  color={28,108,200}),
      Line(points={{196.0,143.0},{196.0,152.0}},  color={28,108,200}),
      Line(points={{196.0,152.0},{210.0,152.0}},  color={28,108,200}),
      Line(points={{210.0,152.0},{210.0,177.0}},  color={28,108,200}),
      Line(points={{210.0,177.0},{284.0,177.0}},  color={28,108,200}),
      Line(points={{210.0,143.0},{210.0,152.0}},  color={28,108,200}),
      Line(points={{210.0,143.0},{236.0,143.0}},  color={28,108,200}),
      Line(points={{236.0,143.0},{236.0,123.0}},  color={28,108,200}),
      Line(points={{236.0,123.0},{284.0,123.0}},  color={28,108,200}),
      Line(points={{284.0,177.0},{312.0,177.0}},  color={28,108,200}),
      Line(points={{312.0,177.0},{312.0,159.0}},  color={28,108,200}),
      Line(points={{312.0,159.0},{284.0,159.0}},  color={28,108,200}),
      Line(points={{284.0,159.0},{284.0,177.0}},  color={28,108,200}),
      Line(points={{284.0,123.0},{284.0,159.0}},  color={28,108,200}),
      Line(points={{312.0,123.0},{284.0,123.0}},  color={28,108,200}),
      Line(points={{312.0,177.0},{332.0,177.0}},  color={28,108,200}),
      Line(points={{332.0,177.0},{332.0,143.0}},  color={28,108,200}),
      Line(points={{332.0,143.0},{312.0,143.0}},  color={28,108,200}),
      Line(points={{312.0,159.0},{312.0,143.0}},  color={28,108,200}),
      Line(points={{312.0,143.0},{312.0,123.0}},  color={28,108,200}),
      Line(points={{332.0,177.0},{368.00000000000006,177.0}},  color={28,108,200}),
      Line(points={{368.00000000000006,177.0},{368.00000000000006,143.0}},  color={28,108,200}),
      Line(points={{368.00000000000006,143.0},{332.0,143.0}},  color={28,108,200}),
      Line(points={{368.00000000000006,177.0},{384.00000000000006,184.00000000000003}},  color={28,108,200}),
      Line(points={{384.00000000000006,184.00000000000003},{367.0,227.00000000000003}},  color={28,108,200}),
      Line(points={{367.0,227.00000000000003},{319.0,208.0}},  color={28,108,200}),
      Line(points={{319.0,208.0},{332.0,177.0}},  color={28,108,200}),
      Line(points={{384.00000000000006,184.00000000000003},{406.0,129.0}},  color={28,108,200}),
      Line(points={{406.0,129.0},{379.0,118.0}},  color={28,108,200}),
      Line(points={{379.0,118.0},{368.00000000000006,143.0}},  color={28,108,200}),
      Line(points={{312.0,123.0},{332.0,123.0}},  color={28,108,200}),
      Line(points={{332.0,123.0},{332.0,143.0}},  color={28,108,200}),
      Line(points={{196.0,143.0},{199.00000000000003,143.0}},  color={28,108,200}),
      Line(points={{210.0,143.0},{210.0,68.0}},  color={28,108,200}),
      Line(points={{199.00000000000003,143.0},{199.00000000000003,104.0}},  color={28,108,200}),
      Line(points={{199.00000000000003,104.0},{159.0,104.0}},  color={28,108,200}),
      Line(points={{159.0,104.0},{159.0,55.0}},  color={28,108,200}),
      Line(points={{210.0,68.0},{235.0,68.0}},  color={28,108,200}),
      Line(points={{235.0,68.0},{235.0,49.0}},  color={28,108,200}),
      Line(points={{210.0,55.0},{210.0,68.0}},  color={28,108,200}),
      Line(points={{223.0,49.0},{223.0,27.0}},  color={28,108,200}),
      Line(points={{223.0,49.0},{235.0,49.0}},  color={28,108,200}),
      Line(points={{210.0,55.0},{176.0,55.0}},  color={28,108,200}),
      Line(points={{176.0,55.0},{176.0,28.000000000000004}},  color={28,108,200}),
      Line(points={{159.0,55.0},{176.0,55.0}},  color={28,108,200}),
      Line(points={{176.0,28.000000000000004},{209.00000000000003,28.000000000000004}},  color={28,108,200}),
      Line(points={{209.00000000000003,28.000000000000004},{209.00000000000003,-30.0}},  color={28,108,200}),
      Line(points={{209.00000000000003,-30.0},{257.0,-30.0}},  color={28,108,200}),
      Line(points={{257.0,-30.0},{311.0,-30.0}},  color={28,108,200}),
      Line(points={{311.0,-30.0},{311.0,5.0}},  color={28,108,200}),
      Line(points={{311.0,5.0},{257.0,5.0}},  color={28,108,200}),
      Line(points={{257.0,5.0},{257.0,-30.0}},  color={28,108,200}),
      Line(points={{311.0,-30.0},{329.0,-30.0}},  color={28,108,200}),
      Line(points={{329.0,5.0},{311.0,5.0}},  color={28,108,200}),
      Line(points={{329.0,5.0},{329.0,27.0}},  color={28,108,200}),
      Line(points={{329.0,27.0},{311.0,27.0}},  color={28,108,200}),
      Line(points={{311.0,27.0},{311.0,5.0}},  color={28,108,200}),
      Line(points={{257.0,27.0},{223.0,27.0}},  color={28,108,200}),
      Line(points={{257.0,5.0},{257.0,27.0}},  color={28,108,200}),
      Line(points={{329.0,27.0},{358.00000000000006,27.0}},  color={28,108,200}),
      Line(points={{358.00000000000006,27.0},{358.00000000000006,-10.0}},  color={28,108,200}),
      Line(points={{358.00000000000006,-10.0},{329.0,-10.0}},  color={28,108,200}),
      Line(points={{329.0,-30.0},{329.0,-10.0}},  color={28,108,200}),
      Line(points={{329.0,-10.0},{329.0,5.0}},  color={28,108,200}),
      Line(points={{329.0,-30.0},{358.00000000000006,-30.0}},  color={28,108,200}),
      Line(points={{358.00000000000006,-30.0},{358.00000000000006,-10.0}},  color={28,108,200}),
      Line(points={{358.00000000000006,27.0},{405.0,27.0}},  color={28,108,200}),
      Line(points={{358.00000000000006,-30.0},{433.00000000000006,-30.0}},  color={28,108,200}),
      Line(points={{433.00000000000006,-30.0},{433.00000000000006,6.000000000000001}},  color={28,108,200}),
      Line(points={{433.00000000000006,6.000000000000001},{431.0,22.0}},  color={28,108,200}),
      Line(points={{431.0,22.0},{405.0,22.0}},  color={28,108,200}),
      Line(points={{405.0,22.0},{405.0,27.0}},  color={28,108,200}),
      Line(points={{-519.0,-28.000000000000004},{-515.0,-28.000000000000004}},  color={28,108,200}),
      Line(points={{-515.0,131.0},{-519.0,131.0}},  color={28,108,200}),
      Line(points={{-495.0,-28.000000000000004},{-515.0,-28.000000000000004}},  color={28,108,200}),
      Line(points={{-515.0,131.0},{-495.0,131.0}},  color={28,108,200})}),
    uses(Modelica(version="4.0.0"),
         IDEAS(version="3.0.0")),
    experiment(
      StopTime=86400,
      __Dymola_fixedstepsize=15,
      __Dymola_Algorithm="Euler"),
    __Dymola_experimentSetupOutput(events=false));
end StijnSBaseRBC;
