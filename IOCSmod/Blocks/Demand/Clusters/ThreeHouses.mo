within IOCSmod.Blocks.Demand.Clusters;
model ThreeHouses
  extends IOCSmod.Blocks.Demand.Clusters.BaseClasses.ThreeHousesBase(
  redeclare IOCSmod.Demand.BuildingModels.TwoZone House1,
  redeclare IOCSmod.Demand.BuildingModels.TwoZone House2,
  redeclare IOCSmod.Demand.BuildingModels.TwoZone House3);

  IDEAS.Fluid.FixedResistances.Junction junSup1(
    m_flow_nominal={House1.subStation.m1_flow_nominal + House2.subStation.m1_flow_nominal
         + House3.subStation.m1_flow_nominal,House2.subStation.m1_flow_nominal +
        House3.subStation.m1_flow_nominal,House1.subStation.m1_flow_nominal},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-60,-10})));
  IDEAS.Fluid.FixedResistances.Junction junSup2(
    m_flow_nominal={House2.subStation.m1_flow_nominal + House3.subStation.m1_flow_nominal,
        House3.subStation.m1_flow_nominal,House2.subStation.m1_flow_nominal},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-10,-10})));
  IDEAS.Fluid.FixedResistances.Junction junRet2(
    m_flow_nominal={House3.subStation.m1_flow_nominal,House2.subStation.m1_flow_nominal
         + House3.subStation.m1_flow_nominal,House2.subStation.m1_flow_nominal},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={10,-30})));

  IDEAS.Fluid.FixedResistances.Junction junRet1(
    m_flow_nominal={House2.subStation.m1_flow_nominal + House3.subStation.m1_flow_nominal,
        House1.subStation.m1_flow_nominal + House2.subStation.m1_flow_nominal +
        House3.subStation.m1_flow_nominal,House1.subStation.m1_flow_nominal},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-40,-30})));
  Modelica.Blocks.Math.Sum Pnet(nin=3)    annotation (
    Placement(visible = true, transformation(origin={-80,90},     extent={{10,-10},
            {-10,10}},                                                                             rotation=0)));
  UnitTests.Confidential.TwoWayLinear val1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=House1.subStation.m1_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=2,
    addDummyEquation=addDummyEquation,
    dT_nom_water=5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,20})));
  UnitTests.Confidential.TwoWayLinear val2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=House2.subStation.m1_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=2,
    addDummyEquation=addDummyEquation,
    dT_nom_water=5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,20})));
  UnitTests.Confidential.TwoWayLinear val3(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=House3.subStation.m1_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=2,
    addDummyEquation=addDummyEquation,
    dT_nom_water=5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,20})));
  IDEAS.Fluid.Movers.FlowControlled_dp pumNetwork(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=House1.subStation.m1_flow_nominal + House2.subStation.m1_flow_nominal
         + House3.subStation.m1_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    use_inputFilter=false,
    dp_nominal=20000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,-80})));
equation
  connect(House1.port_b, junRet1.port_3) annotation (Line(points={{-48,40},{-48,
          36},{-40,36},{-40,-20}}, color={0,127,255}));
  connect(junSup1.port_2, junSup2.port_1)
    annotation (Line(points={{-50,-10},{-20,-10}}, color={0,127,255}));
  connect(House2.port_b, junRet2.port_3) annotation (Line(points={{2,40},{2,36},
          {10,36},{10,-20}}, color={0,127,255}));
  connect(House3.port_b, junRet2.port_1) annotation (Line(points={{52,40},{52,
          34},{66,34},{66,-30},{20,-30}},
                                      color={0,127,255}));
  connect(junRet2.port_2, junRet1.port_1)
    annotation (Line(points={{0,-30},{-30,-30}}, color={0,127,255}));
  connect(junRet1.port_2, port_b) annotation (Line(points={{-50,-30},{-60,-30},{
          -60,-100}}, color={0,127,255}));
  connect(Pnet.y, P)
    annotation (Line(points={{-91,90},{-110,90}}, color={0,0,127}));
  connect(House1.P, Pnet.u[1]) annotation (Line(points={{-39,44.6},{-30,44.6},{
          -30,88.6667},{-68,88.6667}},
                                   color={0,0,127}));
  connect(House2.P, Pnet.u[2]) annotation (Line(points={{11,44.6},{20,44.6},{20,
          90},{-68,90}}, color={0,0,127}));
  connect(House3.P, Pnet.u[3]) annotation (Line(points={{61,44.6},{70,44.6},{70,
          68},{20,68},{20,91.3333},{-68,91.3333}}, color={0,0,127}));
  connect(val1.port_a, junSup1.port_3)
    annotation (Line(points={{-60,10},{-60,0}}, color={0,127,255}));
  connect(val1.port_b, House1.port_a) annotation (Line(points={{-60,30},{-60,36},
          {-52,36},{-52,40}}, color={0,127,255}));
  connect(val2.port_a, junSup2.port_3)
    annotation (Line(points={{-10,10},{-10,0}}, color={0,127,255}));
  connect(val2.port_b, House2.port_a) annotation (Line(points={{-10,30},{-10,34},
          {-2,34},{-2,40}}, color={0,127,255}));
  connect(val3.port_b, House3.port_a) annotation (Line(points={{40,30},{40,36},
          {48,36},{48,40}},color={0,127,255}));
  connect(val3.port_a, junSup2.port_2)
    annotation (Line(points={{40,10},{40,-10},{0,-10}}, color={0,127,255}));
  connect(port_a, pumNetwork.port_a)
    annotation (Line(points={{60,-100},{60,-80},{20,-80}}, color={0,127,255}));
  connect(pumNetwork.port_b, junSup1.port_1) annotation (Line(points={{0,-80},{-80,
          -80},{-80,-10},{-70,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThreeHouses;
