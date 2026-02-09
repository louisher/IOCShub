within IOCSmod.BuildingEnvelopes.Asbergstraat_18;
model Asbergstraat_18_1574473
  Asbergstraat_18_1574473_Structure bui(useFluPor=false)
     annotation (Placement(transformation(extent={{-14,-10},{16,10}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-96,72},{-76,92}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=1)
    annotation(Placement(transformation(extent={{60, 30}, {40, 50}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=1)
    annotation(Placement(transformation(extent={{60, 10}, {40, 30}})));

equation
  connect(occ1.y, bui.occ[1]) annotation(Line(points={{39, 40}, {11, 40}, {11, 10}}, color={0, 0, 127}));
  connect(occ2.y, bui.occ[2]) annotation(Line(points={{39, 20}, {11, 20}, {11, 10}}, color={0, 0, 127}));

annotation(Icon(coordinateSystem(preserveAspectRatio=false), graphics={
  Line(points={{-70, 4}, {-70, -86}, {-16, -86}, {-16, -30}, {16, -30}, {16, -86}, {70, -86}, {70, 4}, {0, 74}, {-70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-70, 4}, {-76, -2}, {-88, -2}, {0, 86}, {88, -2}, {76, -2}, {70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-14, 28}, {14, 28}, {14, 0}, {-14, 0}, {-14, 28}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{30, -30}, {58, -30}, {58, -58}, {30, -58}, {30, -30}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-58, -30}, {-30, -30}, {-30, -58}, {-58, -58}, {-58, -30}}, color={244, 125, 35}, thickness=0.5)}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  experiment(StopTime=86000, __Dymola_Algorithm="Dassl"),
  Documentation(info="<html> 
 	<p>Q_design = QzoneDay kW (DayZone) &amp; QzoneNight kW (NightZone)</p> 
 	<p>UA_building = UAbuilding W/K</p> 
 	<p>Roof</p> 
 	<ul><li>Side1: Surface1 m2, tilt = Tilt1 rad (Tilt1deg &deg;)</li><li>Side2: Surface2 m2, tilt = Tilt2 rad (Tilt2deg &deg;)<br></li></ul> 
 	</html>", revisions="<html><ul><li>March 5, 2024, by Lucas Verleyen:<br> Remove mass flow sources and set useFluPor = false.<li>October 9, 2023, by Lucas Verleyen:<br> Initial implementation.</li></ul></html>"));
end Asbergstraat_18_1574473;
