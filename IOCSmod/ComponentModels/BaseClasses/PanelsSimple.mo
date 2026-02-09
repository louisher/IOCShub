within IOCSmod.ComponentModels.BaseClasses;
partial model PanelsSimple
 extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface(final hasHyd=hasHea, final hasMulHyd=false);

  replaceable package MediumPanels =
      IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
        constrainedby Modelica.Media.Interfaces.PartialMedium
        "Medium in the agent hydronic system";
  //* General parameters
  parameter Boolean optSel=false "Boolean to select wheter or not the choice between regeneration and heating has to be optimized";
  parameter Boolean hasReg=true "Boolean to remove regeneration ports";
  parameter Boolean hasHea=true "Boolean to remove direct heating ports";
  parameter Real selDefault= 1 "Default mode of PVT connection: 1=regeneration, 0=direct heating";

  parameter Modelica.Units.SI.PressureDifference dp_Val_nominal=1000 "Nominal pressure drop of fully open valves in stc block" annotation (Dialog(group="General"));

  //* Panel Parameters
  parameter Integer nSeg=3
    "Number of segments used to discretize the collector model"
    annotation (Dialog(group="General"));
  parameter Modelica.Units.SI.Angle azi
    "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing"
    annotation (Dialog(group="General"));
  parameter Modelica.Units.SI.Angle til
    "Surface tilt (0 for horizontally mounted collector)"
    annotation (Dialog(group="General"));
  parameter Real rho "Ground reflectance" annotation (Dialog(group="General"));
  parameter input Modelica.Units.SI.Area totalArea=0
    "Total area of panels in the simulation" annotation (Dialog(group="General"));

  parameter Buildings.Fluid.SolarCollectors.Types.SystemConfiguration sysConfig=
     Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel
    "Selection of system configuration" annotation (Dialog(group="General"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Ambient temperature minus fluid temperature at nominal conditions"
    annotation (Dialog(group="Thermal"));
  parameter Modelica.Units.SI.TemperatureDifference dTMax=20
    "Maximum temperature difference across solar collector"
    annotation (Dialog(group="Thermal"));

  replaceable parameter Buildings.Fluid.SolarCollectors.Data.GenericEN12975 per
    constrainedby Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic
    "Performance data"
    annotation(Dialog(group="Thermal"), Placement(transformation(extent={{122,80},{142,100}})),
                                                                     choicesAllMatching=true);

  replaceable IOCSmod.ComponentModels.Thermal.SolarCollectors.EN12975 panels(redeclare
      package Medium = MediumPanels,
    nSeg=nSeg,
    azi=azi,
    til=til,
    rho=rho,
    final nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=totalArea,
    sysConfig=sysConfig,
    per=per,
    dT_nominal=dT_nominal,
    dTMax=dTMax)
    annotation (Dialog(group="Model", enable=false), Placement(transformation(extent={{12,50},{-8,70}})));

   IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumPanels,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_panels_nominal,
    m2_flow_nominal=m_flow_panels_nominal,
    dp1_nominal=1,
    dp2_nominal=1)
    annotation (Placement(transformation(extent={{-8,10},{12,30}})));

  UnitTests.Confidential.FlowControlled_m_flow pumPanels(
    redeclare package Medium = MediumPanels,
    m_flow_nominal=m_flow_panels_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    dp_nominal=dp_panels_nominal,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{60,50},{40,70}})));

  UnitTests.Confidential.FlowControlled_dp pumPanelHex(
    redeclare package Medium = MediumPanels,
    m_flow_nominal=m_flow_panels_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    dp_nominal=2*dp_Val_nominal)
    annotation (Placement(transformation(extent={{62,4},{42,24}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPanelsIn(
    redeclare package Medium = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40),
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={22,60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPanelsOut(
    redeclare package Medium = MediumPanels,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={20,14})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,14})));

  Modelica.Blocks.Interfaces.RealInput uSelPvt(
    quantity=if optSel then "free" else "",
    min=0,
    max=1,
    nominal=1/(m_flow_panels_nominal*4180*10),
    start=selDefault) if optSel
    "Selection variable between regeneration and direct heating: 1=regeneration, 0=direct heating" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  UnitTests.Components.TwoWayLinear valSupHea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    dpValve_nominal=dp_Val_nominal)
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-40})));
  UnitTests.Components.TwoWayLinear valRetHea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    dpValve_nominal=dp_Val_nominal)
                          annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-40})));
  Modelica.Blocks.Math.Feedback inverse
    annotation (Placement(transformation(extent={{-120,-49},{-100,-71}})));
  Modelica.Blocks.Sources.RealExpression ExprNom(y=1)
    "Expression to calculate inverse"
    annotation (Placement(transformation(extent={{-151,-70},{-131,-50}})));
  Modelica.Blocks.Sources.RealExpression ExprDefaultSelection(y=selDefault)
    "Expression to calculate inverse"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium = MediumPanels,
      nPorts=1)
    annotation (Placement(transformation(extent={{-46,68},{-36,78}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHeaIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={70,-70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHeaOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-70,-80})));

protected
  parameter Modelica.Units.SI.MassFlowRate m_flow_panels_nominal=panels.m_flow_nominal "Nominal mass flow rate in stc panels";
  parameter Modelica.Units.SI.PressureDifference dp_panels_nominal=panels.dp_nominal "Nominal pressure raise of stc pump";
  parameter Modelica.Units.SI.Area totalArea_nominal=0
    "Nominal area of STC, used for calculation of dp_nominal and m_flow_nominal" annotation (Dialog(group="General"));
equation
  connect(senTPanelsIn.port_a, pumPanels.port_b)
    annotation (Line(points={{28,60},{40,60}}, color={0,127,255}));
  connect(senTHexIn.port_b, hex.port_a2)
    annotation (Line(points={{14,14},{12,14}}, color={0,127,255}));
  connect(senTHexOut.port_a, hex.port_b2)
    annotation (Line(points={{-14,14},{-8,14}},  color={0,127,255}));
  connect(senTPanelsOut.port_b, hex.port_a1) annotation (Line(points={{-26,60},{
          -42,60},{-42,26},{-8,26}},  color={0,127,255}));
  connect(hex.port_b1, pumPanels.port_a) annotation (Line(points={{12,26},{72,26},
          {72,60},{60,60}}, color={0,127,255}));
  connect(pumPanelHex.port_b, senTHexIn.port_a)
    annotation (Line(points={{42,14},{26,14}}, color={0,127,255}));
  connect(valSupHea.port_b, pumPanelHex.port_a)
    annotation (Line(points={{80,-30},{80,14},{62,14}}, color={0,127,255}));
  connect(senTHexOut.port_b, valRetHea.port_a)
    annotation (Line(points={{-26,14},{-80,14},{-80,-30}}, color={0,127,255}));

  connect(inverse.y, valRetHea.y) annotation (Line(points={{-101,-60},{-98,-60},
          {-98,-40},{-92,-40}}, color={0,0,127}));
  connect(inverse.y, valSupHea.y) annotation (Line(points={{-101,-60},{60,-60},{
          60,-40},{68,-40}}, color={0,0,127}));
  connect(port_a, port_a)
    annotation (Line(points={{60,-100},{60,-100}}, color={0,127,255}));
  connect(bou.ports[1], senTPanelsOut.port_b) annotation (Line(points={{-36,73},
          {-34,73},{-34,72},{-26,72},{-26,60}}, color={0,127,255}));
  connect(senTPanelsIn.port_b,panels. port_a)
    annotation (Line(points={{16,60},{12,60}}, color={0,127,255}));
  connect(panels.port_b, senTPanelsOut.port_a)
    annotation (Line(points={{-8,60},{-14,60}}, color={0,127,255}));
  connect(valRetHea.port_b, senTHeaOut.port_a) annotation (Line(points={{-80,-50},
          {-80,-80},{-76,-80}}, color={0,127,255}));
  connect(senTHeaIn.port_b, valSupHea.port_a) annotation (Line(points={{76,-70},{80,-70},{80,-50}}, color={0,127,255}));

  connect(ExprNom.y, inverse.u1)
    annotation (Line(points={{-130,-60},{-118,-60}}, color={0,0,127}));
  if optSel then
    connect(uSelPvt, inverse.u2) annotation (Line(points={{-120,0},{-96,0},{-96,
            -34},{-110,-34},{-110,-51.2}}, color={0,0,127}));
  else
    connect(ExprDefaultSelection.y, inverse.u2) annotation (Line(points={{-99,30},
            {-96,30},{-96,-34},{-110,-34},{-110,-51.2}}, color={0,0,127}));
  end if;

  if hasHea then
    connect(senTHeaOut.port_b, port_b) annotation (Line(points={{-64,-80},{-60,-80},
            {-60,-100}}, color={0,127,255}));
    connect(port_a, senTHeaIn.port_a) annotation (Line(points={{60,-100},{60,-70},{64,-70}}, color={0,127,255}));
  else
    connect(senTHeaOut.port_b, senTHeaIn.port_a) annotation (Line(points={{-64,-80},
          {-60,-80},{-60,-70},{64,-70},{64,-70}}, color={0,127,255}));
  end if;

  if hasReg then
  else
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PanelsSimple;
