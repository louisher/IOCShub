within IOCSmod.Optimization;
model DeSchipjes
  extends IOCSmod.Optimization.Interface(sim(n50=buildings.Houses.n50, incAndAziInBus={{IDEAS.Types.Tilt.Ceiling,0},{IDEAS.Types.Tilt.Wall,buildings.Houses.downAngle},{IDEAS.Types.Tilt.Wall,buildings.Houses.leftAngle},{IDEAS.Types.Tilt.Wall,buildings.Houses.upAngle},{IDEAS.Types.Tilt.Wall,buildings.Houses.rightAngle}, {IDEAS.Types.Tilt.Floor,0}},
  interZonalAirFlowType=IDEAS.BoundaryConditions.Types.InterZonalAirFlow.OnePort));

  Blocks.Demand.Clusters.DeSchipjes            buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  IOCSmod.Blocks.EnergyHub.GeneralHub enerHub(addDummyEquation=addDummyEquation,
      borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBor_flow_nominal=enerHub.GsHp.borFieDat.conDat.mBorFie_flow_nominal/
            enerHub.GsHp.borFieDat.conDat.nBor,
        dp_nominal(displayUnit="Pa"))),
    optSel_PVT=true,
    sysConfig_PVT=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));
equation
  connect(bou.ports[1], enerHub.port_a) annotation (Line(points={{8,8},{8,-14},{
          -24,-14},{-24,0}}, color={0,127,255}));
  connect(enerHub.port_b, buildings.port_a) annotation (Line(points={{-36,0},{-36,
          -40},{56,-40},{56,0}}, color={0,127,255}));
  connect(buildings.port_b, enerHub.port_a) annotation (Line(points={{44,0},{44,
          -28},{-24,-28},{-24,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DeSchipjes;
