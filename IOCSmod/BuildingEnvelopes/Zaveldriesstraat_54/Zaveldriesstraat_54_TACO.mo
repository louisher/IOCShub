within IOCSmod.BuildingEnvelopes.Zaveldriesstraat_54;
model Zaveldriesstraat_54_TACO
  "Ventilation system to solve problem of InterzonalAirFlow"
  extends Zaveldriesstraat_54_1593993(
    sim(lineariseJModelica=true),
    bui(
      redeclare package Medium = IDEAS.Media.Specialized.DryAir,
      T_start=294.15,
      useFluPor=true),
    occ1(y=occSim.occBus.numOccAwake),
    occ2(y=occSim.occBus.numOccSleep));
  inner BNDF_5GDHC.BaseClasses.Occupancy.OccSimInfoManager occSim
    annotation (Placement(transformation(extent={{-72,72},{-52,94}})));
  Modelica.Fluid.Interfaces.FluidPort_a Sup(redeclare package Medium =
        IDEAS.Media.Water) if isDh "Supply water connection to the DH grid"
    annotation (Placement(transformation(extent={{94,14},{106,26}}),
        iconTransformation(extent={{94,14},{106,26}})));
  Modelica.Fluid.Interfaces.FluidPort_b Ret(redeclare package Medium =
        IDEAS.Media.Water) if isDh "Return water connection to the DH grid"
    annotation (Placement(transformation(extent={{94,-26},{106,-14}}),
        iconTransformation(extent={{94,-26},{106,-14}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Specialized.DryAir, nPorts=2)
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=90,
        origin={4,48})));
  IDEAS.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = IDEAS.Media.Specialized.DryAir,
    m_flow=0,
    nPorts=4) annotation (Placement(transformation(extent={{-26,14},{-10,30}})));
equation
  connect(boundary.ports[1:2], bui.port_b) annotation (Line(points={{-10,22.8},
          {-1,22.8},{-1,10}}, color={0,127,255}));
  connect(boundary.ports[3:4], bui.port_a)
    annotation (Line(points={{-10,19.6},{3,19.6},{3,10}}, color={0,127,255}));
  connect(bou.ports[1:2], bui.port_a) annotation (Line(points={{5.6,40},{5.6,
          23.2},{3,23.2},{3,10}}, color={0,127,255}));
end Zaveldriesstraat_54_TACO;
