within IOCSmod.ComponentModels.Thermal;
model BeoBooster "Model of a BeoBooster that uses warm waste water to regenerate a borefield"
  extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface(hasEl=false);

  parameter Boolean hasBeoBoo = true "Boolean to set turn BeoBooster on/off (true: On, false: off)";

  parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/<File>.txt") "File where matrix is stored";
  parameter Modelica.Units.SI.MassFlowRate m_flow_peak=0.13 "Peak mass flow rate of grey water";

  parameter Modelica.Units.SI.MassFlowRate m_flow_fix=0 "Fixed mass flow rate added to the profiles (can be used to represent e.g. washing machines)";

  parameter Modelica.Media.Interfaces.Types.Temperature TGrey=303.15
    "Temperature of the grey water";

    Modelica.Blocks.Sources.CombiTimeTable mFlow_profile(
    tableOnFile=true,
    tableName="data",
    fileName=fileName,
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));

  IDEAS.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=TGrey,
    nPorts=1) annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,0})));
  IDEAS.Fluid.Sources.Boundary_pT bou3(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,0})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hex(redeclare package
      Medium1 = Medium, redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_peak,
    m2_flow_nominal=m_flow_peak*2,
    dp1_nominal=10000,
    dp2_nominal=10000)
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGreyIn(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=hex.m1_flow_nominal,
    redeclare package Medium = Medium) "Inlet temperature of grey water"
                                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,0})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGreyOut(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=hex.m1_flow_nominal,
    redeclare package Medium = Medium)
    "Inlet temperature of grey water" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,0})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexIn(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=hex.m2_flow_nominal,
    redeclare package Medium = Medium) "Inlet temperature of grey water"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={30,-40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexOut(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=hex.m2_flow_nominal,
    redeclare package Medium = Medium) "Inlet temperature of grey water"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-40})));

  Modelica.Blocks.Sources.RealExpression mFlowGreyExprOn(y=mFlow_profile.y[1] +
        m_flow_fix)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.RealExpression mFlowHexExprOn(y=2*mFlowGreyExprOn.y)
    annotation (Placement(transformation(extent={{100,-52},{80,-32}})));

  UnitTests.Components.FlowControlled_m_flow pumHex(
  redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=hex.m2_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=hex.dp2_nominal) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-60})));
  Modelica.Blocks.Sources.RealExpression mFlowGreyExprOff(y=0.0001)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.RealExpression mFlowHexExprOff(y=2*mFlowGreyExprOff.y)
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
equation
  connect(boundary.ports[1], senTGreyIn.port_a) annotation (Line(points={{-50,-6.66134e-16},
          {-40,1.72085e-15}}, color={0,127,255}));
  connect(senTGreyIn.port_b, hex.port_a1)
    annotation (Line(points={{-20,-7.21645e-16},{-10,0}}, color={0,127,255}));
  connect(hex.port_b1, senTGreyOut.port_a)
    annotation (Line(points={{10,0},{20,1.72085e-15}}, color={0,127,255}));
  connect(senTGreyOut.port_b, bou3.ports[1]) annotation (Line(points={{40,-7.21645e-16},
          {50,6.66134e-16}}, color={0,127,255}));
  connect(senTHexIn.port_b, hex.port_a2)
    annotation (Line(points={{20,-40},{10,-40},{10,-12}}, color={0,127,255}));
  connect(hex.port_b2, senTHexOut.port_b) annotation (Line(points={{-10,-12},{-10,
          -40},{-20,-40}}, color={0,127,255}));
  connect(senTHexOut.port_a, port_b) annotation (Line(points={{-40,-40},{-60,-40},
          {-60,-100}}, color={0,127,255}));

  connect(pumHex.port_b, senTHexIn.port_a)
    annotation (Line(points={{60,-50},{60,-40},{40,-40}}, color={0,127,255}));
  connect(pumHex.port_a, port_a)
    annotation (Line(points={{60,-70},{60,-100}}, color={0,127,255}));

  if hasBeoBoo then
      connect(mFlowGreyExprOn.y, boundary.m_flow_in)
    annotation (Line(points={{-79,20},{-72,20},{-72,8}}, color={0,0,127}));
      connect(mFlowHexExprOn.y, pumHex.m_flow_in)
    annotation (Line(points={{79,-42},{72,-42},{72,-60}}, color={0,0,127}));
  else
      connect(mFlowGreyExprOff.y, boundary.m_flow_in)
    annotation (Line(points={{-79,-10},{-72,-10},{-72,8}}, color={0,0,127}));
  connect(mFlowHexExprOff.y, pumHex.m_flow_in)
    annotation (Line(points={{79,-70},{72,-70},{72,-60}}, color={0,0,127}));
  end if;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={                             Text(
          extent={{-140,62},{148,-112}},
          textColor={238,46,47},
          textString="BEO
BOOST
")}),                                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BeoBooster;
