within IOCSmod.ComponentModels.Thermal.SizeOpt.AirSourceHeatPumps;
model HeatPump_AirWaterOpt
  "Optimisation model of an air-water heat pump with linear estimation curve of the COP"
  replaceable package MediumAir = IDEAS.Media.Specialized.DryAir;
  replaceable package MediumWater = IDEAS.Media.Water;
  outer IDEAS.BoundaryConditions.SimInfoManager sim "SimInfoManager";
  parameter Boolean use_onIn = false "= true, to replace optimization variable by input";

   parameter Real copDef = 5.8854 "Default COP";
  parameter Modelica.Units.SI.Temperature TAir_nominal = 12.59 + 273.15 "Nominal air temperature for COP calculation";
  parameter Modelica.Units.SI.Temperature TConOut_nominal = 34.3714 +273.15 "Nominal condensor leaving temperature for COP calculation";
  parameter Real coeffEva = 0.1537 "Linearisation coefficient of air temperature in COP calculation";
  parameter Real coeffCon = -0.1421 "Linearisation coefficient of leaving condensor temperature in COP calculation";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal = m2_flow_nominal * cp_water / cp_air "Nominal mass flow rate at air side";
  parameter Modelica.Units.SI.PressureDifference dp_nominalEva = 300 "Pressure difference at evaporator (air side)";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal "Nominal mass flow rate at water side";
  parameter Modelica.Units.SI.PressureDifference dp_nominalCon = 0 "Pressure difference at condenser (water side)";
  parameter Boolean addDummyEquation = false "=true, to balance equations in dymola";
  constant Modelica.Units.SI.SpecificHeatCapacity cp_air = 1006 "Specific heat capacity of air";
  constant Modelica.Units.SI.SpecificHeatCapacity cp_water = 4183 "Specific heat capacity of water";
  parameter String u_name = "" "Optional: control measurement name for reading from bacnet" annotation (
    Evaluate = true,
    Dialog(group = "Optimization"));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumWater)                                                                   annotation (
    Placement(transformation(extent = {{90, 50}, {110, 70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumWater)                                                                   annotation (
    Placement(transformation(extent = {{90, -70}, {110, -50}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(      redeclare package Medium = MediumAir,
    use_T_in=true,                                                                         nPorts = 2) annotation (
    Placement(transformation(extent={{-102,-10},{-82,10}})));

  UnitTests.Components.FlowControlled_m_flow fan(redeclare package Medium = MediumAir, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, allowFlowReversal = false, m_flow_nominal = m1_flow_nominal, addPowerToMedium = false, use_inputFilter = false, dp_nominal = dp_nominalEva) annotation (
    Placement(transformation(extent = {{-54, -30}, {-34, -10}})));
  Modelica.Blocks.Interfaces.RealOutput PEl "Electrical power of the heat pump" annotation (
    Placement(visible=true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {0, 110}), iconTransformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {0, 110})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=HP.m2_flow*cp_water/
        cp_air)                                                              annotation (
    Placement(transformation(extent={{-88,50},{-68,70}})));
  Modelica.Blocks.Interfaces.RealOutput TConOut "Condenser outlet temperature" annotation (
    Placement(visible = true, transformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput on_in if use_onIn "On/off signal for heat pump" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 270, origin = {-60, 120})));
  Modelica.Blocks.Interfaces.RealOutput QCon "Condenser thermal power" annotation (
    Placement(visible = true, transformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  IOCSmod.ComponentModels.Thermal.AirSourceHeatPumps.HeatPump_AirWaterInside HP(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    dT_max=dT_max,
    copDef=copDef,
    TAir_nominal=TAir_nominal,
    TConOut_nominal=TConOut_nominal,
    coeffEva=coeffEva,
    coeffCon=coeffCon,
    addDummyEquation=addDummyEquation,
    dp_nominalCon=dp_nominalCon,
    dp_nominalEva=dp_nominalEva,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    mod_start=0,
    u_name=u_name,
    use_onIn=use_onIn) "heat pump model" annotation (Placement(visible=true,
        transformation(
        origin={0,-48},
        extent={{10,10},{-10,-10}},
        rotation=-90)));
  Modelica.Blocks.Interfaces.RealOutput COP "Coefficient of performance" annotation (
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput TConIn "Condenser inlet water temperature" annotation (
    Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput Tair "Prescribed boundary temperature"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,30})));

  parameter Modelica.Units.SI.TemperatureDifference dT_max=5
    "Maximum temperature difference across condenser";
equation
  connect(bou.ports[1], fan.port_a) annotation (Line(points={{-82,2},{-68,2},{
          -68,-20},{-54,-20}},
                           color={0,127,255}));
  connect(fan.m_flow_in, realExpression.y) annotation (
    Line(points={{-44,-8},{-44,24},{-62,24},{-62,60},{-67,60}},
                                                     color = {0, 0, 127}));
  connect(HP.PEl, PEl)
    annotation (Line(points={{1.77636e-15,-37},{1.77636e-15,32},{0,32},{0,110}},
                                               color={0,0,127}));
  connect(HP.QCon, QCon) annotation (Line(points={{-2.9,-37},{-4,-37},{-4,40},{-20,
          40},{-20,110}}, color={0,0,127}));
  connect(HP.on, on_in) annotation (Line(points={{-11,-56},{-60,-56},{-60,120}},
        color={255,0,255}));
  connect(HP.port_b1, bou.ports[2]) annotation (Line(points={{-6,-38},{-6,22},{
          -68,22},{-68,-2},{-82,-2}},
                                  color={0,127,255}));
  connect(HP.port_a1, fan.port_b) annotation (Line(points={{-6,-58},{-34,-58},{-34,
          -20}}, color={0,127,255}));
  connect(HP.port_a2, port_a) annotation (Line(points={{6,-38},{14,-38},{14,60},
          {100,60}}, color={0,127,255}));
  connect(HP.port_b2, port_b)
    annotation (Line(points={{6,-58},{6,-60},{100,-60}}, color={0,127,255}));
  connect(HP.COP, COP) annotation (Line(points={{4,-37},{4,80},{-40,80},{-40,110}},
        color={0,0,127}));
  connect(HP.TCon, TConOut) annotation (Line(points={{2,-37},{2,86},{20,86},{20,
          110}}, color={0,0,127}));
  connect(HP.TConIn, TConIn) annotation (Line(points={{2,-37},{10,-37},{10,80},{
          40,80},{40,110}}, color={0,0,127}));
  connect(bou.T_in, Tair) annotation (Line(points={{-104,4},{-110,4},{-110,18},{
          -100,18},{-100,30}},  color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false), graphics={  Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                  FillPattern.Solid, extent = {{-70, 80}, {70, -80}}), Line(rotation = 180, points = {{-20, 0}, {40, 2.44929e-15}}, color = {255, 0, 0}, thickness = 0.5), Line(origin = {15, -2}, rotation = 360, points = {{-14, 21}, {6, 1}, {-14, -23}}, color = {255, 0, 0}, thickness = 0.5), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{38, -56}, {102, -66}}), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{38, 64}, {102, 54}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end HeatPump_AirWaterOpt;
