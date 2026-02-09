within IOCSmod.ComponentModels.Thermal;
model PvtReg
            "Model of a PVT-module that can be used for regeneration or regualar heating:
  Regular ports are used for heating, while the multiple ports are use for regeneration (port[1]: going to PVT, [2]: going back to borefield)"
    extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface(hasHyd=false);

  parameter Boolean optSel=false "Boolean to select wheter or not the choice between regeneration and heating has to be optimized";
  parameter Real selDefault= 1 "Default mode of PVT connection: 1=regeneration, 0=direct heating";

  parameter Modelica.Units.SI.Angle azi "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west-facing";
  parameter Modelica.Units.SI.Angle til "Surface tilt (0 for horizontally mounted collector)";
  parameter PvtMod.Data.GenericEN12975 per "Performance data";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer U_pvt=35 "Heat coefficient used in cell temperature calculation";
  parameter Modelica.Units.SI.Area totalArea  "Total area of panels in the simulation";
  parameter Modelica.Units.SI.Power P_STC=500 "Power of one photovoltaic panel at Standard Conditions, usually equal to power at Maximum Power Point (MPP)" annotation (Dialog(group="Electrical characteristics"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient gamma=-0.0037 "Temperature coefficient of the photovoltaic panel(s)" annotation (Dialog(group="Electrical characteristics"));
  parameter Modelica.Units.SI.Efficiency module_efficiency=0.3 "Module efficiency of the photovoltaic installation" annotation (Dialog(group="Electrical characteristics"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_pvt_nominal "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_pvt_nominal=if pumPvt.rho_default < 500 then 500 else 10000 "Nominal pressure raise of pvt pump";
  parameter Buildings.Fluid.SolarCollectors.Types.SystemConfiguration sysConfig = Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel "Selection of system configuration";
  parameter Buildings.Fluid.SolarCollectors.Types.NumberSelection nColType = Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area "Selection of area specification format";

  Modelica.Fluid.Interfaces.FluidPort_a port_aReg(redeclare package Medium=Medium) "Hydronic inlet port for borefield regeneration"
        annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bReg(redeclare package Medium=Medium) "Hydronic outlet port for borefield regeneration"
        annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

  PvtMod.Components.PVT_EN12975_TACO
                                pvt(
    redeclare package Medium = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40),
    nSeg=1,
    azi=azi,
    til=til,
    per=per,
    U_pvt=U_pvt,
    totalArea=totalArea,
    sysConfig=sysConfig,
    nColType=nColType,
    P_STC=P_STC,
    gamma=gamma,
    module_efficiency=module_efficiency,
    use_QMax=true)
    annotation (Placement(transformation(extent={{10,50},{-10,70}})));

  UnitTests.Confidential.FlowControlled_m_flow pumPvt(
    redeclare package Medium = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40),
    m_flow_nominal=m_flow_pvt_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    dp_nominal=dp_pvt_nominal,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{60,50},{40,70}})));

  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40),
    redeclare package Medium2 = IDEAS.Media.Water,     m1_flow_nominal=
        m_flow_pvt_nominal,
    m2_flow_nominal=m_flow_pvt_nominal,
                            dp1_nominal=1,
    dp2_nominal=1000)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  UnitTests.Confidential.FlowControlled_dp     pumPvtHex(
    redeclare package Medium = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40),
    m_flow_nominal=m_flow_pvt_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    dp_nominal=hex.dp2_nominal)
    annotation (Placement(transformation(extent={{62,4},{42,24}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPvtIn(
    redeclare package Medium = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40),
    m_flow_nominal=m_flow_pvt_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={22,60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPvtOut(
    redeclare package Medium = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40),
    m_flow_nominal=m_flow_pvt_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPvtHexIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_pvt_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={20,14})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPvtHexOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_pvt_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,14})));

  Modelica.Blocks.Math.Gain gain(k=-1) "Make electricity yield negative"
    annotation (Placement(transformation(extent={{-60,80},{-80,100}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPvtRegIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_pvt_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={124,-56})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPvtRegOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_pvt_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-12,-80})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a=0.40),
      nPorts=1)
    annotation (Placement(transformation(extent={{-46,68},{-36,78}})));

equation
  connect(senTPvtOut.port_a, pvt.port_b)
    annotation (Line(points={{-14,60},{-10.4,60}}, color={0,127,255}));
  connect(senTPvtIn.port_b, pvt.port_a)
    annotation (Line(points={{16,60},{10.4,60}}, color={0,127,255}));
  connect(senTPvtIn.port_a, pumPvt.port_b)
    annotation (Line(points={{28,60},{40,60}}, color={0,127,255}));
  connect(senTPvtHexIn.port_b, hex.port_a2)
    annotation (Line(points={{14,14},{10,14}}, color={0,127,255}));
  connect(senTPvtHexOut.port_a, hex.port_b2)
    annotation (Line(points={{-14,14},{-10,14}}, color={0,127,255}));
  connect(senTPvtOut.port_b, hex.port_a1) annotation (Line(points={{-26,60},{-42,
          60},{-42,26},{-10,26}}, color={0,127,255}));
  connect(hex.port_b1, pumPvt.port_a) annotation (Line(points={{10,26},{72,26},{
          72,60},{60,60}}, color={0,127,255}));
  connect(pumPvtHex.port_b, senTPvtHexIn.port_a)
    annotation (Line(points={{42,14},{26,14}}, color={0,127,255}));
  connect(gain.y, P)
    annotation (Line(points={{-81,90},{-110,90}}, color={0,0,127}));
  connect(gain.u, pvt.Pel) annotation (Line(points={{-58,90},{-52,90},{-52,53},{
          -11.2,53}}, color={0,0,127}));

  connect(senTPvtRegOut.port_b, port_bReg)
    annotation (Line(points={{-6,-80},{100,-80}}, color={0,127,255}));
  connect(port_a, port_a)
    annotation (Line(points={{60,-100},{60,-100}}, color={0,127,255}));
  connect(senTPvtRegIn.port_a, port_aReg) annotation (Line(points={{130,-56},{140,
          -56},{140,0},{100,0}}, color={0,127,255}));
  connect(bou.ports[1], senTPvtOut.port_b) annotation (Line(points={{-36,73},{-34,
          73},{-34,72},{-26,72},{-26,60}}, color={0,127,255}));
  connect(senTPvtRegIn.port_b, pumPvtHex.port_a) annotation (Line(points={{118,-56},
          {78,-56},{78,14},{62,14}}, color={0,127,255}));
  connect(senTPvtHexOut.port_b, senTPvtRegOut.port_a) annotation (Line(points={{
          -26,14},{-42,14},{-42,-80},{-18,-80}}, color={0,127,255}));
  annotation (defaultComponentName="pvt", Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={            Text(
          extent={{-150,100},{150,140}},
          textColor={0,0,0},
          textString="%name"),                                                                         Text(
          extent={{-72,35},{76,-35}},
          textColor={238,46,47},
          textString="PVT")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PvtReg;
