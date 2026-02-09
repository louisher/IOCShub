within IOCSmod.Optimization;
model TestBor
  extends IOCSmod.Optimization.Interface;
  Blocks.Demand.SingleBuildings.OneHouse buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));


  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));


  UnitTests.Confidential.HeatPump_WaterWater hp(redeclare package Medium1 =
        IDEAS.Media.Water, redeclare package Medium2 = IDEAS.Media.Water,
    m1_flow_nominal=0.8,
    m2_flow_nominal=10000/4180/5,
    dp_nominalCon=10000)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-72,-32})));
  ComponentModels.Thermal.SimpleTank tan(
    addDummyEquation=false,
    m_flow_nominal=10,
    nPorts=5) annotation (Placement(transformation(extent={{-16,-24},{4,-4}})));
  UnitTests.Confidential.FlowControlled_m_flow pumCon(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hp.m2_flow_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    dp_nominal=hp.dp_nominalCon)
    annotation (Placement(transformation(extent={{-24,-26},{-44,-6}})));
  UnitTests.Confidential.FlowControlled_m_flow pumEva(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hp.m1_flow_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    dp_nominal=hp.dp_nominalEva)
    annotation (Placement(transformation(extent={{-100,-18},{-120,2}})));
  ComponentModels.Thermal.SizeOpt.Borefields.OneUTube_ContOpt  borefield(
      redeclare package Medium = IDEAS.Media.Water,
    tLoaAgg=3600,
    nSeg=1,
    borFieDat(
      filDat(
        kFil=2,
        cFil=840,
        dFil(displayUnit="kg/m3") = 1818),
      soiDat(
        kSoi=1.9,
        cSoi=900,
        dSoi=1400),
      conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        Rb(unit="(m.K)/W"),
        mBorFie_flow_nominal=0.8,
        dp_nominal(displayUnit="Pa") = 1,
        hBor=150,
        cooBor=[0,0; 0,3; 3,0; 3,3],
        mBor_flow_nominal=borefield.borFieDat.conDat.mBorFie_flow_nominal/
            borefield.borFieDat.conDat.nBor,
        nBor=4,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043))) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-130,-30})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=0.8,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-86,-8})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=0.8,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-92,-52})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-56,-16})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-54,-52})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-130,-70})));
equation
  connect(tan.ports[1], buildings.port_b) annotation (Line(points={{-9.2,-24},{-9.2,
          -30},{46,-30},{46,0},{44,0}}, color={0,127,255}));
  connect(tan.ports[2], buildings.port_a) annotation (Line(points={{-7.6,-24},{-8,
          -24},{-8,-42},{56,-42},{56,0}}, color={0,127,255}));
  connect(pumCon.port_a, tan.ports[3]) annotation (Line(points={{-24,-16},{-26,-16},
          {-26,-24},{-6,-24}}, color={0,127,255}));
  connect(pumEva.port_b, borefield.port_a) annotation (Line(points={{-120,-8},{
          -130,-8},{-130,-20}},
                           color={0,127,255}));
  connect(bou.ports[1], tan.ports[4]) annotation (Line(points={{8,8},{10,8},{10,
          -24},{-4.4,-24}}, color={0,127,255}));
  connect(borefield.port_b, senTGsHpEvaIn.port_a) annotation (Line(points={{-130,
          -40},{-130,-52},{-98,-52}}, color={0,127,255}));
  connect(senTGsHpEvaIn.port_b, hp.port_a1) annotation (Line(points={{-86,-52},{
          -78,-52},{-78,-42}}, color={0,127,255}));
  connect(hp.port_b1, senTGsHpEvaOut.port_a) annotation (Line(points={{-78,-22},
          {-80,-22},{-80,-16},{-72,-16},{-72,-8},{-80,-8}}, color={0,127,255}));
  connect(senTGsHpEvaOut.port_b, pumEva.port_a)
    annotation (Line(points={{-92,-8},{-100,-8}}, color={0,127,255}));
  connect(hp.port_b2, senTGsHpConOut.port_a) annotation (Line(points={{-66,-42},
          {-66,-50},{-60,-50},{-60,-52}}, color={0,127,255}));
  connect(senTGsHpConOut.port_b, tan.ports[5]) annotation (Line(points={{-48,-52},
          {-30,-52},{-30,-54},{-2.8,-54},{-2.8,-24}}, color={0,127,255}));
  connect(senTGsHpConIn.port_a, pumCon.port_b)
    annotation (Line(points={{-50,-16},{-44,-16}}, color={0,127,255}));
  connect(senTGsHpConIn.port_b, hp.port_a2) annotation (Line(points={{-62,-16},{
          -66,-16},{-66,-22}}, color={0,127,255}));
  connect(bou1.ports[1], hp.port_a1) annotation (Line(points={{-130,-80},{-132,
          -80},{-132,-88},{-78,-88},{-78,-42}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestBor;
