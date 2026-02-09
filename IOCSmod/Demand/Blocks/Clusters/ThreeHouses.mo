within IOCSmod.Demand.Blocks.Clusters;
model ThreeHouses
  extends IOCSmod.Demand.Blocks.BaseClasses.DemandInterface;
  BuildingModels.TwoZone                                             House1(
    loadFile=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/FTE_FTE.txt"),
    Q_flow_nominal=17000,
    n1=9,
    azi1=1.5707963267949,
    til1=0.75049157835756,
    n2=0,
    azi2=4.7123889803847,
    til2=0.75049157835756)
           annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  BuildingModels.TwoZone                                             House2(
    loadFile=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School.txt"),
    Q_flow_nominal=24000,
    n1=14,
    azi1=0,
    til1=0.5235987755983,
    n2=0,
    azi2=3.1415926535898,
    til2=0.5235987755983,
    redeclare IOCSmod.Demand.BuildingEnvelopes.Priemstraat_9.Priemstraat_9_1595127_Structure
      bui) annotation (Placement(transformation(extent={{-10,40},{10,60}})));

  BuildingModels.TwoZone                                             House3(
    loadFile=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School_School.txt"),
    Q_flow_nominal=24000,
    n1=14,
    azi1=0,
    til1=0.62831853071796,
    n2=0,
    azi2=3.1415926535898,
    til2=0.62831853071796,
    redeclare IOCSmod.Demand.BuildingEnvelopes.Asbergstraat_18.Asbergstraat_18_1574473_Structure
      bui) annotation (Placement(transformation(extent={{40,40},{60,60}})));

  IDEAS.Fluid.FixedResistances.Junction junSup1(
    m_flow_nominal={House1.subStation.m1_flow_nominal + House2.subStation.m1_flow_nominal
         + House3.subStation.m1_flow_nominal,House2.subStation.m1_flow_nominal
         + House3.subStation.m1_flow_nominal,House1.subStation.m1_flow_nominal},

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
        House1.subStation.m1_flow_nominal + House2.subStation.m1_flow_nominal
         + House3.subStation.m1_flow_nominal,House1.subStation.m1_flow_nominal},

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
equation
  connect(junSup1.port_3, House1.port_a) annotation (Line(points={{-60,0},{-60,
          20},{-52,20},{-52,40}}, color={0,127,255}));
  connect(House1.port_b, junRet1.port_3) annotation (Line(points={{-48,40},{-48,
          20},{-40,20},{-40,-20}}, color={0,127,255}));
  connect(junSup1.port_2, junSup2.port_1)
    annotation (Line(points={{-50,-10},{-20,-10}}, color={0,127,255}));
  connect(junSup2.port_3, House2.port_a) annotation (Line(points={{-10,0},{-10,
          20},{-2,20},{-2,40}}, color={0,127,255}));
  connect(House2.port_b, junRet2.port_3) annotation (Line(points={{2,40},{2,20},
          {10,20},{10,-20}}, color={0,127,255}));
  connect(junSup2.port_2, House3.port_a)
    annotation (Line(points={{0,-10},{48,-10},{48,40}}, color={0,127,255}));
  connect(House3.port_b, junRet2.port_1)
    annotation (Line(points={{52,40},{52,-30},{20,-30}}, color={0,127,255}));
  connect(junRet2.port_2, junRet1.port_1)
    annotation (Line(points={{0,-30},{-30,-30}}, color={0,127,255}));
  connect(port_a, junSup1.port_1) annotation (Line(points={{60,-100},{60,-60},{
          -80,-60},{-80,-10},{-70,-10}}, color={0,127,255}));
  connect(junRet1.port_2, port_b) annotation (Line(points={{-50,-30},{-60,-30},
          {-60,-100}}, color={0,127,255}));
  connect(Pnet.y, P)
    annotation (Line(points={{-91,90},{-110,90}}, color={0,0,127}));
  connect(House1.P, Pnet.u[1]) annotation (Line(points={{-39,44.6},{-30,44.6},{
          -30,88.6667},{-68,88.6667}}, color={0,0,127}));
  connect(House2.P, Pnet.u[2]) annotation (Line(points={{11,44.6},{20,44.6},{20,
          90},{-68,90}}, color={0,0,127}));
  connect(House3.P, Pnet.u[3]) annotation (Line(points={{61,44.6},{70,44.6},{70,
          68},{20,68},{20,91.3333},{-68,91.3333}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThreeHouses;
