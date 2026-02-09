within IOCSmod.ComponentModels.Thermal.AirSourceChillers;
model Chiller_AirWater
  "Optimisation model of an air-water chiller with linear estimation curve of the EER"
  replaceable package MediumAir = IDEAS.Media.Specialized.DryAir;
  replaceable package MediumWater = IDEAS.Media.Water;
  outer IDEAS.BoundaryConditions.SimInfoManager sim "SimInfoManager";
  parameter Boolean use_onIn = false "= true, to replace optimization variable by input";

  parameter Real EERDef = 3.99 "Default EER";
  parameter Modelica.Units.SI.Temperature TAir_nominal = 25 + 273.15 "Nominal air temperature for EER calculation";
  parameter Modelica.Units.SI.Temperature TEvaOut_nominal = 7 + 273.15 "Nominal evaporater leaving temperature for EER calculation";
  parameter Real coeffEva = 0.106641 "Linearisation coefficient of evaporator leaving temperature in EER calculation";
  parameter Real coeffCon = -0.0998334 "Linearisation coefficient of air temperature in EER calculation";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal  "Nominal mass flow rate at evaporator (water) side";
  parameter Modelica.Units.SI.PressureDifference dp_nominalEva=1000 "Pressure difference at evaporator (water) side";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal = m1_flow_nominal * cp_water / cp_air "Nominal mass flow rate at condensor (air) side";
  parameter Modelica.Units.SI.PressureDifference dp_nominalCon=1000 "Pressure difference at condenser (air) side";
  parameter Boolean addDummyEquation = false "=true, to balance equations in dymola";
  parameter Modelica.Units.SI.Power Q_flow_nominal "Nominal cooling capacity (positive value)";
  constant Modelica.Units.SI.SpecificHeatCapacity cp_air = 1006 "Specific heat capacity of air";
  constant Modelica.Units.SI.SpecificHeatCapacity cp_water = 4183 "Specific heat capacity of water";
  parameter String u_name = "" "Optional: control measurement name for reading from bacnet" annotation (
    Evaluate = true,
    Dialog(group = "Optimization"));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumWater)                                                                   annotation (
    Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumWater)                                                                   annotation (
    Placement(transformation(extent={{90,50},{110,70}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(      redeclare package Medium = MediumAir,
    use_T_in=true,                                                                         nPorts=2)   annotation (
    Placement(transformation(extent={{-102,-10},{-82,10}})));

  UnitTests.Components.FlowControlled_m_flow fan(redeclare package Medium = MediumAir, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, allowFlowReversal = false,
    m_flow_nominal=m2_flow_nominal,                                                                                                                                                                                                        addPowerToMedium = false, use_inputFilter = false,
    dp_nominal=dp_nominalCon)                                                                                                                                                                                                         annotation (
    Placement(transformation(extent = {{-54, -30}, {-34, -10}})));
  Modelica.Blocks.Interfaces.RealOutput PEl "Electrical power of chiller" annotation (
    Placement(visible=true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {0, 110}), iconTransformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {0, 110})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=m2_flow_nominal)   annotation (
    Placement(transformation(extent={{-88,50},{-68,70}})));
  Modelica.Blocks.Interfaces.RealOutput TEvaOut "Evaporator outlet temperature" annotation (
    Placement(visible = true, transformation(origin = {20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput on_in if use_onIn "On/off signal for heat pump" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 270, origin = {-60, 120})));
  Modelica.Blocks.Interfaces.RealOutput QEva "Evaporator thermal power" annotation (
    Placement(visible = true, transformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Chiller_AirWaterInside Chi(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    EERDef=EERDef,
    TAir_nominal=TAir_nominal,
    TEvaOut_nominal=TEvaOut_nominal,
    coeffEva=coeffEva,
    coeffCon=coeffCon,
    addDummyEquation=addDummyEquation,
    dT_max=Q_flow_nominal/m1_flow_nominal/4180,
    dp_nominalCon=dp_nominalCon,
    dp_nominalEva=dp_nominalEva,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    mod_start=0,
    u_name=u_name,
    use_onIn=use_onIn) "chiller model" annotation (Placement(visible=true,
        transformation(
        origin={0,-48},
        extent={{10,-10},{-10,10}},
        rotation=-90)));
  Modelica.Blocks.Interfaces.RealOutput EER "Energy Efficiency Ratio" annotation (
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput TEvaIn "Evaporator inlet water temperature" annotation (
    Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput Tair "Prescribed boundary temperature"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,30})));

equation
  connect(bou.ports[1], fan.port_a) annotation (Line(points={{-82,2},{-68,2},{-68,
          -20},{-54,-20}}, color={0,127,255}));
  connect(fan.m_flow_in, realExpression.y) annotation (
    Line(points={{-44,-8},{-44,24},{-62,24},{-62,60},{-67,60}},
                                                     color = {0, 0, 127}));
  connect(Chi.on, on_in) annotation (Line(points={{11,-56},{-60,-56},{-60,120}},
        color={255,0,255}));
  connect(bou.T_in, Tair) annotation (Line(points={{-104,4},{-110,4},{-110,18},{
          -100,18},{-100,30}},  color={0,0,127}));
  connect(port_a, Chi.port_a1) annotation (Line(points={{100,-60},{54,-60},{54,-58},
          {6,-58}}, color={0,127,255}));
  connect(Chi.port_b1, port_b) annotation (Line(points={{6,-38},{50,-38},{50,60},
          {100,60}}, color={0,127,255}));
  connect(Chi.port_a2, fan.port_b)
    annotation (Line(points={{-6,-38},{-6,-20},{-34,-20}}, color={0,127,255}));
  connect(Chi.port_b2, bou.ports[2]) annotation (Line(points={{-6,-58},{-6,-76},
          {-74,-76},{-74,-2},{-82,-2}}, color={0,127,255}));
  connect(Chi.TEva, TEvaOut) annotation (Line(points={{-2,-37},{-2,88},{20,88},
          {20,110}}, color={0,0,127}));
  connect(Chi.PEl, PEl)
    annotation (Line(points={{0,-37},{0,110}}, color={0,0,127}));
  connect(Chi.EER, EER) annotation (Line(points={{-4,-37},{-4,86},{-40,86},{-40,
          110}}, color={0,0,127}));
  connect(Chi.QEva, QEva) annotation (Line(points={{2.9,-37},{2.9,94},{-20,94},
          {-20,110}}, color={0,0,127}));
  connect(Chi.OutputTEvaIn, TEvaIn) annotation (Line(points={{9,-37},{9,84},{40,
          84},{40,110}}, color={0,0,127}));
  annotation (defaultComponentName="chi",
    Icon(coordinateSystem(preserveAspectRatio = false), graphics={  Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                  FillPattern.Solid, extent = {{-70, 80}, {70, -80}}), Line(rotation = 180, points = {{-20, 0}, {40, 2.44929e-15}}, color = {255, 0, 0}, thickness = 0.5,
          origin={-2,0}),                                                                                                                                                                                                        Line(origin={
              -37,-2},                                                                                                                                                                                                        rotation = 360, points={{
              14,21},{-6,1},{14,-23}},                                                                                                                                                                                                        color = {255, 0, 0}, thickness = 0.5), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{38, -56}, {102, -66}}), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{38, 64}, {102, 54}}),
      Text(
          extent={{-150,-100},{150,-140}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Chiller_AirWater;
