within IOCSmod.Demand.BuildingModels;
model Cluster10Naomi
  extends
    ThermalModels.CollectiveSystems.Optimisation.BaseClasses.Cluster.Cluster10Fh;
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        IDEAS.Media.Water)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        IDEAS.Media.Water)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}}),
        iconTransformation(extent={{50,-110},{70,-90}})));
  Modelica.Blocks.Sources.CombiTimeTable P_appliances_profile(
    tableOnFile=true,
    tableName="data",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
        "modelica://IOCSmod/Resources/OccupancyProfiles/Appliance_power_demand_StijnS_14houses.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=house1.pum.P + house2.pum.P
         + house3.pum.P + house4.pum.P + house5.pum.P + house6.pum.P + house7.pum.P
         + house8.pum.P + house9.pum.P + house10.pum.P)
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Modelica.Blocks.Math.Sum Pnet(nin=2, k={1,10/14})
    annotation (Placement(visible = true, transformation(origin={-90,70},     extent = {{-10, -10}, {10, 10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput P
    annotation(Placement(transformation(extent={{-60,60},{-40,80}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-310,80})));
  UnitTests.Circuits.CircuitCollector collector(redeclare package Medium =
        IDEAS.Media.Water, m_flow_nominal=m_flow_nom_dh)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={289,-42})));
equation

  connect(realExpression.y,Pnet. u[1]) annotation (Line(points={{-139,90},{-126,
          90},{-126,69},{-102,69}},
                                  color={0,0,127}));
  connect(P_appliances_profile.y[1],Pnet. u[2]) annotation (Line(points={{-139,60},
          {-122,60},{-122,71},{-102,71}},   color={0,0,127}));
  connect(Pnet.y,P)
    annotation (Line(points={{-79,70},{-50,70}}, color={0,0,127}));
  connect(collector.port_a1, port_a1) annotation (Line(points={{295,-32},{318,
          -32},{318,-80},{-60,-80},{-60,-100}}, color={0,127,255}));
  connect(port_b1, port_b1)
    annotation (Line(points={{60,-100},{60,-100}}, color={0,127,255}));
  connect(port_b1, collector.port_b1) annotation (Line(points={{60,-100},{300,
          -100},{300,-52},{295,-52}}, color={0,127,255}));
  connect(collector.port_a2, DHnet1.port_b2) annotation (Line(points={{283,-52},
          {282,-52},{282,-58},{264,-58},{264,-46},{258,-46}}, color={0,127,255}));
  connect(collector.port_b2, DHnet1.port_a1) annotation (Line(points={{283,-32},
          {282,-32},{282,-24},{264,-24},{264,-34},{258,-34}}, color={0,127,255}));
end Cluster10Naomi;
