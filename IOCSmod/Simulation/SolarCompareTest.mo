within IOCSmod.Simulation;
model SolarCompareTest
  inner IDEAS.BoundaryConditions.SimInfoManager sim(filNam=
        Modelica.Utilities.Files.loadResource(
        "C:/Users/u0148284/OneDrive - KU Leuven/PhD/HorizonProject/ExtremeWeatherData/WeerDataBelgium_TMY_XMY_Uliege/mos-files/Brussels-City_XMY2021-2040_ssp245_MAR-BCC_SWDbased.mos"),
                                                    lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  ComponentModels.Thermal.SolarCollectors.EN12975 solCol1(
    redeclare package Medium = Buildings.Media.Water,
    show_T=true,
    nSeg=1,
    azi=0,
    til=0.97738438111682,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=10,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    per(
      A=2.51,
      CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.TotalCapacity,
      C=5.97e3,
      V=2.4/1000,
      mDry=40.9,
      mperA_flow_nominal=30/3600,
      dp_nominal=10000,
      incAngDat(displayUnit="rad") = Modelica.Units.Conversions.from_deg({0,10,20,
        30,40,50,60,70,80,90}),
      incAngModDat={1,1,0.99,0.97,0.94,0.89,0.81,0.63,0.33,0.00},
      IAMDiff=0.89,
      eta0=0.76,
      a1=4.031,
      a2=0.034),
    dT_nominal=-10,
    dTMax=30)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,30})));
  IDEAS.BoundaryConditions.WeatherData.Bus weaDatBus1
    "Weather data bus connectable to weaBus connector from Buildings Library"
    annotation (Placement(transformation(extent={{-56,78},{-36,98}})));
  IDEAS.Fluid.Sources.Boundary_pT bou3(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-40})));
  ComponentModels.Thermal.SolarCollectors.PhotoVoltaicThermalCollector pvt(
    redeclare package Medium = Buildings.Media.Water,
    show_T=true,
    nSeg=1,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    per(
      A=2.51,
      CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.TotalCapacity,
      C=5.97e3,
      V=2.4/1000,
      mDry=40.9,
      mperA_flow_nominal=30/3600,
      dp_nominal=10000,
      incAngDat(displayUnit="rad") = Modelica.Units.Conversions.from_deg({0,10,
        20,30,40,50,60,70,80,90}),
      incAngModDat={1,1,0.99,0.97,0.94,0.89,0.81,0.63,0.33,0.00},
      IAMDiff=0.94,
      eta0=0.35,
      a1=8.59,
      a2=0),
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=10,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    dT_nominal=-10,
    dTMax=30) annotation (Placement(transformation(extent={{-12,-50},{8,-30}})));

  ComponentModels.Electrical.PVPanelDC pv(
    Apanel=2.51,
    PVArea=10,
    til=0.78539816339745,
    azi=0)
    annotation (Placement(transformation(extent={{34,62},{54,82}})));
  IDEAS.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow=0.06,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  IDEAS.Fluid.Sources.MassFlowSource_T boundary1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow=0.12,
    T=283.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-74,-64},{-54,-44}})));
  Modelica.Blocks.Continuous.Integrator E_pv(k=1/3600000)
    annotation (Placement(transformation(extent={{112,54},{132,74}})));
  Modelica.Blocks.Continuous.Integrator E_pvt(k=1/3600000)
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
equation
  connect(bou1.ports[1],solCol1. port_b)
    annotation (Line(points={{40,30},{10,30}}, color={0,127,255}));
  connect(sim.weaDatBus,weaDatBus1)  annotation (Line(
      points={{-80.1,88},{-46,88}},
      color={255,204,51},
      thickness=0.5));
  connect(pvt.port_b,bou3. ports[1])
    annotation (Line(points={{8,-40},{40,-40}},  color={0,127,255}));
  connect(boundary.ports[1], solCol1.port_a)
    annotation (Line(points={{-60,30},{-10,30}}, color={0,127,255}));
  connect(boundary1.ports[1], pvt.port_a) annotation (Line(points={{-54,-54},{-16,
          -54},{-16,-40},{-12,-40}}, color={0,127,255}));
  connect(pv.P, E_pv.u) annotation (Line(points={{33,72},{22,72},{22,64},{110,
          64}}, color={0,0,127}));
  connect(E_pvt.u, pvt.P)
    annotation (Line(points={{98,-10},{-13,-10},{-13,-48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=299.999808,
      __Dymola_Algorithm="Dassl"));
end SolarCompareTest;
