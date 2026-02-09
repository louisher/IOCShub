within IOCSmod.Simulation;
model SimpleAhu "Generic AHU"
  replaceable package Medium = IDEAS.Media.Air;
  outer IDEAS.BoundaryConditions.SimInfoManager sim annotation (
    Placement(transformation(extent = {{-100, 80}, {-80, 100}})));


  parameter Boolean prescribeSystemPressure = true "= true, to prescribed duct pressure with respect to atmospheric pressure";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal "Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp1_nominal = 300 "Pressure difference";
  parameter Modelica.Units.SI.PressureDifference dp2_nominal = 300 "Pressure difference";
  parameter Modelica.Units.SI.ThermalConductance UA "UA value";
  parameter Modelica.Units.SI.PressureDifference dp_fanRet "Return fan pressure";
  parameter Modelica.Units.SI.PressureDifference dp_fanSup "Supply fan pressure";
  parameter Integer n_in(min = 0) "Number of inlet ports";
  parameter Integer n_out(min = 0) "Number of outlet ports";
  parameter Modelica.Units.SI.PressureDifference dp_min = 10 "Minimum fan head";
  parameter Modelica.Units.SI.PressureDifference dp_max = dp_fanSup "Maximum fan head";
  IDEAS.Fluid.FixedResistances.Junction spl(dp_nominal = {0, 0, 0}, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, portFlowDirection_1 = Modelica.Fluid.Types.PortFlowDirection.Entering, portFlowDirection_2 = Modelica.Fluid.Types.PortFlowDirection.Leaving, m_flow_nominal = {m2_flow_nominal, m2_flow_nominal, m2_flow_nominal}, redeclare
      package Medium =                                                                                                                                                                                                         Medium, portFlowDirection_3 = Modelica.Fluid.Types.PortFlowDirection.Leaving) annotation (
    Placement(transformation(extent = {{26, -54}, {14, -66}})));
  IDEAS.Fluid.Actuators.Valves.Simplified.ThreeWayValveMotor
                                            threeWayValveMotor(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, portFlowDirection_1 = Modelica.Fluid.Types.PortFlowDirection.Entering, portFlowDirection_2 = Modelica.Fluid.Types.PortFlowDirection.Leaving, portFlowDirection_3 = Modelica.Fluid.Types.PortFlowDirection.Entering, m_flow_nominal = m2_flow_nominal, redeclare
      package Medium =                                                                                                                                                                                                         Medium)                                      annotation (
    Placement(transformation(extent = {{10, 10}, {-10, -10}}, rotation = 0, origin = {0, -60})));
  UnitTests_Simulation.Components.CrossFlowHEX crossFlowHEX(redeclare package
      Medium2 =                                                                         Medium, redeclare
      package Medium1 =                                                                                          Medium, UA = UA, allowFlowReversal1 = false, allowFlowReversal2 = false, dp1_nominal = dp1_nominal, dp2_nominal = dp2_nominal, from_dp1 = false, from_dp2 = false, m1_flow_nominal = m1_flow_nominal, m2_flow_nominal = m2_flow_nominal) "Heat recovery wheel" annotation (
    Placement(transformation(extent = {{0, -10}, {20, 10}})));
  IDEAS.Fluid.Movers.FlowControlled_dp     fanRet(redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,                                                             allowFlowReversal = false,
    use_inputFilter=false,                                                                                                                                                             dp_nominal = dp_fanRet,
    inputType=IDEAS.Fluid.Types.InputType.Constant,                                                                                                                                                                                                        m_flow_nominal = m1_flow_nominal, prescribeSystemPressure = prescribeSystemPressure)                        annotation (
    Placement(visible = true, transformation(extent = {{40, 50}, {60, 70}}, rotation = 0)));
  IDEAS.Fluid.Movers.FlowControlled_dp     fanSup(redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,                                                             allowFlowReversal = false,
    use_inputFilter=false,                                                                                                                                                             dp_nominal = dp_fanSup,
    inputType=IDEAS.Fluid.Types.InputType.Constant,                                                                                                                                                                                                        m_flow_nominal = m2_flow_nominal, prescribeSystemPressure = prescribeSystemPressure)                        annotation (
    Placement(transformation(extent = {{-16, -70}, {-36, -50}})));
  IDEAS.Fluid.Sensors.RelativePressure senRelPreSup(redeclare package Medium = Medium) if prescribeSystemPressure "Differential pressure sensor for supply side" annotation (
    Placement(transformation(extent = {{-40, -30}, {-20, -10}})));
  IDEAS.Fluid.Sensors.RelativePressure senRelPreRet(redeclare package Medium = Medium) if prescribeSystemPressure "Differential pressure sensor for return side" annotation (
    Placement(visible = true, transformation(extent = {{0, 70}, {-20, 90}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPorts_a port_a[n_in](redeclare package Medium = Medium) "Air inlets" annotation (
    Placement(transformation(extent = {{-106, 40}, {-94, 80}})));
  Modelica.Fluid.Interfaces.FluidPorts_b port_b[n_out](redeclare package Medium = Medium) "Air outlets" annotation (
    Placement(transformation(extent = {{-106, -80}, {-94, -40}})));
  IDEAS.Fluid.Sources.OutsideAir outsideAir(redeclare package Medium = Medium, azi = 0, nPorts = 4, CpAct = 0) "Outside air" annotation (
    Placement(visible = true, transformation(extent = {{120, 10}, {100, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PSup "Electrical power of supply fan" annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {60, 110})));
  Modelica.Blocks.Interfaces.RealOutput PRet "Electrical power of return fan" annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {80, 110})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTemSup(redeclare package Medium = Medium, m_flow_nominal = m2_flow_nominal, tau = 0) annotation (
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{9, -8}, {-9, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput TSup "Supply air temperature" annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-40, 110})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTemRet(redeclare package Medium = Medium, m_flow_nominal = m1_flow_nominal, tau = 0) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-52, 60})));
  Modelica.Blocks.Interfaces.RealOutput TRet "Return air temperature" annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-60, 110})));
  Modelica.Blocks.Interfaces.RealOutput dpSup = fanSup.dpMea annotation (
    Placement(transformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), transformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput dpRet = fanRet.dpMea annotation (
    Placement(transformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), transformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  connect(threeWayValveMotor.port_1, spl.port_2) annotation (
    Line(points = {{10, -60}, {14, -60}}, color = {0, 127, 255}));
  connect(crossFlowHEX.port_b2, threeWayValveMotor.port_3) annotation (
    Line(points = {{0, -6}, {0, -50}}, color = {0, 127, 255}));
  connect(spl.port_3, crossFlowHEX.port_a2) annotation (
    Line(points = {{20, -54}, {20, -6}}, color = {0, 127, 255}));
  connect(crossFlowHEX.port_b1, fanRet.port_a) annotation (
    Line(points = {{20, 6}, {20, 60}, {40, 60}}, color = {0, 127, 255}));
  connect(threeWayValveMotor.port_2, fanSup.port_a) annotation (
    Line(points = {{-10, -60}, {-16, -60}}, color = {0, 127, 255}));

  connect(fanRet.port_b, outsideAir.ports[1]) annotation (
    Line(points={{60,60},{80,60},{80,-3},{100,-3}},        color = {0, 127, 255}));
  connect(senRelPreRet.port_a, outsideAir.ports[2]) annotation (
    Line(points={{0,80},{100,80},{100,-1}},       color = {0, 127, 255}));
  connect(fanRet.P, PRet) annotation (
    Line(points = {{61, 69}, {80, 69}, {80, 110}}, color = {0, 0, 127}));
  connect(fanSup.P, PSup) annotation (
    Line(points = {{-37, -51}, {-54, -51}, {-54, -2}, {-20, -2}, {-20, 100}, {60, 100}, {60, 110}}, color = {0, 0, 127}));
  connect(senTemSup.T, TSup) annotation (
    Line(points={{-70,-51.2},{-70,20},{-40,20},{-40,110}},        color = {0, 0, 127}));
  connect(crossFlowHEX.port_a1, senTemRet.port_b) annotation (
    Line(points = {{0, 6}, {0, 60}, {-42, 60}}, color = {0, 127, 255}));
  connect(senTemRet.T, TRet) annotation (
    Line(points = {{-52, 71}, {-60, 71}, {-60, 110}}, color = {0, 0, 127}));
  connect(senTemSup.port_a, fanSup.port_b) annotation (
    Line(points={{-61,-60},{-36,-60}},      color = {0, 127, 255}));
  for i in 1:n_out loop
    connect(senTemSup.port_b, port_b[i]) annotation (
      Line(points={{-79,-60},{-100,-60}}));
  end for;
  connect(senRelPreSup.port_a, senTemSup.port_b) annotation (
    Line(points={{-40,-20},{-79,-20},{-79,-60}},        color = {0, 127, 255}));
  connect(senRelPreRet.port_b, senTemRet.port_a) annotation (
    Line(points = {{-20, 80}, {-62, 80}, {-62, 60}}, color = {0, 127, 255}));
  for i in 1:n_in loop
    connect(senTemRet.port_a, port_a[i]) annotation (
      Line(points = {{-62, 60}, {-100, 60}}, color = {0, 127, 255}));
  end for;
  connect(senRelPreSup.port_b, outsideAir.ports[4]) annotation (
    Line(points={{-20,-20},{80,-20},{80,3},{100,3}},          color = {0, 127, 255}));
  connect(spl.port_1, outsideAir.ports[3]) annotation (
    Line(points={{26,-60},{100,-60},{100,1}},        color = {0, 127, 255}));
  connect(senRelPreSup.p_rel, fanSup.dpMea) annotation (Line(points={{-30,-29},{
          -30,-40},{-18,-40},{-18,-48}}, color={0,0,127}));
  connect(senRelPreRet.p_rel, fanRet.dpMea)
    annotation (Line(points={{-10,71},{-10,72},{42,72}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                 FillPattern.Solid), Polygon(points = {{0, 58}, {-40, 18}, {0, -22}, {40, 18}, {0, 58}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid), Line(points = {{-100, 60}, {-26, 60}, {0, 34}, {26, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{100, -62}, {26, -62}, {26, -26}, {0, 0}, {-28, -28}, {-28, -62}, {-100, -62}}, color = {0, 0, 0}, smooth = Smooth.None), Rectangle(extent = {{-76, -36}, {-50, -86}}, lineColor = {0, 128, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid), Rectangle(extent = {{52, -34}, {78, -84}}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid), Text(extent = {{58, -50}, {70, -72}}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, textString = "+"), Text(extent = {{-76, -48}, {-50, -70}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, textString = "-"), Text(extent = {{-74, -82}, {-48, -104}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, textString = "-"), Text(extent = {{54, -82}, {66, -104}}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, textString = "+")}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{0, 58}, {-40, 18}, {0, -22}, {40, 18}, {0, 58}}), Line(points = {{-100, 60}, {-26, 60}, {0, 34}, {26, 60}, {98, 60}}), Line(points = {{100, -62}, {26, -62}, {26, -26}, {0, 0}, {-28, -28}, {-28, -62}, {-100, -62}}), Rectangle(lineColor = {0, 128, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-76, -36}, {-50, -86}}), Rectangle(lineColor = {255, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{52, -34}, {78, -84}}), Text(textColor = {255, 0, 0}, extent = {{58, -50}, {70, -72}}, textString = "+"), Text(textColor = {0, 0, 255}, extent = {{-76, -48}, {-50, -70}}, textString = "-"), Text(textColor = {0, 0, 255}, extent = {{-74, -82}, {-48, -104}}, textString = "-"), Text(textColor = {255, 0, 0}, extent = {{54, -82}, {66, -104}}, textString = "+")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation);
end SimpleAhu;
