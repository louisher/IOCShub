within IOCSmod.Demand.PeakLoadSimulations;
model Office_A
  extends DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Office.Office_A( office(
  useFluPor=true, redeclare package Medium = MediumAir));
  replaceable package MediumAir = IDEAS.Media.Air "Medium in the component";
  parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";
  parameter Boolean isDh=true "=true, if the system is connected to a DH grid";
  parameter Real [nZones] n= (3.6/nZones).*office.AZones./office.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*office.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = office.nZones
    "Number of conditioned thermal building zones";
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
  IDEAS.Controls.Continuous.LimPID conPIDHea1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=40000,
    yMin=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={88,0})));
  Modelica.Blocks.Sources.RealExpression T1(y=office.TSensor[1] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={106,26})));
  Modelica.Blocks.Sources.RealExpression TSet(y=21) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={122,0})));
  IDEAS.Controls.Continuous.LimPID conPIDHea2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=40000,
    yMin=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-48})));
  Modelica.Blocks.Sources.RealExpression T2(y=office.TSensor[2] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={104,-22})));
  Modelica.Blocks.Sources.RealExpression TSet1(y=21) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,-48})));
  IDEAS.Controls.Continuous.LimPID conPIDCoo1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=0,
    yMin=-40000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={164,2})));
  Modelica.Blocks.Sources.RealExpression T3(y=office.TSensor[1] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={182,28})));
  Modelica.Blocks.Sources.RealExpression TSet2(y=23) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={198,2})));
  IDEAS.Controls.Continuous.LimPID conPIDCoo2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=0,
    yMin=-40000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={162,-46})));
  Modelica.Blocks.Sources.RealExpression T4(y=office.TSensor[2] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={180,-20})));
  Modelica.Blocks.Sources.RealExpression TSet3(y=23) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={196,-46})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC1
    annotation (Placement(transformation(extent={{56,-26},{36,-6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC2
    annotation (Placement(transformation(extent={{56,-62},{36,-42}})));
equation
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
  connect(idealH1.port, office.heatPortCon[1])
    annotation (Line(points={{36,0},{20,0},{20,2},{14,2}}, color={191,0,0}));
  connect(idealH2.port, office.heatPortCon[2]) annotation (Line(points={{36,-32},
          {20,-32},{20,2},{14,2}}, color={191,0,0}));
  connect(T1.y, conPIDHea1.u_m)
    annotation (Line(points={{95,26},{88,26},{88,12}}, color={0,0,127}));
  connect(TSet.y, conPIDHea1.u_s) annotation (Line(points={{111,1.38778e-15},{
          100,-1.9984e-15}}, color={0,0,127}));
  connect(conPIDHea1.y, idealH1.Q_flow)
    annotation (Line(points={{77,8.88178e-16},{56,0}}, color={0,0,127}));
  connect(T2.y, conPIDHea2.u_m)
    annotation (Line(points={{93,-22},{86,-22},{86,-36}}, color={0,0,127}));
  connect(TSet1.y, conPIDHea2.u_s)
    annotation (Line(points={{109,-48},{98,-48}}, color={0,0,127}));
  connect(conPIDHea2.y, idealH2.Q_flow) annotation (Line(points={{75,-48},{64,
          -48},{64,-32},{56,-32}}, color={0,0,127}));
  connect(T3.y, conPIDCoo1.u_m)
    annotation (Line(points={{171,28},{164,28},{164,14}}, color={0,0,127}));
  connect(TSet2.y, conPIDCoo1.u_s)
    annotation (Line(points={{187,2},{176,2}}, color={0,0,127}));
  connect(T4.y, conPIDCoo2.u_m)
    annotation (Line(points={{169,-20},{162,-20},{162,-34}}, color={0,0,127}));
  connect(TSet3.y, conPIDCoo2.u_s)
    annotation (Line(points={{185,-46},{174,-46}}, color={0,0,127}));
  connect(idealC1.port, office.heatPortCon[1]) annotation (Line(points={{36,-16},
          {28,-16},{28,2},{14,2}}, color={191,0,0}));
  connect(idealC2.port, office.heatPortCon[2]) annotation (Line(points={{36,-52},
          {28,-52},{28,2},{14,2}}, color={191,0,0}));
  connect(conPIDCoo2.y, idealC2.Q_flow) annotation (Line(points={{151,-46},{144,
          -46},{144,-68},{56,-68},{56,-52}}, color={0,0,127}));
  connect(conPIDCoo1.y, idealC1.Q_flow) annotation (Line(points={{153,2},{136,2},
          {136,-16},{56,-16}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-120,-100},{100,100}})),
    experiment(
      StopTime=31536000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end Office_A;
