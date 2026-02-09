within IOCSmod.Demand.BuildingModels;
model DeSchipjes
  extends IOCSmod.Demand.BuildingEnvelopes.DeSchipjesBaseBhp;

    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-250,-490},{-230,-470}}),
    iconTransformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-120,-490},{-100,-470}}),
    iconTransformation(extent={{10,-110},{30,-90}})));

  Modelica.Blocks.Interfaces.RealOutput P
    annotation(Placement(transformation(extent={{-200,-2},{-180,18}}),
      iconTransformation(extent={{100,-64},{120,-44}})));

  Modelica.Blocks.Sources.CombiTimeTable P_appliances_profile(
    tableOnFile=true,
    tableName="data",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
        "modelica://IOCSmod/Resources/OccupancyProfiles/Appliance_power_demand_StijnS_14houses.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-300,-12},{-280,8}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=PEl_Schema_DeSchipjes)
    annotation (Placement(transformation(extent={{-300,18},{-280,38}})));
  Modelica.Blocks.Math.Sum Pnet(nin=3, k={1,12/14,1})
    annotation (Placement(visible = true, transformation(origin={-230,8},     extent = {{-10, -10}, {10, 10}}, rotation=0)));

  UnitTests.Circuits.CircuitCollector collector__Heating_collector(redeclare
      package Medium = MediumWater, m_flow_nominal=1.72)
                      annotation(Placement(transformation(extent={{1749,-220},{
            1769,-240}})));
  Modelica.Blocks.Sources.RealExpression ExprPEl_Bhps(y=bhp_158.PEl + bhp_156.PEl
         + bhp_154.PEl + bhp_152.PEl + bhp_150.PEl + bhp_148.PEl + bhp_146.PEl
         + bhp_144.PEl + bhp_142.PEl + bhp_140.PEl + bhp_138.PEl + bhp_136.PEl)
    annotation (Placement(transformation(extent={{-300,-50},{-280,-30}})));
equation
  connect(realExpression.y, Pnet.u[1]) annotation (Line(points={{-279,28},{-266,
          28},{-266,6.66667},{-242,6.66667}},
                                  color={0,0,127}));
  connect(P_appliances_profile.y[1], Pnet.u[2]) annotation (Line(points={{-279,-2},
          {-262,-2},{-262,8},{-242,8}},     color={0,0,127}));
  connect(Pnet.y, P)
    annotation (Line(points={{-219,8},{-190,8}}, color={0,0,127}));
  connect(collector__HEXVAL_136.port_a1, collector__HEXVAL_138.port_a1)
    annotation (Line(points={{1748,-166},{1730,-166},{1730,-66},{1748,-66}},
        color={0,127,255}));
  connect(collector__HEXVAL_138.port_a1, collector__HEXVAL_140.port_a1)
    annotation (Line(points={{1748,-66},{1730,-66},{1730,34},{1748,34}}, color=
          {0,127,255}));
  connect(collector__HEXVAL_140.port_a1, collector__HEXVAL_142.port_a1)
    annotation (Line(points={{1748,34},{1730,34},{1730,134},{1748,134}}, color=
          {0,127,255}));
  connect(collector__HEXVAL_142.port_a1, collector__HEXVAL_144.port_a1)
    annotation (Line(points={{1748,134},{1730,134},{1730,234},{1748,234}},
        color={0,127,255}));
  connect(collector__HEXVAL_144.port_a1, collector__HEXVAL_146.port_a1)
    annotation (Line(points={{1748,234},{1730,234},{1730,334},{1748,334}},
        color={0,127,255}));
  connect(collector__HEXVAL_146.port_a1, collector__HEXVAL_148.port_a1)
    annotation (Line(points={{1748,334},{1730,334},{1730,434},{1748,434}},
        color={0,127,255}));
  connect(collector__HEXVAL_148.port_a1, collector__HEXVAL_150.port_a1)
    annotation (Line(points={{1748,434},{1730,434},{1730,534},{1748,534}},
        color={0,127,255}));
  connect(collector__HEXVAL_150.port_a1, collector__HEXVAL_152.port_a1)
    annotation (Line(points={{1748,534},{1730,534},{1730,634},{1748,634}},
        color={0,127,255}));
  connect(collector__HEXVAL_152.port_a1, collector__HEXVAL_154.port_a1)
    annotation (Line(points={{1748,634},{1728,634},{1728,734},{1748,734}},
        color={0,127,255}));
  connect(collector__HEXVAL_154.port_a1, collector__HEXVAL_156.port_a1)
    annotation (Line(points={{1748,734},{1728,734},{1728,834},{1748,834}},
        color={0,127,255}));
  connect(collector__HEXVAL_156.port_a1, collector__HEXVAL_158.port_a1)
    annotation (Line(points={{1748,834},{1728,834},{1728,934},{1748,934}},
        color={0,127,255}));
  connect(collector__HEXVAL_158.port_b1, collector__HEXVAL_156.port_b1)
    annotation (Line(points={{1768,934},{1778,934},{1778,834},{1768,834}},
        color={0,127,255}));
  connect(collector__HEXVAL_156.port_b1, collector__HEXVAL_154.port_b1)
    annotation (Line(points={{1768,834},{1778,834},{1778,734},{1768,734}},
        color={0,127,255}));
  connect(collector__HEXVAL_154.port_b1, collector__HEXVAL_152.port_b1)
    annotation (Line(points={{1768,734},{1780,734},{1780,634},{1768,634}},
        color={0,127,255}));
  connect(collector__HEXVAL_152.port_b1, collector__HEXVAL_150.port_b1)
    annotation (Line(points={{1768,634},{1780,634},{1780,534},{1768,534}},
        color={0,127,255}));
  connect(collector__HEXVAL_150.port_b1, collector__HEXVAL_148.port_b1)
    annotation (Line(points={{1768,534},{1780,534},{1780,434},{1768,434}},
        color={0,127,255}));
  connect(collector__HEXVAL_148.port_b1, collector__HEXVAL_146.port_b1)
    annotation (Line(points={{1768,434},{1780,434},{1780,334},{1768,334}},
        color={0,127,255}));
  connect(collector__HEXVAL_146.port_b1, collector__HEXVAL_144.port_b1)
    annotation (Line(points={{1768,334},{1780,334},{1780,234},{1768,234}},
        color={0,127,255}));
  connect(collector__HEXVAL_144.port_b1, collector__HEXVAL_142.port_b1)
    annotation (Line(points={{1768,234},{1780,234},{1780,134},{1768,134}},
        color={0,127,255}));
  connect(collector__HEXVAL_142.port_b1, collector__HEXVAL_140.port_b1)
    annotation (Line(points={{1768,134},{1780,134},{1780,34},{1768,34}}, color=
          {0,127,255}));
  connect(collector__HEXVAL_140.port_b1, collector__HEXVAL_138.port_b1)
    annotation (Line(points={{1768,34},{1780,34},{1780,-66},{1768,-66}}, color=
          {0,127,255}));
  connect(collector__HEXVAL_138.port_b1, collector__HEXVAL_136.port_b1)
    annotation (Line(points={{1768,-66},{1780,-66},{1780,-166},{1768,-166}},
        color={0,127,255}));
  connect(collector__HEXVAL_136.port_a1, collector__Heating_collector.port_b2)
    annotation (Line(points={{1748,-166},{1730,-166},{1730,-224},{1749,-224}},
        color={0,127,255}));
  connect(collector__HEXVAL_136.port_b1, collector__Heating_collector.port_a2)
    annotation (Line(points={{1768,-166},{1780,-166},{1780,-224},{1769,-224}},
        color={0,127,255}));
  connect(collector__Heating_collector.port_a1, port_a) annotation (Line(points=
         {{1749,-236},{1750,-236},{1750,-278},{-240,-278},{-240,-480}}, color={
          0,127,255}));
  connect(port_b, collector__Heating_collector.port_b1) annotation (Line(points=
         {{-110,-480},{-116,-480},{-116,-356},{1769,-356},{1769,-236}}, color={
          0,127,255}));
  connect(ExprPEl_Bhps.y, Pnet.u[3]) annotation (Line(points={{-279,-40},{-262,
          -40},{-262,9.33333},{-242,9.33333}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{-56,-26},{-56,-92},{-12,-92},{-12,-46},{10,-46},{10,-92},{56,
              -92},{56,-26},{0,14},{-56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-56,-26},{-66,-34},{-72,-26},{0,26},{72,-26},{68,-34},{56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-44,-46},{-26,-46},{-26,-64},{-44,-64},{-44,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{24,-46},{42,-46},{42,-64},{24,-64},{24,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-10,-14},{8,-14},{8,-32},{-10,-32},{-10,-14}},
          color={244,125,35},
          thickness=0.5),
        Polygon(
          points={{6,24},{64,-18},{64,-16},{6,26},{6,24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,32},{76,32},{84,30},{86,26},{86,22},{86,18},{80,18},{80,22},
              {80,24},{76,26},{56,26},{56,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,32},{72,32},{72,40},{76,38},{76,42},{66,42},{66,38},{70,40},
              {70,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,16},{82,12},{82,10},{84,8},{86,10},{86,12},{84,16}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-40,20}},
          textColor={0,0,0},
          textStyle={TextStyle.Italic},
          textString="12"),
        Polygon(
          points={{84,-40},{90,-40},{84,-54},{92,-54},{78,-80},{84,-58},{76,-58},
              {84,-40}},
          lineColor={0,0,0},
          fillColor={244,221,46},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-680,-480},{420,380}})));
end DeSchipjes;
