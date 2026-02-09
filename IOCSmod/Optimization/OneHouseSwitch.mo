within IOCSmod.Optimization;
model OneHouseSwitch
  extends IOCSmod.Optimization.Interface;
  Blocks.Demand.SingleBuildings.OneHouse buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Blocks.EnergyHub.SwitchingFramework enerHub(addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));


equation
  connect(bou.ports[1], enerHub.port_a) annotation (Line(points={{8,8},{8,-14},{
          -24,-14},{-24,0}}, color={0,127,255}));
  connect(buildings.port_b, enerHub.port_a) annotation (Line(points={{44,0},{44,
          -24},{-24,-24},{-24,0}}, color={0,127,255}));
  connect(enerHub.port_b, buildings.port_a) annotation (Line(points={{-36,0},{
          -38,0},{-38,-30},{56,-30},{56,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OneHouseSwitch;
