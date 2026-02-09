within IOCSmod.Demand.BuildingModels;
model TwoZone "Optimisation model for a two-zone residential building: 
  Building: Two-zone building from Ina De Jaegher's building envelope collection
  SH: via substation and district heating network
  SC: No SC
  DHW: via substatino and district heating network
  Hydraulics: radiator in DayZone and NightZone
  Electricity: PV + connection to grid + profile"
  extends IOCSmod.Demand.BuildingModels.TwoZoneBase;

  /* Main components */

  IDEAS.Fluid.Movers.FlowControlled_dp pum(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=subStation.m2_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    use_inputFilter=false,
    dp_nominal=dp_nominal)
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,-140})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water,
    p=pum.dp_nominal,
    nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-120,-160})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSupSH1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea1.m_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TRetSH1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea1.m_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{30,0},{50,20}})));

  UnitTests.Confidential.TwoWayLinear valSH1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea1.m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=2,
    addDummyEquation=addDummyEquation)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,10})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_flow_nominal/2/4180/7.5,
    dp_nominal=10000,
    A_floor=bui.AZones[1])
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  UnitTests.Confidential.TwoWayLinear valSH2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea2.m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=2,
    addDummyEquation=addDummyEquation)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-30})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSupSH2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea2.m_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_flow_nominal/2/4180/7.5,
    dp_nominal=10000,
    A_floor=bui.AZones[2])
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TRetSH2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea2.m_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  IDEAS.Fluid.FixedResistances.Junction junSupSH(
    m_flow_nominal={valSH1.m_flow_nominal + valSH2.m_flow_nominal,valSH1.m_flow_nominal,
        valSH2.m_flow_nominal},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-120,-30})));

  IDEAS.Fluid.FixedResistances.Junction junRetSH(
    m_flow_nominal={valSH1.m_flow_nominal,valSH1.m_flow_nominal + valSH2.m_flow_nominal,
        valSH2.m_flow_nominal},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-30})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSupSubSt(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=subStation.m2_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{-30,-150},{-50,-130}})));
  UnitTests.Components.CounterFlowHEX
                                    subStation(
    redeclare package Medium1 = IDEAS.Media.Water,
    redeclare package Medium2 = IDEAS.Media.Water,
    m1_flow_nominal=Q_flow_nominal/5/4180,
    m2_flow_nominal=Q_flow_nominal/5/4180,
    dp1_nominal=7500,
    dp2_nominal=7500,
    UA=Q_flow_nominal/2)
    annotation (Placement(transformation(extent={{-10,-150},{10,-170}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TRetSubSt(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=subStation.m2_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{50,-150},{30,-130}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSupNetwork(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=subStation.m1_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{-50,-190},{-30,-170}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TRetNetwork(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=subStation.m1_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{32,-190},{52,-170}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-70,-230},{-50,-210}}),
    iconTransformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-30,-230},{-10,-210}}),
    iconTransformation(extent={{10,-110},{30,-90}})));

  /* Set points and real expressions */

  IDEAS.Fluid.FixedResistances.Junction junSup(
    m_flow_nominal={subStation.m2_flow_nominal,valSH1.m_flow_nominal +
        valSH2.m_flow_nominal,bhp.m_flow_nominalEva},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-120,-70})));
  IDEAS.Fluid.FixedResistances.Junction junRet(
    m_flow_nominal={valSH1.m_flow_nominal + valSH2.m_flow_nominal,
        subStation.m2_flow_nominal,bhp.m_flow_nominalEva},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    redeclare package Medium = IDEAS.Media.Water) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-70})));


  ComponentModels.Thermal.Bhp             bhp(Kv=2) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-6,-112})));
