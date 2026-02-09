within IOCSmod.Blocks.Demand.SingleBuildings;
model OneHouse
    extends IOCSmod.Blocks.Demand.SingleBuildings.BaseClasses.OneHouseBase(
  redeclare IOCSmod.Demand.BuildingModels.TwoZone House1);


  IDEAS.Fluid.Movers.FlowControlled_dp pumNetwork(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=House1.subStation.m1_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    use_inputFilter=false,
    dp_nominal=20000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,-60})));
  UnitTests.Confidential.TwoWayLinear val1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=House1.subStation.m1_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=2,
    addDummyEquation=addDummyEquation,
    dT_nom_water=5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-8,0})));
equation
  connect(port_a, pumNetwork.port_a)
    annotation (Line(points={{60,-100},{60,-60},{30,-60}}, color={0,127,255}));
  connect(pumNetwork.port_b, val1.port_a)
    annotation (Line(points={{10,-60},{-8,-60},{-8,-10}}, color={0,127,255}));
  connect(val1.port_b, House1.port_a) annotation (Line(points={{-8,10},{-10,10},
          {-10,24},{-48,24},{-48,40}}, color={0,127,255}));
  connect(House1.port_b, port_b) annotation (Line(points={{-52,40},{-52,26},{
          -60,26},{-60,-100}}, color={0,127,255}));
  connect(House1.P, P) annotation (Line(points={{-61,44.6},{-80,44.6},{-80,90},
          {-110,90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OneHouse;
