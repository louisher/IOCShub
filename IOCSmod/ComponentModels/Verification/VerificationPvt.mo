within IOCSmod.ComponentModels.Verification;
model VerificationPvt
  extends IOCSmod.Optimization.Interface;

  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-62,-48})));
  Thermal.Pvt  pvt(
    addDummyEquation=addDummyEquation,
    hasReg=false,
    selDefault=0,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    dT_nominal=-10,
    redeclare IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.PVT_DualSun_Spring425_ShingleBlack per)
    annotation (Placement(transformation(extent={{-54,-2},{-34,18}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=50,
    nPorts=3) annotation (Placement(transformation(extent={{18,0},{38,20}})));
equation
  connect(pvt.port_a, vol.ports[1]) annotation (Line(points={{-38,-2},{-38,-12},
          {25.3333,-12},{25.3333,0}}, color={0,127,255}));
  connect(pvt.port_b, vol.ports[2]) annotation (Line(points={{-50,-2},{-50,-20},
          {28,-20},{28,0}}, color={0,127,255}));
  connect(bou1.ports[1], vol.ports[3]) annotation (Line(points={{-62,-58},{-18,
          -58},{-18,-60},{30.6667,-60},{30.6667,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VerificationPvt;
