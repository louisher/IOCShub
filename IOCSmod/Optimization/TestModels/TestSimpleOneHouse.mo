within IOCSmod.Optimization.TestModels;
model TestSimpleOneHouse
  extends IOCSmod.Optimization.Interface;
                                                                     output Real QPvtHex = enerHub.pvt.hex.Q2_flow;

  Blocks.EnergyHub.GeneralHub enerHub(
    addDummyEquation=addDummyEquation,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBor_flow_nominal=enerHub.GsHp.borFieDat.conDat.mBorFie_flow_nominal/
            enerHub.GsHp.borFieDat.conDat.nBor,
        dp_nominal(displayUnit="Pa"))),
    isRev_ashp=true)
    annotation (Placement(transformation(extent={{-20,0},{-40,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={14,6})));

  IDEAS.Buildings.Components.RectangularZoneTemplate zone(
    redeclare package Medium = IDEAS.Media.Specialized.DryAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure
      interzonalAirFlow,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    hasWinA=true,
    hasWinD=true,
    l=10,
    w=10,
    h=3.5,
    A_winA=10,
    A_winD=10,
    redeclare IDEAS.Buildings.Data.Constructions.FloorOnGround conTypFlo,
    hasEmb=true)
    annotation (Placement(transformation(extent={{180,-60},{160,-40}})));
  UnitTests.Confidential.FlowControlled_dp
                                       pump(
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    dp_nominal=20000,
    addDummyEquation=addDummyEquation,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    m_flow_nominal=embeddedPipe.m_flow_nominal,
    redeclare package Medium = IDEAS.Media.Water,
    redeclare UnitTests.Components.BaseClasses.SimplifiedFlowMachineInterface
      eff,
    redeclare IDEAS.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per,
    addPowerToMedium=false,
    dp_min(displayUnit="Pa") = 10,
    dp_max(displayUnit="Pa") = 2e4)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe(
    redeclare
      IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.FH_ValidationEmpa4_6
      RadSlaCha,
    dp_nominal=15000,
    m_flowMin=0.2,
    nParCir=1,
    A_floor=floor.A,
    nDiscr=1,
    m_flow_nominal=6000/4180/5,
    redeclare package Medium = IDEAS.Media.Water,
    computeFlowResistance=true,
    from_dp=true)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={130,-50})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTOut(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=embeddedPipe.m_flow_nominal,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-80})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTIn(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=embeddedPipe.m_flow_nominal,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={100,-20})));
  UnitTests.Confidential.ThreeWayLinear                      threeWayLinear(
    redeclare package Medium = IDEAS.Media.Water,
    addDummyEquation=addDummyEquation,
    deltaM=0.1,
    dpValve_nominal=5000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    fraK=1,
    from_dp=true,
    m_flow_nominal=embeddedPipe.m_flow_nominal,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    y_max=1,
    y_min=0.1)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTSup(
    m_flow_nominal=embeddedPipe.m_flow_nominal,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,-20})));
  IDEAS.Fluid.FixedResistances.Junction jun(
    m_flow_nominal=embeddedPipe.m_flow_nominal,
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    redeclare package Medium = IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{40,-70},{20,-90}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTRet(
    m_flow_nominal=embeddedPipe.m_flow_nominal,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-80})));
equation
  connect(senTSup.port_b, threeWayLinear.port_1)
    annotation (Line(points={{10,-20},{20,-20}},
                                               color={0,127,255}));
  connect(embeddedPipe.port_a, senTIn.port_b)
    annotation (Line(points={{130,-40},{130,-20},{110,-20}},
                                                         color={0,127,255}));
  connect(senTIn.port_a, pump.port_b)
    annotation (Line(points={{90,-20},{80,-20}}, color={0,127,255}));
  connect(pump.port_a, threeWayLinear.port_2)
    annotation (Line(points={{60,-20},{40,-20}},
                                               color={0,127,255}));
  connect(embeddedPipe.port_b, senTOut.port_a) annotation (Line(points={{130,-60},
          {130,-80},{110,-80}}, color={0,127,255}));
  connect(senTOut.port_b, jun.port_1)
    annotation (Line(points={{90,-80},{40,-80}},  color={0,127,255}));
  connect(jun.port_3, threeWayLinear.port_3)
    annotation (Line(points={{30,-70},{30,-30}},color={0,127,255}));
  connect(embeddedPipe.heatPortEmb, zone.gainEmb) annotation (Line(points={{140,-50},
          {146,-50},{146,-59},{160,-59}},      color={191,0,0}));
  connect(enerHub.port_b, senTSup.port_a)
    annotation (Line(points={{-24,0},{-24,-20},{-10,-20}}, color={0,127,255}));
  connect(bou.ports[1], senTSup.port_b) annotation (Line(points={{14,-4},{14,
          -20},{10,-20}},         color={0,127,255}));
  connect(jun.port_2, senTRet.port_a)
    annotation (Line(points={{20,-80},{10,-80}}, color={0,127,255}));
  connect(senTRet.port_b, enerHub.port_a)
    annotation (Line(points={{-10,-80},{-36,-80},{-36,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestSimpleOneHouse;
