within IOCSmod.Optimization.SizeOpt;
model Cluster10NaomiOpt
  extends IOCSmod.Optimization.Interface;
  output Real test=enerHub.AsChi.AsChi.EER;
  IOCSmod.Blocks.Demand.Clusters.Cluster10Naomi buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Blocks.EnergyHub.GeneralHubOpt enerHub(
    addDummyEquation=addDummyEquation,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBor_flow_nominal=enerHub.GsHp.borFieDat.conDat.mBorFie_flow_nominal/
            enerHub.GsHp.borFieDat.conDat.nBor,
        dp_nominal(displayUnit="Pa"))),
    sysConfig_STC=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));
equation
  connect(enerHub.port_a, buildings.port_a) annotation (Line(points={{-24,0},{-24,
          -20},{56,-20},{56,0}}, color={0,127,255}));
  connect(buildings.port_b, enerHub.port_b) annotation (Line(points={{44,0},{44,
          -40},{-36,-40},{-36,0}}, color={0,127,255}));
  connect(bou.ports[1], enerHub.port_a) annotation (Line(points={{8,8},{8,-14},
          {-24,-14},{-24,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cluster10NaomiOpt;
