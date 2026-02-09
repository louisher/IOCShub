within IOCSmod.ComponentModels.Verification;
model VerificationHPs
  extends IOCSmod.Optimization.Interface(priceSim(path_economic_params_json=
          Modelica.Utilities.Files.loadResource("C:/Workdir/Develop/IOCS/input_data/economic_params.json")));


  Thermal.SimpleTank tan(
    m_flow_nominal=1,
    VTan=50,
    nPorts=5) annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Thermal.GsHp GsHp(
    groTemResDat(rCel(rCel={1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0, 128.0, 256.0, 512.0, 1024.0, 2048.0, 4096.0, 8192.0, 16384.0, 32768.0, 65536.0, 131072.0, 88257.0}), kappa(kappa=
           {9.695438398636223e-05, 4.249107565773161e-05, 3.82623576995226e-05, 3.746462513490873e-05, 3.75313766822619e-05, 3.7761228533105885e-05, 3.792258567242827e-05, 3.803762907230709e-05, 3.9165568478046506e-05, 4.7816798094832034e-05, 7.086019797370938e-05, 0.00010390792009430888, 0.00013606750951614664, 0.00015742174924082372, 0.00016349878922684467, 0.0001552736630771102, 0.00013593612243729914, 0.00010837741719068976, 3.600994742541247e-05})),
    GsHp(
    mod =           modHps.y),
    addDummyEquation=false,
    hasReg=false,
    Qnom_GsHp=12000,
    TBorMin=273.15,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        dp_nominal(displayUnit="Pa"),
        hBor=125,
        nBor=6)),   pumHexCooEva(inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous, m_flow_in=0.001))
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Thermal.AsHp AsHp(
    AsHp(HP(
  mod =         modHps.y)),
  addDummyEquation=false,
    Qnom_AsHp=8000)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Modelica.Blocks.Sources.RealExpression modHps(y=if ((calTim.hour > 8) and (
        calTim.hour < 20)) then 0 else 1)
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-50,50})));
  Thermal.SizeOpt.SimpleTankOpt
                     tanOpt(
    Size=50,
    m_flow_nominal=1,
    nPorts=5,inv_cost(fixed=true)=400,
    interest_rate(fixed=true)=0.05,
    lifetime(fixed=true)=40,
    observation_time(fixed=true)=40) annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  VerificationGsHpOptAid  GsHpOpt(
    Size=12,
    Size_nominal=12,
    inv_cost_hp(fixed=true)=400,
    inv_cost_bor(fixed=true)=40,
    interest_rate(fixed=true)=0.05,
    lifetime_hp(fixed=true)=40,
    lifetime_bor(fixed=true)=40,
    observation_time(fixed=true)=40,
    groTemResDat(rCel(rCel={1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0,512.0,1024.0,
            2048.0,4096.0,8192.0,16384.0,32768.0,65536.0,131072.0,88257.0}),
        kappa(kappa={9.695438398636223e-05,4.249107565773161e-05,3.82623576995226e-05,
            3.746462513490873e-05,3.75313766822619e-05,3.7761228533105885e-05,3.792258567242827e-05,
            3.803762907230709e-05,3.9165568478046506e-05,4.7816798094832034e-05,
            7.086019797370938e-05,0.00010390792009430888,0.00013606750951614664,
            0.00015742174924082372,0.00016349878922684467,0.0001552736630771102,
            0.00013593612243729914,0.00010837741719068976,3.600994742541247e-05})),
    GsHp(mod=modHps.y),
    addDummyEquation=false,
    hasReg=false,
    TBorMin=273.15,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        dp_nominal(displayUnit="Pa"),
        hBor=125,
        nBor=6)),
    pumHexCooEva(inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous,
        m_flow_in=0.001))
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Thermal.SizeOpt.AsHpOpt
               AsHpOpt(
    Size=8,
    Size_nominal=8,
    AsHp(HP(mod=modHps.y)),
    addDummyEquation=false,
    inv_cost(fixed=true)=400,
    interest_rate(fixed=true)=0.05,
    lifetime(fixed=true)=40,
    observation_time(fixed=true)=40)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  IDEAS.Fluid.Sources.Boundary_pT bouOpt(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-50,10})));
  IDEAS.Utilities.Time.CalendarTime calTim(zerTim=IDEAS.Utilities.Time.Types.ZeroTime.NY2020)
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
initial equation
    GsHp.groTemResDat.rCel.rCel={1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0, 128.0, 256.0, 512.0, 1024.0, 2048.0, 4096.0, 8192.0, 16384.0, 32768.0, 65536.0, 131072.0, 88257.0};
    GsHp.groTemResDat.kappa.kappa={9.695438398636223e-05, 4.249107565773161e-05, 3.82623576995226e-05, 3.746462513490873e-05, 3.75313766822619e-05, 3.7761228533105885e-05, 3.792258567242827e-05, 3.803762907230709e-05, 3.9165568478046506e-05, 4.7816798094832034e-05, 7.086019797370938e-05, 0.00010390792009430888, 0.00013606750951614664, 0.00015742174924082372, 0.00016349878922684467, 0.0001552736630771102, 0.00013593612243729914, 0.00010837741719068976, 3.600994742541247e-05};
    GsHpOpt.groTemResDat.rCel.rCel={1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0, 128.0, 256.0, 512.0, 1024.0, 2048.0, 4096.0, 8192.0, 16384.0, 32768.0, 65536.0, 131072.0, 88257.0};
    GsHpOpt.groTemResDat.kappa.kappa={9.695438398636223e-05, 4.249107565773161e-05, 3.82623576995226e-05, 3.746462513490873e-05, 3.75313766822619e-05, 3.7761228533105885e-05, 3.792258567242827e-05, 3.803762907230709e-05, 3.9165568478046506e-05, 4.7816798094832034e-05, 7.086019797370938e-05, 0.00010390792009430888, 0.00013606750951614664, 0.00015742174924082372, 0.00016349878922684467, 0.0001552736630771102, 0.00013593612243729914, 0.00010837741719068976, 3.600994742541247e-05};
    GsHpOpt.inv_hp.inv_cost=400;
    GsHpOpt.inv_bor.inv_cost=40;
    GsHpOpt.inv_hp.interest_rate=0.05;
    GsHpOpt.inv_bor.interest_rate=0.05;
    GsHpOpt.inv_hp.lifetime=40;
    GsHpOpt.inv_bor.lifetime=40;
    GsHpOpt.inv_hp.observation_time=40;
    GsHpOpt.inv_bor.observation_time=40;
  tanOpt.inv.inv_cost = 400;
  tanOpt.inv.interest_rate = 0.05;
  tanOpt.inv.lifetime = 40;
  tanOpt.inv.observation_time = 40;
  AsHpOpt.inv.inv_cost = 400;
  AsHpOpt.inv.interest_rate = 0.05;
  AsHpOpt.inv.lifetime = 40;
  AsHpOpt.inv.observation_time = 40;
