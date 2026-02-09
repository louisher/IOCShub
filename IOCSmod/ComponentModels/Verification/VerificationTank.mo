within IOCSmod.ComponentModels.Verification;
model VerificationTank
  extends IOCSmod.Optimization.Interface;

  Blocks.Demand.SingleBuildings.OneHouse buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-84,16})));
  Thermal.AsHp AsHp(
    addDummyEquation=addDummyEquation, Qnom_AsHp=2000)
    annotation (Placement(transformation(extent={{-54,-2},{-34,18}})));
  Thermal.SimpleTank tan(
    addDummyEquation=false,
    m_flow_nominal=1,
    nPorts=5) annotation (Placement(transformation(extent={{-10,0},{10,20}})));
equation
  connect(AsHp.port_a, tan.ports[1]) annotation (Line(points={{-38,-2},{-38,-10},
          {-3.2,-10},{-3.2,0}}, color={0,127,255}));
  connect(tan.ports[2], AsHp.port_b) annotation (Line(points={{-1.6,0},{-1.6,
          -16},{-50,-16},{-50,-2}}, color={0,127,255}));
  connect(tan.ports[3], buildings.port_a) annotation (Line(points={{0,0},{2,0},
          {2,-24},{46,-24},{46,0}}, color={0,127,255}));
  connect(buildings.port_b, tan.ports[4]) annotation (Line(points={{34,0},{34,
          -14},{1.6,-14},{1.6,0}}, color={0,127,255}));
  connect(bou1.ports[1], tan.ports[5]) annotation (Line(points={{-84,6},{-84,
          -18},{-4,-18},{-4,0},{3.2,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VerificationTank;
