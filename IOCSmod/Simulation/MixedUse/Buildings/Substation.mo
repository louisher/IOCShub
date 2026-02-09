within IOCSmod.Simulation.MixedUse.Buildings;
model Substation
   extends IOCSmod.Simulation.MixedUse.Buildings.PartialSubstation(isDH=true,
    nRadPorts=0,
    nConvPorts=0);
  redeclare package Medium = IDEAS.Media.Water;
  parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";

  // PI controller parameters
  parameter Real k=0.8;
  parameter Real Ti=3000;

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_nominal = 4184 "Specific heat capacity of water";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_dh= sum(Q_design)/cp_nominal/3 "Nominal mass flow rate coming from dhc net (maximum T variation of +-3°C)";

  // Heat Pump
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_eva= m_flow_nom_dh "Nominal mass flow rate at the evaporator side";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_con= floHea1.m_flow_nominal+floHea2.m_flow_nominal "Nominal mass flow rate at the condenser side (or at cold side of HExCool)";
  parameter Modelica.Units.SI.PressureDifference dp_nom_eva=20000 "Nominal pressure drop at the evaporator side";
  parameter Modelica.Units.SI.PressureDifference dp_nom_con=20000 "Nominal pressure drop at the condenser side";

  // Floor Heating
  parameter Modelica.Units.SI.TemperatureDifference dTFloHea_nom=5 "Nominal temperature difference in floor heating";

  // Three Way Valves
  //parameter Real Kv_TWValves=6.3;
  //final parameter Modelica.Units.SI.PressureDifference dp_nom_TWvalFH=(m_flow_nom_con/(threeWayValFh.Kv*1000/3600/sqrt(1E5)))^2;
  //final parameter Modelica.Units.SI.PressureDifference dp_nom_TWvalSelSup=(m_flow_nom_dh/(threeWayValSelSup.Kv*1000/3600/sqrt(1E5)))^2;

  //Final
  parameter Modelica.Units.SI.PressureDifference dp_nominal = dp_nom_eva "Nominal pressure drop of the HVAC block seen by the central pump";

  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_design[1]/dTFloHea_nom/cp_nominal,
    dp_nominal=1000,
    A_floor=A_floor[1])    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-130,-20})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-140,78})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_design[2]/dTFloHea_nom/cp_nominal,
    dp_nominal=1000,
    A_floor=A_floor[2])
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-160,0})));
  UnitTests.Components.TwoWayLinear   valFloHea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea1.m_flow_nominal,
    Kv=5,
    dpValve_nominal=10000)             annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={-130,30})));
  UnitTests.Components.TwoWayLinear   valFloHea2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea2.m_flow_nominal,
    Kv=5,
    dpValve_nominal=10000)             annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={-160,30})));
  IDEAS.Fluid.Movers.FlowControlled_dp pumCon(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nom_con,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    use_inputFilter=false,
    dp_nominal=floHea1.dp_nominal + valFloHea1.dpValve_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,-60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEmIn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_con,
    tau=0) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-110,60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEmOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_con,
    tau=0) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-110,-60})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) if isDH "Supply water connection to the DH grid"
    annotation (Placement(transformation(extent={{210,50},{230,70}}),
        iconTransformation(extent={{210,50},{230,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) if isDH "Return water connection to the DH grid"
    annotation (Placement(transformation(extent={{210,-70},{230,-50}}),
        iconTransformation(extent={{210,-70},{230,-50}})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness
                                      hexCool(
    redeclare package Medium1 = IDEAS.Media.Water,
    redeclare package Medium2 = IDEAS.Media.Water,
    m1_flow_nominal=m_flow_nom_con,
    m2_flow_nominal=m_flow_nom_dh,
    dp1_nominal=0,
    dp2_nominal=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_hexCool_primOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_nom_dh,
    tau=0) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-10,-60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_hexCool_primIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_nom_dh,
    tau=0) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-10,60})));
  UnitTests.Components.TwoWayLinear valHex(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_nom_dh,
    Kv=5,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=180,
        origin={40,60})));
  IDEAS.Controls.Continuous.LimPID conPiHea1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMin=0)
    annotation (Placement(transformation(extent={{-172,134},{-152,154}})));
  IDEAS.Controls.Continuous.LimPID conPiCoo1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-132,134},{-112,154}})));
  Modelica.Blocks.Logical.Switch valveSwitch1
    annotation (Placement(transformation(extent={{-92,134},{-72,154}})));
  IDEAS.Controls.Continuous.LimPID conPiHea2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMin=0)
    annotation (Placement(transformation(extent={{-172,96},{-152,116}})));
  IDEAS.Controls.Continuous.LimPID conPiCoo2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-132,96},{-112,116}})));
  Modelica.Blocks.Logical.Switch valveSwitch2
    annotation (Placement(transformation(extent={{-92,96},{-72,116}})));
  IDEAS.Controls.Continuous.LimPID conPiHeaValve(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{120,114},{100,134}})));
  IDEAS.Controls.Continuous.LimPID conPiCoo3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
    annotation (Placement(transformation(extent={{160,114},{140,134}})));
  Modelica.Blocks.Logical.Switch valveSwitch3
    annotation (Placement(transformation(extent={{76,114},{56,134}})));
  Modelica.Blocks.Interfaces.BooleanInput coolingOn
    "Connector of Boolean input signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  IDEAS.Controls.SetPoints.Table heatingCurve(table=[273.15 - 10,273.15 + 45; 273.15
         + 5,273.15 + 40; 273.15 + 20,273.15 + 25])
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{48,80},{68,102}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=TEmIn.T)
    annotation (Placement(transformation(extent={{196,90},{176,68}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=if TFloOk.y then 10
         + 273.15 else 18 + 273.15)
    annotation (Placement(transformation(extent={{196,136},{176,114}})));

  Modelica.Blocks.Logical.Hysteresis TFloorCheck1(
    uLow=17 + 273.125,
    uHigh=17.5 + 273.15,
    pre_y_start=true)
    annotation (Placement(transformation(extent={{180,198},{200,220}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=floHea1.heatPortEmb[
        1].T)
    annotation (Placement(transformation(extent={{10,11},{-10,-11}},
        rotation=180,
        origin={152,209})));
  Modelica.Blocks.Logical.Hysteresis TFloorCheck2(
    uLow=17,
    uHigh=17.5,
    pre_y_start=true)
    annotation (Placement(transformation(extent={{180,158},{200,180}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=floHea2.heatPortEmb[
        1].T)
    annotation (Placement(transformation(extent={{10,11},{-10,-11}},
        rotation=180,
        origin={152,169})));
  Modelica.Blocks.Logical.And TFloOk
    annotation (Placement(transformation(extent={{220,180},{240,200}})));
equation
  connect(valFloHea2.port_b,floHea2. port_a)
    annotation (Line(points={{-160,22},{-160,10}},
                                                 color={0,127,255}));
  connect(valFloHea1.port_b,floHea1. port_a)
    annotation (Line(points={{-130,22},{-130,-10}},
                                                  color={0,127,255}));
  connect(valFloHea2.port_a, TEmIn.port_b) annotation (Line(points={{-160,38},{
          -160,60},{-116,60}},
                          color={0,127,255}));
  connect(valFloHea1.port_a, TEmIn.port_b) annotation (Line(points={{-130,38},{
          -130,60},{-116,60}},
                          color={0,127,255}));
  connect(floHea2.port_b, TEmOut.port_a) annotation (Line(points={{-160,-10},{
          -160,-60},{-116,-60}},
                            color={0,127,255}));
  connect(TEmOut.port_a, floHea1.port_b) annotation (Line(points={{-116,-60},{
          -130,-60},{-130,-30}},
                            color={0,127,255}));
  connect(bou.ports[1], TEmIn.port_b) annotation (Line(points={{-140,72},{-140,
          60},{-116,60}},
                      color={0,127,255}));
  connect(floHea2.heatPortEmb[1], heatPortEmb[2]) annotation (Line(points={{-170,
          0},{-180,0},{-180,60},{-200,60}}, color={191,0,0}));
  connect(floHea1.heatPortEmb[1], heatPortEmb[1]) annotation (Line(points={{-140,
          -20},{-180,-20},{-180,60},{-200,60}}, color={191,0,0}));
  connect(TEmOut.port_b, pumCon.port_a)
    annotation (Line(points={{-104,-60},{-78,-60}}, color={0,127,255}));
  connect(pumCon.port_b, hexCool.port_a1) annotation (Line(points={{-58,-60},{-46,
          -60},{-46,-10}}, color={0,127,255}));
  connect(hexCool.port_b1, TEmIn.port_a)
    annotation (Line(points={{-46,10},{-46,60},{-104,60}}, color={0,127,255}));
  connect(hexCool.port_b2, T_hexCool_primOut.port_a) annotation (Line(points={{-34,
          -10},{-34,-60},{-16,-60}}, color={0,127,255}));
  connect(T_hexCool_primOut.port_b, port_b)
    annotation (Line(points={{-4,-60},{220,-60}}, color={0,127,255}));
  connect(hexCool.port_a2, T_hexCool_primIn.port_b)
    annotation (Line(points={{-34,10},{-34,60},{-16,60}}, color={0,127,255}));
  connect(port_a, valHex.port_a)
    annotation (Line(points={{220,60},{48,60}}, color={0,127,255}));
  connect(valHex.port_b, T_hexCool_primIn.port_a)
    annotation (Line(points={{32,60},{-4,60}}, color={0,127,255}));
  connect(TSensor[1], conPiHea1.u_m) annotation (Line(points={{-204,-60},{-228,-60},
          {-228,126},{-162,126},{-162,132}}, color={0,0,127}));
  connect(conPiHea1.u_m, conPiCoo1.u_m) annotation (Line(points={{-162,132},{-162,
          126},{-122,126},{-122,132}}, color={0,0,127}));
  connect(TSet[1], conPiHea1.u_s) annotation (Line(points={{20,-109},{20,-86},{-228,
          -86},{-228,144},{-174,144}}, color={0,0,127}));
  connect(conPiCoo1.u_s, conPiHea1.u_s) annotation (Line(points={{-134,144},{-144,
          144},{-144,162},{-174,162},{-174,144}}, color={0,0,127}));
  connect(TSensor[2], conPiHea2.u_m) annotation (Line(points={{-204,-60},{-250,-60},
          {-250,88},{-162,88},{-162,94}}, color={0,0,127}));
  connect(conPiCoo2.u_m, conPiHea2.u_m) annotation (Line(points={{-122,94},{-122,
          88},{-162,88},{-162,94}}, color={0,0,127}));
  connect(TSet[2], conPiHea2.u_s) annotation (Line(points={{20,-99},{-270,-99},{
          -270,106},{-174,106}}, color={0,0,127}));
  connect(conPiCoo2.u_s, conPiHea2.u_s) annotation (Line(points={{-134,106},{-144,
          106},{-144,124},{-174,124},{-174,106}}, color={0,0,127}));
  connect(valveSwitch1.u2, valveSwitch2.u2) annotation (Line(points={{-94,144},{
          -104,144},{-104,106},{-94,106}}, color={255,0,255}));
  connect(conPiCoo1.y, valveSwitch1.u1) annotation (Line(points={{-111,144},{-110,
          144},{-110,152},{-94,152}}, color={0,0,127}));
  connect(conPiCoo2.y, valveSwitch2.u1) annotation (Line(points={{-111,106},{-111,
          114},{-94,114}}, color={0,0,127}));
  connect(conPiHea1.y, valveSwitch1.u3) annotation (Line(points={{-151,144},{-146,
          144},{-146,130},{-94,130},{-94,136}}, color={0,0,127}));
  connect(conPiHea2.y, valveSwitch2.u3) annotation (Line(points={{-151,106},{-146,
          106},{-146,90},{-94,90},{-94,98}}, color={0,0,127}));
  connect(valveSwitch1.y, valFloHea1.y) annotation (Line(points={{-71,144},{-50,
          144},{-50,30},{-120.4,30}}, color={0,0,127}));
  connect(valveSwitch2.y, valFloHea2.y) annotation (Line(points={{-71,106},{-66,
          106},{-66,42},{-150.4,42},{-150.4,30}}, color={0,0,127}));
  connect(valveSwitch1.u2, coolingOn) annotation (Line(points={{-94,144},{-104,144},
          {-104,162},{0,162},{0,120}}, color={255,0,255}));
  connect(valveSwitch3.u2, coolingOn) annotation (Line(points={{78,124},{88,124},
          {88,160},{0,160},{0,120}}, color={255,0,255}));
  connect(conPiHeaValve.y, valveSwitch3.u3) annotation (Line(points={{99,124},{90,
          124},{90,116},{78,116}}, color={0,0,127}));
  connect(realExpression.y, heatingCurve.u)
    annotation (Line(points={{69,91},{70,90},{78,90}}, color={0,0,127}));
  connect(heatingCurve.y, conPiHeaValve.u_s) annotation (Line(points={{101,90},{
          128,90},{128,124},{122,124}}, color={0,0,127}));
  connect(realExpression1.y, conPiHeaValve.u_m)
    annotation (Line(points={{175,79},{110,79},{110,112}}, color={0,0,127}));
  connect(realExpression1.y, conPiCoo3.u_m)
    annotation (Line(points={{175,79},{150,79},{150,112}}, color={0,0,127}));
  connect(conPiCoo3.y, valveSwitch3.u1) annotation (Line(points={{139,124},{134,
          124},{134,144},{84,144},{84,134},{78,134},{78,132}}, color={0,0,127}));
  connect(realExpression2.y, conPiCoo3.u_s)
    annotation (Line(points={{175,125},{175,124},{162,124}}, color={0,0,127}));
  connect(valveSwitch3.y, valHex.y)
    annotation (Line(points={{55,124},{40,124},{40,69.6}}, color={0,0,127}));
  connect(realExpression3.y, TFloorCheck1.u) annotation (Line(points={{163,209},
          {163,208},{178,208},{178,209}}, color={0,0,127}));
  connect(realExpression4.y, TFloorCheck2.u) annotation (Line(points={{163,169},
          {163,168},{178,168},{178,169}}, color={0,0,127}));
  connect(TFloorCheck1.y, TFloOk.u1) annotation (Line(points={{201,209},{210,
          209},{210,190},{218,190}}, color={255,0,255}));
  connect(TFloorCheck2.y, TFloOk.u2) annotation (Line(points={{201,169},{210,
          169},{210,182},{218,182}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{220,100}})),  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-100},{220,100}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Substation;
