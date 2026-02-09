within IOCSmod.Demand.BuildingModels;
model StijnStreuvel
  extends IOCSmod.Demand.BuildingEnvelopes.StijnSBase;

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-250,-490},{-230,-470}}),
    iconTransformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-120,-490},{-100,-470}}),
    iconTransformation(extent={{10,-110},{30,-90}})));

  Modelica.Blocks.Interfaces.RealOutput P
    annotation(Placement(transformation(extent={{0,-10},{20,10}}),
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
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=P_AHUs_Schema_Sts)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Math.Sum Pnet(nin=2, k={1,1})
    annotation (Placement(visible = true, transformation(origin={-30,0},      extent = {{-10, -10}, {10, 10}}, rotation=0)));
equation
  connect(port_a, collector__Heating_collector.port_a1) annotation (Line(points=
         {{-240,-480},{-242,-480},{-242,-514},{408,-514},{408,362},{345,362},{345,
          334}}, color={0,127,255}));
  connect(collector__Heating_collector.port_b1, port_b) annotation (Line(points=
         {{365,334},{364,334},{364,338},{396,338},{396,-500},{-110,-500},{-110,-480}},
        color={0,127,255}));
  connect(realExpression.y, Pnet.u[1]) annotation (Line(points={{-79,20},{-60,
          20},{-60,-1},{-42,-1}}, color={0,0,127}));
  connect(P_appliances_profile.y[1], Pnet.u[2]) annotation (Line(points={{-79,
          -10},{-62,-10},{-62,1},{-42,1}}, color={0,0,127}));
  connect(Pnet.y, P)
    annotation (Line(points={{-19,0},{10,0}}, color={0,0,127}));
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
          textString="15"),
        Polygon(
          points={{84,-40},{90,-40},{84,-54},{92,-54},{78,-80},{84,-58},{76,-58},
              {84,-40}},
          lineColor={0,0,0},
          fillColor={244,221,46},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-680,-480},{420,380}})));
end StijnStreuvel;
