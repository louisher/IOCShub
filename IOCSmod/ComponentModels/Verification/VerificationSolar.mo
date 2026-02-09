within IOCSmod.ComponentModels.Verification;
model VerificationSolar
  "Verification through simulation of STC and PVT"
  extends IOCSmod.Optimization.Interface(priceSim(path_economic_params_json=
          Modelica.Utilities.Files.loadResource("C:/Workdir/Develop/IOCS/input_data/economic_params.json")));

  IDEAS.Fluid.Sources.Boundary_pT bouStc(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-10,70})));
  Thermal.Stc  stc(pumPanels(
        inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous, m_flow_in=RealpumSolarOn.y*stc.pumPanels.m_flow_nominal),
    addDummyEquation=addDummyEquation,
    hasReg=false,
    selDefault=0,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    totalArea=10,
    dT_nominal=-10,
    redeclare
      IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F
      per)
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume volStc(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=5,
    nPorts=3) annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.RealExpression RealpumSolarOn(y=if sim.HGloHor.y > 300
         then 1 else 0.001)
    annotation (Placement(transformation(extent={{-100,98},{-80,118}})));
  Modelica.Blocks.Math.RealToInteger pumSolarOn
    annotation (Placement(transformation(extent={{-70,98},{-50,118}})));
  IDEAS.Fluid.Sources.Boundary_pT bouStcOpt(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-8,0})));
  Thermal.SizeOpt.StcOpt stcOpt(
    addDummyEquation=addDummyEquation,
    hasReg=false,
    selDefault=0,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    dT_nominal=-10,
    redeclare Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F per,
    Size=10,
    Size_nominal=10,
    inv_cost(fixed=true)=400,
    interest_rate(fixed=true)=0.05,
    lifetime(fixed=true)=40,
    observation_time(fixed=true)=40,
    modPumPanels=RealpumSolarOn.y)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume volStcOpt(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=5,
    nPorts=3)
    annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
  IDEAS.Fluid.Sources.Boundary_pT bouPVt(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={120,50})));
  Thermal.Pvt  pvt(
    pumPanels(inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous,
        m_flow_in=RealpumSolarOn.y*stc.pumPanels.m_flow_nominal),
    addDummyEquation=addDummyEquation,
    hasReg=false,
    selDefault=0,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    totalArea=10,
    dT_nominal=-10,
    redeclare Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F per)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume volPvt(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=5,
    nPorts=3) annotation (Placement(transformation(extent={{90,40},{110,60}})));
  IDEAS.Fluid.Sources.Boundary_pT bouPvtOpt(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={122,-10})));
  Thermal.SizeOpt.PvtOpt pvtOpt(
    addDummyEquation=addDummyEquation,
    hasReg=false,
    selDefault=0,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    dT_nominal=-10,
    redeclare Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F per,
    Size=10,
    Size_nominal=10,
    inv_cost(fixed=true) = 400,
    interest_rate(fixed=true) = 0.05,
    lifetime(fixed=true) = 40,
    observation_time(fixed=true) = 40,
    modPumPanels=RealpumSolarOn.y)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume volPvtOpt(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=5,
    nPorts=3) annotation (Placement(transformation(extent={{92,-20},{112,0}})));
  Electrical.PVPanelDC pv(PVArea=100)
    annotation (Placement(transformation(extent={{-20,-102},{0,-82}})));
  Electrical.LinearBattery bat(
    P_max=15000,
    EBat_max=540000000,
    u=ChaExpr.y)
    annotation (Placement(transformation(extent={{-90,-102},{-110,-82}})));
      Modelica.Blocks.Sources.CombiTimeTable P_appliances_profile(
    tableOnFile=true,
    tableName="data",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath("modelica://IOCSmod/Resources/OccupancyProfiles/Appliance_power_demand_StijnS_14houses.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-20,-80},{-40,-60}})));

  Modelica.Blocks.Math.Sum sum1(nin=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-62,-92})));
  Modelica.Blocks.Sources.RealExpression ChaExpr(y=-(P_appliances_profile.y[1] +
        pv.P)/bat.P_max)
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Electrical.SizeOpt.LinearBatteryOpt batOpt(Size=150, P_max=15000,
    SoC(start=0.5),                                                 u=ChaExprOpt.y,
    inv_cost(fixed=true) = 400,
    interest_rate(fixed=true) = 0.05,
    lifetime(fixed=true) = 40,
    observation_time(fixed=true) = 40)
    annotation (Placement(transformation(extent={{-92,-150},{-112,-130}})));
  Modelica.Blocks.Sources.RealExpression ChaExprOpt(y=-(P_appliances_profile.y[1]
         + pvOpt.P)/batOpt.P_max)
    annotation (Placement(transformation(extent={{-140,-134},{-120,-114}})));
  Modelica.Blocks.Math.Sum sum2(nin=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-64,-140})));
  Electrical.SizeOpt.PVPanelDC_AreaOpt pvOpt(Size=100,
      inv_cost(fixed=true) = 400,
    interest_rate(fixed=true) = 0.05,
    lifetime(fixed=true) = 40,
    observation_time(fixed=true) = 40)
    annotation (Placement(transformation(extent={{-22,-150},{-2,-130}})));
