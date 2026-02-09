within IOCSmod.Optimization;
model Test

  inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));

  ComponentModels.Thermal.SolarCollectors.EN12975 solCol1(
    redeclare package Medium = Buildings.Media.Water,
    show_T=true,
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
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));

  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,30})));
  IDEAS.BoundaryConditions.WeatherData.Bus weaDatBus1
    "Weather data bus connectable to weaBus connector from Buildings Library"
    annotation (Placement(transformation(extent={{-56,78},{-36,98}})));
  UnitTests.Confidential.FlowControlled_m_flow pum(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=2*0.06,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    dp_nominal=10000)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  IDEAS.Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = IDEAS.Media.Water,
    T=298.15,
    nPorts=1)                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,30})));
  IDEAS.Fluid.Sources.Boundary_pT bou3(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-40})));
  ComponentModels.Thermal.SolarCollectors.PhotoVoltaicThermalCollector pvt(
    redeclare package Medium = Buildings.Media.Water,
    azi=0,
    til=0.97738438111682,
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
      IAMDiff(unit="1") = 0.89,
      eta0(unit="1") = 0.76,
      a1=4.031,
      a2(unit="W/(m2.K2)") = 0.034),
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=10,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    dT_nominal=-10,
    dTMax=30)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  ComponentModels.Electrical.PVPanelDC pv(
    Apanel=2.51,
    PVArea=10,
    til=0.78539816339745)
    annotation (Placement(transformation(extent={{34,62},{54,82}})));
  Modelica.Blocks.Sources.CombiTimeTable OfficeHours(
    fileName=Modelica.Utilities.Files.loadResource("modelica://DistrictHeating_5GDHC/Resources/OccupancyProfiles/office_hours_hourly.txt"),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-90,52},{-70,72}})));

  Modelica.Blocks.Sources.CombiTimeTable P_appliances_profile(
    tableOnFile=true,
    tableName="data",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
        "modelica://IOCSmod/Resources/OccupancyProfiles/Appliance_power_demand_StijnS_14houses.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-60,52},{-40,72}})));
equation


  connect(bou1.ports[1], solCol1.port_b)
    annotation (Line(points={{40,30},{26,30},{26,32},{10,32}},
                                               color={0,127,255}));
  connect(sim.weaDatBus, weaDatBus1) annotation (Line(
      points={{-80.1,88},{-46,88}},
      color={255,204,51},
      thickness=0.5));
  connect(bou2.ports[1], pum.port_a) annotation (Line(points={{-70,30},{-64,30},
          {-64,0},{-58,0}}, color={0,127,255}));
  connect(pum.port_b, solCol1.port_a) annotation (Line(points={{-38,0},{-16,0},
          {-16,32},{-10,32}},color={0,127,255}));
  connect(pvt.port_b, bou3.ports[1])
    annotation (Line(points={{10,-40},{40,-40}}, color={0,127,255}));
  connect(pum.port_b, pvt.port_a) annotation (Line(points={{-38,0},{-18,0},{-18,
          -40},{-10,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=300,
      __Dymola_Algorithm="Dassl"));
end Test;