equation
  connect(AsHp.port_a, tan.ports[1]) annotation (Line(points={{16,40},{16,20},{-33.2,
          20},{-33.2,40}},  color={0,127,255}));
  connect(AsHp.port_b, tan.ports[2]) annotation (Line(points={{4,40},{4,26},{-31.6,
          26},{-31.6,40}},  color={0,127,255}));
  connect(GsHp.port_a, tan.ports[3]) annotation (Line(points={{-64,40},{-64,32},
          {-30,32},{-30,40}}, color={0,127,255}));
  connect(GsHp.port_b, tan.ports[4]) annotation (Line(points={{-76,40},{-76,24},
          {-28.4,24},{-28.4,40}},
                              color={0,127,255}));
  connect(bou.ports[1], tan.ports[5]) annotation (Line(points={{-50,45},{-50,32},
          {-32,32},{-32,36},{-26.8,36},{-26.8,40}},
                                  color={0,127,255}));
  connect(AsHpOpt.port_a, tanOpt.ports[1]) annotation (Line(points={{16,-20},{16,
          -40},{-33.2,-40},{-33.2,-20}}, color={0,127,255}));
  connect(AsHpOpt.port_b, tanOpt.ports[2]) annotation (Line(points={{4,-20},{4,-34},
          {-31.6,-34},{-31.6,-20}}, color={0,127,255}));
  connect(GsHpOpt.port_a, tanOpt.ports[3]) annotation (Line(points={{-64,-20},{-64,
          -28},{-30,-28},{-30,-20}}, color={0,127,255}));
  connect(GsHpOpt.port_b, tanOpt.ports[4]) annotation (Line(points={{-76,-20},{-76,
          -36},{-28.4,-36},{-28.4,-20}}, color={0,127,255}));
  connect(bouOpt.ports[1], tanOpt.ports[5]) annotation (Line(points={{-50,5},{-50,
          -26},{-26.8,-26},{-26.8,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=604800,
      Interval=900.00288,
      __Dymola_Algorithm="Dassl"));
end VerificationHPs;
