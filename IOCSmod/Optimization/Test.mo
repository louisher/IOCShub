within IOCSmod.Optimization;
model Test

  extends IOCSmod.Optimization.Interface;

  Blocks.EnergyHub.GeneralHub enerHub(
    addDummyEquation=addDummyEquation,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBor_flow_nominal=enerHub.GsHp.borFieDat.conDat.mBorFie_flow_nominal/
            enerHub.GsHp.borFieDat.conDat.nBor,
        dp_nominal(displayUnit="Pa"))),
    isRev_ashp=true)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));


  IDEAS.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=10,
    nPorts=2) annotation (Placement(transformation(extent={{40,0},{60,20}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=2,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=true,
    use_inputFilter=false,
    dp_nominal=10000)
    annotation (Placement(transformation(extent={{-10,-62},{10,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{10,34},{30,54}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=230000,
    width=50,
    period=7200,
    offset=-230000)
    annotation (Placement(transformation(extent={{-30,34},{-10,54}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTVolIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=2,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={24,-52})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTVolOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=2,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={24,-26})));
  IDEAS.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=2,
    dp_nominal=10000)
    annotation (Placement(transformation(extent={{-36,-62},{-16,-42}})));
equation
  connect(bou.ports[1], enerHub.port_a) annotation (Line(points={{8,8},{8,-14},{
          -24,-14},{-24,0}}, color={0,127,255}));


  connect(prescribedHeatFlow.port, vol.heatPort) annotation (Line(points={{30,44},
          {34,44},{34,10},{40,10}}, color={191,0,0}));
  connect(pulse.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-9,44},{10,44}}, color={0,0,127}));
  connect(pum.port_b, senTVolIn.port_a)
    annotation (Line(points={{10,-52},{18,-52}}, color={0,127,255}));
  connect(senTVolIn.port_b, vol.ports[1])
    annotation (Line(points={{30,-52},{48,-52},{48,0}}, color={0,127,255}));
  connect(senTVolOut.port_a, vol.ports[2])
    annotation (Line(points={{30,-26},{52,-26},{52,0}}, color={0,127,255}));
  connect(senTVolOut.port_b, enerHub.port_a)
    annotation (Line(points={{18,-26},{-24,-26},{-24,0}}, color={0,127,255}));
  connect(pum.port_a, res.port_b)
    annotation (Line(points={{-10,-52},{-16,-52}}, color={0,127,255}));
  connect(res.port_a, enerHub.port_b)
    annotation (Line(points={{-36,-52},{-36,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=300,
      __Dymola_Algorithm="Dassl"));
end Test;
