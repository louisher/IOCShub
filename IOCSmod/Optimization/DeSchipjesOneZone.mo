within IOCSmod.Optimization;
model DeSchipjesOneZone
extends IOCSmod.Optimization.Interface;
  output Real test=enerHub.AsChi.AsChi.EER;
  Blocks.Demand.Clusters.DeSchipjesOneZone buildings(
                                                    addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Blocks.EnergyHub.GeneralHub    enerHub(
    addDummyEquation=addDummyEquation,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBor_flow_nominal=enerHub.GsHp.borFieDat.conDat.mBorFie_flow_nominal/
            enerHub.GsHp.borFieDat.conDat.nBor,
        dp_nominal(displayUnit="Pa"))))
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));
equation
  connect(bou.ports[1], enerHub.port_a) annotation (Line(points={{8,8},{8,-14},
          {-24,-14},{-24,0}}, color={0,127,255}));
  connect(enerHub.port_a, buildings.port_b) annotation (Line(points={{-24,0},{
          -24,-20},{44,-20},{44,0}}, color={0,127,255}));
  connect(enerHub.port_b, buildings.port_a) annotation (Line(points={{-36,0},{
          -36,-28},{56,-28},{56,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DeSchipjesOneZone;
