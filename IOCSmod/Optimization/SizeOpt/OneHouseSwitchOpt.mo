within IOCSmod.Optimization.SizeOpt;
model OneHouseSwitchOpt
  extends IOCSmod.Optimization.Interface;
  Blocks.Demand.SingleBuildings.OneHouse buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  IOCSmod.Blocks.EnergyHub.SwitchingFrameworkOpt enerHub(addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));


equation
  connect(bou.ports[1], enerHub.port_a) annotation (Line(points={{8,8},{8,-14},{
          -24,-14},{-24,0}}, color={0,127,255}));
  connect(enerHub.port_a, buildings.port_b) annotation (Line(points={{-24,0},{
          -24,-20},{44,-20},{44,0}}, color={0,127,255}));
  connect(buildings.port_a, enerHub.port_b) annotation (Line(points={{56,0},{54,
          0},{54,-30},{-36,-30},{-36,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OneHouseSwitchOpt;
