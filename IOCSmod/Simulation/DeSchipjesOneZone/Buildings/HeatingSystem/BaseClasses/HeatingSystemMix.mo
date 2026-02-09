within IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem.BaseClasses;
model HeatingSystemMix
  "Partial optimisation model of the building heating system"
  extends
    IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem.BaseClasses.HeatingSystemSh;

  final parameter Modelica.Units.SI.ThermalResistance RTanDhw=Modelica.Math.log((rTan
       + dIns)/rTan)/(2*Modelica.Constants.pi*kIns*hTan)
    "Thermal resistance of the DHW storage tank";

  Modelica.Blocks.Interfaces.RealInput mDHW(
    final quantity="MassFlowRate",
    unit="kg/s",
    displayUnit="kg/s",
    min=0) annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={220,70})));
  IDEAS.Fluid.Sources.Boundary_pT bouDhw(redeclare package Medium = Medium,
      nPorts=1)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,90})));
  IDEAS.Fluid.MixingVolumes.MixingVolume tankDhw(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    T_start=318.15,
    m_flow_nominal=m_flow_nom_bhp_con + m_flow_nom_dhw,
    V=VTan,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,20})));
  UnitTests.Components.HeatPump_WaterWater   bhp(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=300*Medium.d_const/1000/3600,
    m2_flow_nominal=400*Medium.d_const/1000/3600,
    dp_nominalEva=0,
    dp_nominalCon=0,
    dT_max=7.60,
    copDef=3.87,
    coeffEva={-301.4,0.08046},
    coeffCon={-328.15,-0.07626},
    con(from_dp=false))                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,60})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort TBhpEvaIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_bhp_eva,
    tau=0)
    annotation (Placement(transformation(extent={{-45,65},{-35,75}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow     pumpBhp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nom_bhp_con,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Sources.RealExpression TSensorExpression(y=TSensor[1])
    annotation (Placement(transformation(extent={{170,-40},{150,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSensorPrescribedTemperature
    annotation (Placement(transformation(extent={{145,-35},{135,-25}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resTankDhw(R=RTanDhw)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={130,-10})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TBhpEvaOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_bhp_eva,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-26,40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TBhpConIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_bhp_con,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-3,35},{-13,45}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TBhpConOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_bhp_con,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-5,65},{5,75}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Qdhw annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={130,50})));
  Modelica.Blocks.Math.Gain gain(k=-Medium.d_const/1000*Medium.cp_const*(38 -
        10))
    annotation (Placement(transformation(extent={{170,60},{150,80}})));
equation
  QdhwUsed =-Qdhw.Q_flow;

  connect(TBhpEvaIn.port_b, bhp.port_a1)
    annotation (Line(points={{-35,70},{-26,70}}, color={0,127,255}));
  connect(TSensorPrescribedTemperature.T, TSensorExpression.y)
    annotation (Line(points={{146,-30},{149,-30}}, color={0,0,127}));
  connect(resTankDhw.port_b, tankDhw.heatPort)
    annotation (Line(points={{130,0},{130,20}},           color={191,0,0}));
  connect(bouDhw.ports[1], pumpBhp.port_b)
    annotation (Line(points={{100,80},{100,70},{30,70}}, color={0,127,255}));
  connect(bhp.port_b1, TBhpEvaOut.port_a)
    annotation (Line(points={{-26,50},{-26,45}}, color={0,127,255}));
  connect(pumpBhp.port_a, TBhpConOut.port_b)
    annotation (Line(points={{10,70},{5,70}}, color={0,127,255}));
  connect(bhp.port_b2, TBhpConOut.port_a)
    annotation (Line(points={{-14,70},{-5,70}}, color={0,127,255}));
  connect(bhp.port_a2, TBhpConIn.port_b)
    annotation (Line(points={{-14,50},{-14,40},{-13,40}}, color={0,127,255}));
  connect(mDHW, gain.u)
    annotation (Line(points={{220,70},{172,70}}, color={0,0,127}));
  connect(Qdhw.Q_flow, gain.y)
    annotation (Line(points={{130,60},{130,70},{149,70}}, color={0,0,127}));
  connect(Qdhw.port, tankDhw.heatPort)
    annotation (Line(points={{130,40},{130,20}}, color={191,0,0}));
  connect(resTankDhw.port_a, TSensorPrescribedTemperature.port)
    annotation (Line(points={{130,-20},{130,-30},{135,-30}}, color={191,0,0}));
  connect(TBhpEvaOut.port_b, pumpSec.port_a) annotation (Line(points={{-26,35},
          {-26,-70},{-20,-70}}, color={0,127,255}));
  connect(pumpBhp.port_b, tankDhw.ports[1])
    annotation (Line(points={{30,70},{120,70},{120,30}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}})), Icon(coordinateSystem(extent={{-200,-100},
            {200,100}})),
    experiment(
      StopTime=36000,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end HeatingSystemMix;
