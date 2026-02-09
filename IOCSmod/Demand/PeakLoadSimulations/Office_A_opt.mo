within IOCSmod.Demand.PeakLoadSimulations;
model Office_A_opt
  Modelica.Blocks.Sources.RealExpression nOccOff(y=10*offPres.y)
    "min 10 m2/officer (100m2/zone)"                             annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,22})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QflowComNor
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={4,-24})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QflowComSou
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={4,-40})));
  Modelica.Blocks.Sources.RealExpression QCom(y=55*nOccOff.y)     annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-32,-32})));
  Modelica.Blocks.Sources.RealExpression offPres(y=officeHours.y[1])
    annotation (Placement(transformation(extent={{80,64},{98,80}})));
  Modelica.Blocks.Sources.CombiTimeTable officeHours(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://DistrictHeating_5GDHC/Resources/OccupancyProfiles/office_hours_hourly.txt"),
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{82,80},{96,94}})));
  DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Office.Office_Structure_A office(redeclare
      replaceable package                                                                                            Medium=MediumAir, useFluPor=
       true)
    annotation (Placement(transformation(extent={{-16,-10},{14,10}})));

   inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  replaceable package MediumAir = IDEAS.Media.Specialized.DryAir "Medium in the component";
  parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";
  parameter Real [nZones] n= (3.6/nZones).*office.AZones./office.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*office.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = office.nZones
    "Number of conditioned thermal building zones";

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
    annotation (Placement(transformation(extent={{-50,36},{-70,56}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanSup[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=100)                                       "Supply fan"
    annotation (Placement(transformation(extent={{-30,24},{-10,44}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanRet[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=80)                                        "Return fan"
    annotation (Placement(transformation(extent={{-10,50},{-30,70}})));
  IDEAS.Fluid.Sources.Boundary_pT bouAir(
    use_T_in=true,
    redeclare package Medium = MediumAir,
    nPorts=2)                             "Boundary for air model"
    annotation (Placement(transformation(extent={{-94,40},{-82,52}})));
  Modelica.Blocks.Sources.RealExpression Te(y=sim.Te) "Ambient air"
    annotation (Placement(transformation(extent={{-114,40},{-102,54}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealH1
    annotation (Placement(transformation(extent={{56,-10},{36,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealH2
    annotation (Placement(transformation(extent={{56,-42},{36,-22}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC1
    annotation (Placement(transformation(extent={{56,-26},{36,-6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC2
    annotation (Placement(transformation(extent={{56,-62},{36,-42}})));
  Modelica.Blocks.Sources.RealExpression resPres(y=1 - offPres.y)
    annotation (Placement(transformation(extent={{80,46},{100,66}})));
  Modelica.Blocks.Sources.RealExpression TSetOffHeaExpr(y=offPres.y*TSetOffHea +
        (1 - offPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{80,32},{100,52}})));
  Modelica.Blocks.Sources.RealExpression TSetOffCooExpr(y=offPres.y*TSetOffCoo +
        (1 - offPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{80,18},{100,38}})));
  Modelica.Blocks.Sources.RealExpression TSetNigCooExpr(y=resPres.y*TSetNigCoo +
        (1 - resPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{80,-38},{100,-18}})));
  Modelica.Blocks.Sources.RealExpression TSetNigHeaExpr(y=resPres.y*TSetNigHea +
        (1 - resPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{80,-24},{100,-4}})));
  Modelica.Blocks.Sources.RealExpression TSetDayHeaExpr(y=resPres.y*TSetDayHea +
        (1 - resPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{80,4},{100,24}})));
  Modelica.Blocks.Sources.RealExpression TSetDayCooExpr(y=resPres.y*TSetDayCoo +
        (1 - resPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
    connect(QCom.y,QflowComNor. Q_flow) annotation (Line(points={{-21,-32},{-14,
          -32},{-14,-24},{-6,-24}},
                             color={0,0,127}));
  connect(QCom.y,QflowComSou. Q_flow) annotation (Line(points={{-21,-32},{-14,
          -32},{-14,-40},{-6,-40}},
                               color={0,0,127}));
  connect(nOccOff.y, office.occ[1])
    annotation (Line(points={{19,22},{5,22},{5,10}},color={0,0,127}));
  connect(nOccOff.y, office.occ[2])
    annotation (Line(points={{19,22},{5,22},{5,10}},color={0,0,127}));
  connect(office.heatPortCon[1], QflowComNor.port) annotation (Line(points={{14,
          2},{20,2},{20,-24},{14,-24}}, color={191,0,0}));
  connect(office.heatPortCon[2], QflowComSou.port) annotation (Line(points={{14,
          2},{20,2},{20,-40},{14,-40}}, color={191,0,0}));
  // connection ventilation model
  connect(Te.y,bouAir. T_in) annotation (Line(points={{-101.4,47},{-101.4,48.4},
          {-95.2,48.4}},  color={0,0,127}));
  for i in 1:nZones loop
    connect(hex.port_b2,fanSup [i].port_a) annotation (Line(points={{-50,40},{-42,
          40},{-42,34},{-30,34}}, color={0,127,255}));
  end for;
  for i in 1:nZones loop
    connect(hex.port_a1,fanRet [i].port_b) annotation (Line(points={{-50,52},{-42,
          52},{-42,60},{-30,60}}, color={0,127,255}));
  end for;
  connect(hex.port_b1,bouAir. ports[1]) annotation (Line(points={{-70,52},{-82,52},
          {-82,47.2}},      color={0,127,255}));
  connect(hex.port_a2,bouAir. ports[2]) annotation (Line(points={{-70,40},{-82,40},
          {-82,44.8}},      color={0,127,255}));
  connect(office.port_a, fanSup.port_b) annotation (Line(points={{1,10},{2,10},{
          2,34},{-10,34}}, color={0,127,255}));
  connect(office.port_b, fanRet.port_a) annotation (Line(points={{-3,10},{-2,10},
          {-2,60},{-10,60}}, color={0,127,255}));
  connect(idealH1.port, office.heatPortEmb[1])
    annotation (Line(points={{36,0},{26,0},{26,6},{14,6}}, color={191,0,0}));
  connect(idealC1.port, office.heatPortEmb[1]) annotation (Line(points={{36,-16},
          {26,-16},{26,6},{14,6}}, color={191,0,0}));
  connect(idealH2.port, office.heatPortEmb[2]) annotation (Line(points={{36,-32},
          {26,-32},{26,6},{14,6}}, color={191,0,0}));
  connect(idealC2.port, office.heatPortEmb[2]) annotation (Line(points={{36,-52},
          {26,-52},{26,6},{14,6}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-120,-100},{100,100}})),
    experiment(
      StopTime=31536000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end Office_A_opt;
