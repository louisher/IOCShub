within IOCSmod.ComponentModels.Verification;
model OneHouseVerGsHp
  extends IOCSmod.Optimization.Interface;

  Blocks.Demand.SingleBuildings.OneHouse buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-84,16})));
  Thermal.GsHp GsHp(
    addDummyEquation=addDummyEquation,
                    hasReg=false,
    TBorMin=273.15)
    annotation (Placement(transformation(extent={{-54,-2},{-34,18}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=0.1,
    nPorts=5) annotation (Placement(transformation(extent={{-14,0},{6,20}})));
equation
  connect(GsHp.port_a, vol.ports[1]) annotation (Line(points={{-38,-2},{-38,-6},
          {-7.2,-6},{-7.2,0}}, color={0,127,255}));
  connect(GsHp.port_b, vol.ports[2]) annotation (Line(points={{-50,-2},{-50,-12},
          {-5.6,-12},{-5.6,0}}, color={0,127,255}));
  connect(buildings.port_a, vol.ports[3]) annotation (Line(points={{46,0},{46,
          -20},{-4,-20},{-4,0}}, color={0,127,255}));
  connect(buildings.port_b, vol.ports[4]) annotation (Line(points={{34,0},{34,
          -16},{-6,-16},{-6,0},{-2.4,0}}, color={0,127,255}));
  connect(bou1.ports[1], vol.ports[5]) annotation (Line(points={{-84,6},{-82,6},
          {-82,-30},{-0.8,-30},{-0.8,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OneHouseVerGsHp;
