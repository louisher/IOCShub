within IOCSmod.ComponentModels.Borefields.Examples;
model Loadprofile

  parameter Modelica.Units.SI.MassFlowRate m_flow_bor_nominal=0.9
    "Nominal mass flow borefield";

  IDEAS.Fluid.Movers.FlowControlled_m_flow pumpBor(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borefield.borFieDat.conDat.mBorFie_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    riseTime=60,
    nominalValuesDefineDefaultPressureCurve=true,
    tau=60,
    use_inputFilter=false,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-50,56})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort THpEvaIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{26,34},{14,46}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THpEvaOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-14,34},{-26,46}})));
  Buildings.Fluid.Sources.Boundary_pT bouBor(redeclare package Medium =
        IDEAS.Media.Water,
                       nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,10})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=pumpBor.m_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{10,50},{-10,30}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-102,80},{-82,100}})));
  TwoUTubes_Cont borefield(
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
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBorFie_flow_nominal=m_flow_bor_nominal,
        dp_nominal(displayUnit="Pa") = 10000,
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
        xC=0.043)),
    allowFlowReversal=false,
    redeclare package Medium = IDEAS.Media.Water,
    redeclare parameter
      IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.Data.RCelPlayAround
      rCel,
    redeclare parameter
      IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.Data.KappaPlayAround
      kappa)                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-2,80})));

  Modelica.Blocks.Sources.Step step(height=-5000,  startTime=36000)
    annotation (Placement(transformation(extent={{-18,0},{2,20}})));
  Modelica.Blocks.Sources.RealExpression QEvaExpr(y=-BorLoadProf.y[1]/hea.Q_flow_nominal)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={34,18})));
  Modelica.Blocks.Sources.CombiTimeTable BorLoadProf(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.NoExtrapolation,
    offset={0},
    columns={2},
    fileName=Modelica.Utilities.Files.loadResource("modelica://HySIMo/Resources/Borefields/BorefieldLoad_Example.txt"),
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{60,32},{80,52}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow pumpBor_IDEASmodel(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borefield.borFieDat.conDat.mBorFie_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    riseTime=60,
    nominalValuesDefineDefaultPressureCurve=true,
    tau=60,
    use_inputFilter=false,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-50,-38})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort THpEvaIn_IDEASmodel(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{26,-60},{14,-48}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THpEvaOut_IDEASmodel(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-14,-60},{-26,-48}})));
  Buildings.Fluid.Sources.Boundary_pT bouBor_IDEASmodel(redeclare package
      Medium = IDEAS.Media.Water, nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-84})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=pumpBor.m_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{10,-44},{-10,-64}})));
  IDEAS.Fluid.Geothermal.Borefields.TwoUTubes borefield_IDEASmodel(
    tLoaAgg=3600,
    nCel=1,
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
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBorFie_flow_nominal=m_flow_bor_nominal,
        dp_nominal(displayUnit="Pa") = 10000,
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
        xC=0.043)),
    allowFlowReversal=false,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-2,-14})));

  Modelica.Blocks.Sources.Step step_IDEASmodel(height=-5000, startTime=36000)
    annotation (Placement(transformation(extent={{-18,-94},{2,-74}})));
  Modelica.Blocks.Sources.RealExpression QEvaExpr_IDEASmodel(y=-BorLoadProf.y[1]
        /hea.Q_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={34,-76})));
equation

  connect(bouBor.ports[1],pumpBor. port_a) annotation (Line(points={{-50,20},{-50,
          46}},                           color={0,127,255}));
  connect(THpEvaIn.port_b,hea. port_a)
    annotation (Line(points={{14,40},{10,40}},color={0,127,255}));
  connect(hea.port_b,THpEvaOut. port_a)
    annotation (Line(points={{-10,40},{-14,40}}, color={0,127,255}));
  connect(THpEvaOut.port_b,pumpBor. port_a)
    annotation (Line(points={{-26,40},{-50,40},{-50,46}}, color={0,127,255}));
  connect(pumpBor.port_b, borefield.port_a)
    annotation (Line(points={{-50,66},{-50,80},{-12,80}}, color={0,127,255}));
  connect(borefield.port_b, THpEvaIn.port_a) annotation (Line(points={{8,80},{32,
          80},{32,40},{26,40}}, color={0,127,255}));
  connect(QEvaExpr.y, hea.u)
    annotation (Line(points={{23,18},{12,18},{12,34}}, color={0,0,127}));
  connect(bouBor_IDEASmodel.ports[1], pumpBor_IDEASmodel.port_a)
    annotation (Line(points={{-50,-74},{-50,-48}}, color={0,127,255}));
  connect(THpEvaIn_IDEASmodel.port_b, hea1.port_a)
    annotation (Line(points={{14,-54},{10,-54}}, color={0,127,255}));
  connect(hea1.port_b, THpEvaOut_IDEASmodel.port_a)
    annotation (Line(points={{-10,-54},{-14,-54}}, color={0,127,255}));
  connect(THpEvaOut_IDEASmodel.port_b, pumpBor_IDEASmodel.port_a) annotation (
      Line(points={{-26,-54},{-50,-54},{-50,-48}}, color={0,127,255}));
  connect(pumpBor_IDEASmodel.port_b, borefield_IDEASmodel.port_a) annotation (
      Line(points={{-50,-28},{-50,-14},{-12,-14}}, color={0,127,255}));
  connect(borefield_IDEASmodel.port_b, THpEvaIn_IDEASmodel.port_a) annotation (
      Line(points={{8,-14},{32,-14},{32,-54},{26,-54}}, color={0,127,255}));
  connect(QEvaExpr_IDEASmodel.y, hea1.u)
    annotation (Line(points={{23,-76},{12,-76},{12,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=2674800,
      Interval=900,
      __Dymola_fixedstepsize=30,
      __Dymola_Algorithm="Euler"));
end Loadprofile;
