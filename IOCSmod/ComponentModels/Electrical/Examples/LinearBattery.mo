within IOCSmod.ComponentModels.Electrical.Examples;
model LinearBattery "Example for the LinearBattery component model"
  extends Modelica.Icons.Example;
  IOCSmod.ComponentModels.Electrical.LinearBattery linearBattery
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Sine sine(amplitude=5000, f=0.00001)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.RealExpression u_in(y=sine.y/linearBattery.P_max)
    annotation (Placement(transformation(extent={{-40,42},{-20,62}})));
equation
  connect(sine.y, linearBattery.PDem)
    annotation (Line(points={{-19,10},{-2,10}}, color={0,0,127}));
  connect(u_in.y, linearBattery.u)
    annotation (Line(points={{-19,52},{10,52},{10,22}}, color={0,0,127}));
  annotation (experiment(StopTime=860000, __Dymola_Algorithm="Dassl"));
end LinearBattery;
