within IOCSmod.Simulation;
model Tester2
package AntifreezeBor = IDEAS.Media.Antifreeze.PropyleneGlycolWater(property_T=278.15, X_a=0.465)
    "Medium in the borehole circuit";
  package MediumWater = IDEAS.Media.Water(T_min=273.15-10);

  parameter Modelica.Units.SI.HeatFlowRate Qnom_GsHp = 15000;
  parameter Modelica.Units.SI.MassFlowRate m_flow_bor_nominal=0.2*10*10
    "Nominal mass flow borefield";
  parameter String loadProfDir = Modelica.Utilities.Files.loadResource(loadDir)
    "Directory containing the data files";
  parameter String loadDir = IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath("modelica://BorOptMod/Resources/Data/Office_power_ground.txt") "location of load profile" annotation (Evaluate=false);

      // COORDINATES for 10 boreholes
      //  cooBor=[0,0; -4.7,-4.03; -12.45,2.1; -15.49,2.91; -20.46,-6.27; -20.82,-12.28;
        //    -15.42,-10.01; -9.92,-7.37; -21,0; -17.15,6.7],

  IDEAS.Fluid.Movers.FlowControlled_m_flow     pumpBor(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_bor_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    riseTime=60,
    nominalValuesDefineDefaultPressureCurve=true,
    tau=60,
    use_inputFilter=false,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-52,64})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHpEvaIn(
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{24,42},{12,54}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHpEvaOut(
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-16,42},{-28,54}})));
  Buildings.Fluid.Sources.Boundary_pT bouBor(redeclare package Medium =
        MediumWater, nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,18})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = MediumWater,
    m_flow_nominal=pumpBor.m_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{8,58},{-12,38}})));

  Modelica.Blocks.Sources.RealExpression QEvaExpr(y=BorLoadProf.y[1]*1000)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={44,28})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  Modelica.Blocks.Sources.CombiTimeTable BorLoadProf(
    tableOnFile=true,
    tableName="power",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath("modelica://BorOptMod/Resources/Data/Office_power_ground.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{54,50},{74,70}})));

  ComponentModels.Thermal.SizeOpt.Borefields.TwoUTubes_ContOpt borefield(
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
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBorFie_flow_nominal=m_flow_bor_nominal,
        dp_nominal(displayUnit="Pa") = 1,
        hBor=160,
        cooBor=[0,0; 0,3; 3,0; 3,3],
        mBor_flow_nominal=m_flow_bor_nominal/borefield.borFieDat.conDat.nBor,
        nBor=100,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043)),
    groTemResDat(rCel(rCel={1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0,512.0,1024.0,
            2048.0,4096.0,8192.0,16384.0,32768.0,65536.0,131072.0,88257.0}),
        kappa(kappa={4.1547033142330825e-06,1.8227162630329934e-06,1.6415429599205274e-06,
            1.6065929190741114e-06,1.6098576666074675e-06,1.6204602351473251e-06,
            1.6284345243860419e-06,1.635552596627718e-06,1.7153447564980008e-06,
            2.328247820034715e-06,4.152922529980003e-06,7.699903455168606e-06,1.375944375728011e-05,
            2.3021285622305296e-05,3.50652110728988e-05,4.710566066500215e-05,5.4003320055350554e-05,
            5.129448944249466e-05,1.845439231534606e-05})))
                    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

equation
  connect(bouBor.ports[1],pumpBor. port_a) annotation (Line(points={{-52,28},{-52,
          54}},                           color={0,127,255}));
  connect(senTHpEvaIn.port_b, hea.port_a)
    annotation (Line(points={{12,48},{8,48}}, color={0,127,255}));
  connect(hea.port_b, senTHpEvaOut.port_a)
    annotation (Line(points={{-12,48},{-16,48}}, color={0,127,255}));
  connect(senTHpEvaOut.port_b, pumpBor.port_a)
    annotation (Line(points={{-28,48},{-52,48},{-52,54}}, color={0,127,255}));
  connect(QEvaExpr.y, hea.u)
    annotation (Line(points={{33,28},{10,28},{10,42}}, color={0,0,127}));
  connect(pumpBor.port_b, borefield.port_a) annotation (Line(points={{-52,74},{-52,
          82},{-10,82},{-10,80}}, color={0,127,255}));
  connect(borefield.port_b, senTHpEvaIn.port_a) annotation (Line(points={{10,80},
          {36,80},{36,48},{24,48}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_fixedstepsize=30,
      __Dymola_Algorithm="Euler"));
end Tester2;