equation

  connect(valSH1.port_b, TSupSH1.port_a)
    annotation (Line(points={{-40,10},{-30,10}},color={0,127,255}));
  connect(floHea1.port_b, TRetSH1.port_a)
    annotation (Line(points={{20,10},{30,10}}, color={0,127,255}));
  connect(floHea1.port_a, TSupSH1.port_b)
    annotation (Line(points={{0,10},{-10,10}}, color={0,127,255}));
  connect(junSupSH.port_2, valSH1.port_a) annotation (Line(points={{-120,-20},{-120,
          10},{-60,10}},   color={0,127,255}));
  connect(TRetSH1.port_b, junRetSH.port_1) annotation (Line(points={{50,10},{80,
          10},{80,-20}},   color={0,127,255}));
  connect(TRetSH2.port_b, junRetSH.port_3)
    annotation (Line(points={{50,-30},{70,-30}},  color={0,127,255}));
  connect(junSupSH.port_3, valSH2.port_a)
    annotation (Line(points={{-110,-30},{-60,-30}},color={0,127,255}));
  connect(valSH2.port_b, TSupSH2.port_a)
    annotation (Line(points={{-40,-30},{-30,-30}},
                                                color={0,127,255}));
  connect(TSupSH2.port_b, floHea2.port_a)
    annotation (Line(points={{-10,-30},{0,-30}}, color={0,127,255}));
  connect(floHea2.port_b, TRetSH2.port_a)
    annotation (Line(points={{20,-30},{30,-30}}, color={0,127,255}));
  connect(pum.port_a, TSupSubSt.port_b)
    annotation (Line(points={{-70,-140},{-50,-140}}, color={0,127,255}));
  connect(TSupSubSt.port_a, subStation.port_b2) annotation (Line(points={{-30,-140},
          {-20,-140},{-20,-154},{-10,-154}},
                                          color={0,127,255}));
  connect(subStation.port_a2, TRetSubSt.port_b) annotation (Line(points={{10,-154},
          {20,-154},{20,-140},{30,-140}}, color={0,127,255}));
  connect(TSupNetwork.port_b, subStation.port_a1) annotation (Line(points={{-30,
          -180},{-20,-180},{-20,-166},{-10,-166}},
                                          color={0,127,255}));
  connect(TSupNetwork.port_a, port_a) annotation (Line(points={{-50,-180},{-60,-180},
          {-60,-220}}, color={0,127,255}));
  connect(subStation.port_b1, TRetNetwork.port_a) annotation (Line(points={{10,-166},
          {20,-166},{20,-180},{32,-180}}, color={0,127,255}));
  connect(TRetNetwork.port_b, port_b) annotation (Line(points={{52,-180},{60,-180},
          {60,-200},{-20,-200},{-20,-220}},color={0,127,255}));

  connect(floHea1.heatPortEmb[1], bui.heatPortEmb[1]) annotation (Line(points={{
          10,20},{12,20},{12,66},{-26,66}}, color={191,0,0}));
  connect(floHea2.heatPortEmb[1], bui.heatPortEmb[2]) annotation (Line(points={{
          10,-20},{6,-20},{6,66},{-26,66}}, color={191,0,0}));
  connect(pum.port_b, bou.ports[1]) annotation (Line(points={{-90,-140},{-120,-140},
          {-120,-150}}, color={0,127,255}));
  connect(junSup.port_2, junSupSH.port_1)
    annotation (Line(points={{-120,-60},{-120,-40}}, color={0,127,255}));
  connect(junRetSH.port_2, junRet.port_1)
    annotation (Line(points={{80,-40},{80,-60}}, color={0,127,255}));
  connect(junSup.port_3, bhp.port_a) annotation (Line(points={{-110,-70},{-10,
          -70},{-10,-102}},color={0,127,255}));
  connect(bhp.port_b, junRet.port_3) annotation (Line(points={{-2,-102},{-2,-70},
          {70,-70}},      color={0,127,255}));
  connect(junSup.port_1, pum.port_b) annotation (Line(points={{-120,-80},{-120,
          -140},{-90,-140}}, color={0,127,255}));
  connect(TRetSubSt.port_a, junRet.port_2) annotation (Line(points={{50,-140},
          {80,-140},{80,-80}}, color={0,127,255}));
  connect(bhp.PEl, Pnet.u[3]) annotation (Line(points={{-2,-123},{-2,-130},{102,
          -130},{102,72},{121.333,72}}, color={0,0,127}));
  connect(applianceHeatGains.heatPortRad, bui.heatPortRad) annotation (Line(
        points={{20,68},{-8,68},{-8,58},{-26,58}}, color={191,0,0}));
  connect(applianceHeatGains.heatPortCon, bui.heatPortCon) annotation (Line(
        points={{20,72},{-12,72},{-12,62},{-26,62}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Line(
          points={{-56,-26},{-56,-92},{-12,-92},{-12,-46},{10,-46},{10,-92},{56,
              -92},{56,-26},{0,14},{-56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-56,-26},{-66,-34},{-72,-26},{0,26},{72,-26},{68,-34},{56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-44,-46},{-26,-46},{-26,-64},{-44,-64},{-44,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{24,-46},{42,-46},{42,-64},{24,-64},{24,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-10,-14},{8,-14},{8,-32},{-10,-32},{-10,-14}},
          color={244,125,35},
          thickness=0.5),
        Polygon(
          points={{6,24},{64,-18},{64,-16},{6,26},{6,24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,32},{76,32},{84,30},{86,26},{86,22},{86,18},{80,18},{80,22},
              {80,24},{76,26},{56,26},{56,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,32},{72,32},{72,40},{76,38},{76,42},{66,42},{66,38},{70,40},
              {70,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,16},{82,12},{82,10},{84,8},{86,10},{86,12},{84,16}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-40,20}},
          textColor={0,0,0},
          textStyle={TextStyle.Italic},
          textString="2"),
        Polygon(
          points={{84,-40},{90,-40},{84,-54},{92,-54},{78,-80},{84,-58},{76,-58},
              {84,-40}},
          lineColor={0,0,0},
          fillColor={244,221,46},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{140,
            160}})),
    Documentation(revisions="<html>
<ul>
<li>June 21, 2024, by Lucas Verleyen:<br>
Initial implementation.</li>
</ul>
</html>"));
end TwoZone;
