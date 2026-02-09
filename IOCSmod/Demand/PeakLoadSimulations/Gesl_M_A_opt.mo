within IOCSmod.Demand.PeakLoadSimulations;
model Gesl_M_A_opt
  replaceable package MediumAir = IDEAS.Media.Specialized.DryAir "Medium in the component";
  parameter Real [nZones] n= (3.6/nZones).*bui.AZones./bui.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*bui.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = bui.nZones
    "Number of conditioned thermal building zones";

 inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Gesl_M.Gesl_M_Structure_A bui(useFluPor=
       true, redeclare package Medium = MediumAir)
        annotation (Placement(transformation(extent={{-6,-14},{24,6}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=0)
    annotation(Placement(transformation(extent={{60, 30}, {40, 50}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=0)
    annotation(Placement(transformation(extent={{60, 10}, {40, 30}})));
    parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";


    //Thermal Comfort
  parameter Modelica.Units.SI.Temperature TSetOffHea = 273.15 + 21 "setpoint temperature office for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetOffCoo = 273.15 + 23 "setpoint temperature nightzone for cooling if people are present";

  parameter Modelica.Units.SI.Temperature TSetDayHea = 273.15 + 21 "setpoint temperature dayzone for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetNigHea = 273.15 + 18 "setpoint temperature nightzone for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetDayCoo = 273.15 + 24 "setpoint temperature dayzone for cooling if people are present";
  parameter Modelica.Units.SI.Temperature TSetNigCoo = 273.15 + 26 "setpoint temperature nightzone for cooling if people are present";
  parameter Modelica.Units.SI.Temperature TSetDefHea = 273.15 + 15 "setpoint temperature for heating if no people present";
  parameter Modelica.Units.SI.Temperature TSetDefCoo = 273.15 + 27 "setpoint temperature for cooling if no people present";
  parameter Modelica.Units.SI.Temperature TTanMax = 273.15 + 16 "maximum allowable tank temperature";
  parameter Modelica.Units.SI.Temperature TTanMin = 273.15 + 5 "minimum allowable tank temperature";

  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness
    hex(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=m_flow_nominal_air,
    m2_flow_nominal=m_flow_nominal_air,
    eps=0.84,
    dp1_nominal=65,
    dp2_nominal=225) "Heat recovery unit"
    annotation (Placement(transformation(extent={{-48,36},{-68,56}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanSup[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=100)                                       "Supply fan"
    annotation (Placement(transformation(extent={{-28,24},{-8,44}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanRet[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=80)                                        "Return fan"
    annotation (Placement(transformation(extent={{-8,50},{-28,70}})));
  IDEAS.Fluid.Sources.Boundary_pT bouAir(
    use_T_in=true,
    redeclare package Medium = MediumAir,
    nPorts=2)
    "Boundary for air model"
    annotation (Placement(transformation(extent={{-92,40},{-80,52}})));
  Modelica.Blocks.Sources.RealExpression Te(y=sim.Te) "Ambient air"
    annotation (Placement(transformation(extent={{-112,40},{-100,54}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealH1
    annotation (Placement(transformation(extent={{52,-18},{32,2}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealH2
    annotation (Placement(transformation(extent={{52,-50},{32,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC1
    annotation (Placement(transformation(extent={{52,-34},{32,-14}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC2
    annotation (Placement(transformation(extent={{52,-70},{32,-50}})));
  Modelica.Blocks.Sources.CombiTimeTable officeHours(
    fileName=Modelica.Utilities.Files.loadResource("modelica://DistrictHeating_5GDHC/Resources/OccupancyProfiles/office_hours_hourly.txt"),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{102,82},{116,96}})));

  Modelica.Blocks.Sources.RealExpression offPres(y=officeHours.y[1])
    annotation (Placement(transformation(extent={{102,60},{122,80}})));
  Modelica.Blocks.Sources.RealExpression resPres(y=1 - offPres.y)
    annotation (Placement(transformation(extent={{102,46},{122,66}})));
  Modelica.Blocks.Sources.RealExpression TSetOffHeaExpr(y=offPres.y*TSetOffHea +
        (1 - offPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{102,32},{122,52}})));
  Modelica.Blocks.Sources.RealExpression TSetOffCooExpr(y=offPres.y*TSetOffCoo +
        (1 - offPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{102,18},{122,38}})));
  Modelica.Blocks.Sources.RealExpression TSetNigCooExpr(y=resPres.y*TSetNigCoo +
        (1 - resPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{102,-38},{122,-18}})));
  Modelica.Blocks.Sources.RealExpression TSetNigHeaExpr(y=resPres.y*TSetNigHea +
        (1 - resPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{102,-24},{122,-4}})));
  Modelica.Blocks.Sources.RealExpression TSetDayHeaExpr(y=resPres.y*TSetDayHea +
        (1 - resPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{102,4},{122,24}})));
  Modelica.Blocks.Sources.RealExpression TSetDayCooExpr(y=resPres.y*TSetDayCoo +
        (1 - resPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{102,-10},{122,10}})));
equation
  connect(occ1.y, bui.occ[1]) annotation(Line(points={{39,40},{19,40},{19,6}},       color={0, 0, 127}));
  connect(occ2.y, bui.occ[2]) annotation(Line(points={{39,20},{19,20},{19,6}},       color={0, 0, 127}));
  connect(Te.y,bouAir. T_in) annotation (Line(points={{-99.4,47},{-99.4,48.4},{-93.2,
          48.4}},         color={0,0,127}));
  for i in 1:nZones loop
    connect(hex.port_b2,fanSup [i].port_a) annotation (Line(points={{-48,40},{-40,
          40},{-40,34},{-28,34}}, color={0,127,255}));
  end for;
  for i in 1:nZones loop
    connect(hex.port_a1,fanRet [i].port_b) annotation (Line(points={{-48,52},{-40,
          52},{-40,60},{-28,60}}, color={0,127,255}));
  end for;
  connect(hex.port_b1,bouAir. ports[1]) annotation (Line(points={{-68,52},{-80,52},
          {-80,47.2}},      color={0,127,255}));
  connect(hex.port_a2,bouAir. ports[2]) annotation (Line(points={{-68,40},{-80,40},
          {-80,44.8}},      color={0,127,255}));
  connect(fanSup.port_b, bui.port_a) annotation (Line(points={{-8,34},{11,34},{11,
          6}},                                                                         color={0,127,255}));
  connect(fanRet.port_a, bui.port_b) annotation (Line(points={{-8,60},{7,60},{7,
          6}},                                                                           color={0,127,255}));
  connect(idealH1.port, bui.heatPortEmb[1])
    annotation (Line(points={{32,-8},{26,-8},{26,2},{24,2}}, color={191,0,0}));
  connect(idealH2.port, bui.heatPortEmb[2]) annotation (Line(points={{32,-40},{26,
          -40},{26,2},{24,2}}, color={191,0,0}));
  connect(idealC1.port, bui.heatPortEmb[1]) annotation (Line(points={{32,-24},{26,
          -24},{26,2},{24,2}}, color={191,0,0}));
  connect(idealC2.port, bui.heatPortEmb[2]) annotation (Line(points={{32,-60},{26,
          -60},{26,2},{24,2}}, color={191,0,0}));
annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {100,100}}),                                     graphics={
  Line(points={{-70, 4}, {-70, -86}, {-16, -86}, {-16, -30}, {16, -30}, {16, -86}, {70, -86}, {70, 4}, {0, 74}, {-70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-70, 4}, {-76, -2}, {-88, -2}, {0, 86}, {88, -2}, {76, -2}, {70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-14, 28}, {14, 28}, {14, 0}, {-14, 0}, {-14, 28}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{30, -30}, {58, -30}, {58, -58}, {30, -58}, {30, -30}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-58, -30}, {-30, -30}, {-30, -58}, {-58, -58}, {-58, -30}}, color={244, 125, 35}, thickness=0.5),
        Text(
          extent={{-180,140},{180,100}},
          textColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}})),
  experiment(
      StopTime=30240000,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
  Documentation(info="",
                   revisions="<html><ul><li>March 5, 2024, by Lucas Verleyen:<br> Remove mass flow sources and set useFluPor = false.<li>October 9, 2023, by Lucas Verleyen:<br> Initial implementation.</li></ul></html>"));
end Gesl_M_A_opt;