initial equation
  stcOpt.inv.inv_cost = 400;
  stcOpt.inv.interest_rate = 0.05;
  stcOpt.inv.lifetime = 40;
  stcOpt.inv.observation_time = 40;
  pvtOpt.inv.inv_cost = 400;
  pvtOpt.inv.interest_rate = 0.05;
  pvtOpt.inv.lifetime = 40;
  pvtOpt.inv.observation_time = 40;

  batOpt.inv.inv_cost = 400;
  batOpt.inv.interest_rate = 0.05;
  batOpt.inv.lifetime = 40;
  batOpt.inv.observation_time = 40;
  pvOpt.inv.inv_cost = 400;
  pvOpt.inv.interest_rate = 0.05;
  pvOpt.inv.lifetime = 40;
  pvOpt.inv.observation_time = 40;




equation
  connect(stc.port_a, volStc.ports[1]) annotation (Line(points={{-74,60},{-74,
          54},{-26,54},{-26,60},{-32.6667,60}},
                                            color={0,127,255}));
  connect(stc.port_b, volStc.ports[2]) annotation (Line(points={{-86,60},{-86,40},
          {-30,40},{-30,60}}, color={0,127,255}));
  connect(bouStc.ports[1], volStc.ports[3]) annotation (Line(points={{-10,65},{
          -10,60},{-27.3333,60}},
                              color={0,127,255}));
  connect(RealpumSolarOn.y, pumSolarOn.u)
    annotation (Line(points={{-79,108},{-72,108}}, color={0,0,127}));
  connect(stcOpt.port_a, volStcOpt.ports[1]) annotation (Line(points={{-74,-10},
          {-74,-16},{-24,-16},{-24,-10},{-30.6667,-10}}, color={0,127,255}));
  connect(stcOpt.port_b, volStcOpt.ports[2]) annotation (Line(points={{-86,-10},
          {-86,-30},{-28,-30},{-28,-10}}, color={0,127,255}));
  connect(bouStcOpt.ports[1], volStcOpt.ports[3]) annotation (Line(points={{-8,-5},
          {-8,-10},{-25.3333,-10}}, color={0,127,255}));
  connect(pvt.port_a, volPvt.ports[1]) annotation (Line(points={{56,40},{56,34},
          {104,34},{104,40},{97.3333,40}}, color={0,127,255}));
  connect(pvt.port_b, volPvt.ports[2]) annotation (Line(points={{44,40},{44,20},
          {100,20},{100,40}}, color={0,127,255}));
  connect(bouPVt.ports[1], volPvt.ports[3]) annotation (Line(points={{120,45},{
          120,40},{102.667,40}},
                             color={0,127,255}));
  connect(pvtOpt.port_a, volPvtOpt.ports[1]) annotation (Line(points={{56,-20},
          {56,-26},{106,-26},{106,-20},{99.3333,-20}},color={0,127,255}));
  connect(pvtOpt.port_b, volPvtOpt.ports[2]) annotation (Line(points={{44,-20},{
          44,-40},{102,-40},{102,-20}}, color={0,127,255}));
  connect(bouPvtOpt.ports[1], volPvtOpt.ports[3]) annotation (Line(points={{122,-15},
          {122,-20},{104.667,-20}},      color={0,127,255}));
  connect(bat.PDem,sum1. y)
    annotation (Line(points={{-88,-92},{-73,-92}},       color={0,0,127}));
  connect(pv.P, sum1.u[1]) annotation (Line(points={{-21,-92},{-36,-92},{-36,-91},
          {-50,-91}}, color={0,0,127}));
  connect(P_appliances_profile.y[1], sum1.u[2])
    annotation (Line(points={{-41,-70},{-50,-70},{-50,-93}}, color={0,0,127}));
  connect(sum2.y, batOpt.PDem)
    annotation (Line(points={{-75,-140},{-90,-140}}, color={0,0,127}));
  connect(P_appliances_profile.y[1], sum2.u[1]) annotation (Line(points={{-41,-70},
          {-52,-70},{-52,-139}}, color={0,0,127}));
  connect(pvOpt.P, sum2.u[2]) annotation (Line(points={{-23,-140},{-52,-140},{-52,
          -141}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=15897600,
      StopTime=16502400,
      Interval=900.00288,
      __Dymola_Algorithm="Dassl"));
end VerificationSolar;
