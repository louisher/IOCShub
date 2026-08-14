within IOCSmod.Optimization;
model TestSimple
  extends IOCSmod.Optimization.Interface;

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
  ComponentModels.Thermal.SimpleTank tan(
    addDummyEquation=false,
    m_flow_nominal=1,
    VTan=0.5,
    nPorts=4,
    redeclare replaceable package Medium = IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-96,18},{-76,38}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHeaOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-146,24})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHeaIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=2,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-144,-18})));
  Modelica.Blocks.Sources.CombiTimeTable pulse(
    fileName=Modelica.Utilities.Files.loadResource("pulseHea.txt"),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-16,36},{-2,50}})));
  ComponentModels.Thermal.AsHp AsHp(addDummyEquation=false, Qnom_AsHp=300000)
    annotation (Placement(transformation(extent={{-178,-2},{-198,18}})));
equation


  connect(prescribedHeatFlow.port, vol.heatPort) annotation (Line(points={{30,44},
          {34,44},{34,10},{40,10}}, color={191,0,0}));
  connect(pum.port_b, senTVolIn.port_a)
    annotation (Line(points={{10,-52},{18,-52}}, color={0,127,255}));
  connect(senTVolIn.port_b, vol.ports[1])
    annotation (Line(points={{30,-52},{48,-52},{48,0}}, color={0,127,255}));
  connect(senTVolOut.port_a, vol.ports[2])
    annotation (Line(points={{30,-26},{52,-26},{52,0}}, color={0,127,255}));
  connect(pum.port_a, res.port_b)
    annotation (Line(points={{-10,-52},{-16,-52}}, color={0,127,255}));
  connect(tan.ports[1], res.port_a) annotation (Line(points={{-89,18},{-82,18},
          {-82,-50},{-36,-50},{-36,-52}}, color={0,127,255}));
  connect(senTVolOut.port_b, tan.ports[2]) annotation (Line(points={{18,-26},{
          -87,-26},{-87,18}},                     color={0,127,255}));
  connect(bou.ports[1], senTVolOut.port_b) annotation (Line(points={{8,8},{10,8},
          {10,-16},{18,-16},{18,-26}}, color={0,127,255}));
  connect(senTHeaOut.port_b, tan.ports[3]) annotation (Line(points={{-140,24},{
          -114,24},{-114,14},{-85,14},{-85,18}}, color={0,127,255}));
  connect(pulse.y[1], prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-1.3,43},{-1.3,44},{10,44}}, color={0,0,127}));
  connect(senTHeaIn.port_b, AsHp.port_a) annotation (Line(points={{-150,-18},{
          -194,-18},{-194,-2}}, color={0,127,255}));
  connect(AsHp.port_b, senTHeaOut.port_a) annotation (Line(points={{-182,-2},{
          -182,-8},{-168,-8},{-168,24},{-152,24}}, color={0,127,255}));
  connect(senTHeaIn.port_a, tan.ports[4]) annotation (Line(points={{-138,-18},{
          -83,-18},{-83,18}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=300,
      __Dymola_Algorithm="Dassl"));
end TestSimple;
