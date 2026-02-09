within IOCSmod.ComponentModels.Electrical;
model ACLoad
  "Model that loads an electricity profile from a .txt-file and can be connected to an AC grid"
  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power", unit="W") annotation (
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression actPowExpr(y = occSim.occBus.elecPowAct) annotation (
    Placement(transformation(extent = {{-62, -10}, {-42, 10}})));
  outer BoundaryConditions.Occupancy.OccSimInfoManager             occSim
    annotation (Placement(transformation(extent={{-96,72},{-76,94}})));
equation
  connect(actPowExpr.y, P)
    annotation (Line(points={{-41,0},{102,0}}, color={0,0,127}));
  annotation (
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)),
    Icon(coordinateSystem(preserveAspectRatio = false), graphics={  Rectangle(lineColor = {131, 131, 131}, fillColor = {239, 239, 239},
            fillPattern =                                                                                                                             FillPattern.Solid,
            lineThickness =                                                                                                                                                              1, extent = {{-100, 100}, {100, -100}}), Polygon(lineColor = {0, 127, 127}, fillColor = {230, 230, 230},
            fillPattern =                                                                                                                                                                                                        FillPattern.Backward,
            lineThickness =                                                                                                                                                                                                        0.5, points = {{-80, -20}, {-72, -20}, {-72, -40}, {-64, -40}, {-64, -60}, {-54, -60}, {-54, 34}, {-46, 34}, {-46, -30}, {-36, -30}, {-36, -42}, {-28, -42}, {-28, -76}, {-18, -76}, {-18, -54}, {-10, -54}, {-10, -42}, {2, -42}, {2, -2}, {10, -2}, {10, 64}, {14, 64}, {14, 30}, {22, 30}, {22, -30}, {32, -30}, {32, -50}, {42, -50}, {42, 4}, {54, 4}, {54, -80}, {-80, -80}, {-80, -20}}), Line(points = {{-80, 80}, {-80, -80}}, color = {28, 108, 200}, thickness = 1), Polygon(origin = {-80, 84}, rotation = 270, lineColor = {28, 108, 200}, fillColor = {28, 108, 200},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid,
            lineThickness =                                                                                                                                                                                                        1, points = {{10, 4}, {-2, 1.46957e-15}, {10, -4}, {10, 4}}), Line(points = {{60, -80}, {-80, -80}}, color = {28, 108, 200}, thickness = 1), Polygon(origin = {70, -80}, rotation = 180, lineColor = {28, 108, 200}, fillColor = {28, 108, 200},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid,
            lineThickness =                                                                                                                                                                                                        1, points = {{10, 4}, {-2, 1.46957e-15}, {10, -4}, {10, 4}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html>
  <p>Model that loads an electricity power profile from a .txt-file, translates the 
  power into an AC profile and can be connected to an AC grid through the AC connector.</p></html>", revisions="<html><ul>
<li>August 6, 2024, by Lucas Verleyen:<br>
Add duplicate in TACO library and change occSim manager to TACO equivalent model.</li>
<li> August 1, 2023, by Lucas Verleyen:<br>
Add quantity=\"Power\" and unit=\"W\" to RealOutput. (see <a href=\"https://gitlab.kuleuven.be/positive-energy-districts/moped/-/issues/112\">#112</a>)</li>
<li>February 27, 2023, by Louis Hermans:<br>Addition of OccSimInfoManager and use it as load input (see issue <a href=\"https://gitlab.kuleuven.be/positive-energy-districts/moped/-/issues/91\">#91</a>).</li>
<li>January 19, 2023, by Lucas Verleyen:<br/>
  Initial implementation</li></ul></html>"));
end ACLoad;
