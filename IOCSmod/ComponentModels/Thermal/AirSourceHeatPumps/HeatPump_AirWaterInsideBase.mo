within IOCSmod.ComponentModels.Thermal.AirSourceHeatPumps;
model HeatPump_AirWaterInsideBase
extends IDEAS.Fluid.Interfaces.PartialFourPortInterface;

  parameter Modelica.Units.SI.PressureDifference dp_nominalEva=55000
    "Pressure difference at evaporator"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominalCon=0
    "Pressure difference at condenser"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.TemperatureDifference dT_max=5
    "Maximum temperature difference across condenser";
  parameter Modelica.Units.SI.TemperatureDifference dT_maxSca=dT_max
    "Maximum temperature difference for scaling"
    annotation (Dialog(tab="Scaling"), Evaluate=true);

   parameter Real copDef = 5.8854 "Default COP";
  parameter Modelica.Units.SI.Temperature TAir_nominal = 12.59 + 273.15 "Nominal air temperature for COP calculation";
  parameter Modelica.Units.SI.Temperature TConOut_nominal = 34.3714 +273.15 "Nominal condensor leaving temperature for COP calculation";
  parameter Real coeffEva = 0.1537 "Linearisation coefficient of air temperature in COP calculation";
  parameter Real coeffCon = -0.1421 "Linearisation coefficient of leaving condensor temperature in COP calculation";

  parameter Boolean use_onIn = false "=true, to enable boolean on signal";
  parameter Real deltaM1 = 0.1
    "Fraction of nominal flow rate where condenser flow transitions to laminar"
    annotation(Dialog(tab="Flow resistance"));
   parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where evaporator flow transitions to laminar"
    annotation(Dialog(tab="Flow resistance"));

  IDEAS.Fluid.HeatExchangers.HeaterCooler_u eva(
    redeclare package Medium = Medium1, Q_flow_nominal = 1,
    allowFlowReversal=allowFlowReversal1, deltaM = deltaM1,
    dp_nominal=dp_nominalEva,energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial, from_dp = true,
    m_flow_nominal=m1_flow_nominal, tau = 300)
                            "Heat pump evaporator" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-18,60})));

  Modelica.Blocks.Sources.RealExpression Q_eva(final y=if on_internal then -
        QCon*(copDef - 1)/copDef else 0)
    "Evaporator thermal power - assumes COP of 4 to avoid algebraic loops"
    annotation (Placement(transformation(extent={{84,62},{24,82}})));
  Modelica.Blocks.Sources.RealExpression COPExp(
    final y=max(1, copDef  + coeffCon*(TConOut.T - TConOut_nominal) + coeffEva*(TEvaIn.T - TAir_nominal)))
    "Heat pump COP"
    annotation (Placement(transformation(extent={{84,74},{24,94}})));
  Modelica.Blocks.Sources.RealExpression P_HP(final y=if on_internal then QCon/
        COP else 0)
    "Electrical power use of heat pump based on linearisation around 10/25C"
    annotation (Placement(transformation(extent={{84,86},{24,106}})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_u con(
    redeclare package Medium = Medium2, Q_flow_nominal = 1,
    allowFlowReversal=allowFlowReversal2, deltaM = deltaM2,dp_nominal=dp_nominalCon,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial, from_dp = true,
    m_flow_nominal=m2_flow_nominal, tau = 300)         "Heat pump condenser" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-60})));

  Modelica.Blocks.Interfaces.RealOutput PEl
    "Electrical power use of the compressor" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,0})));
  Modelica.Blocks.Interfaces.RealInput mod
    "Condenser power modulation" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,0})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEvaOut(
    m_flow_nominal=eva.m_flow_nominal,
    tau=0,
    redeclare package Medium = Medium1,
    allowFlowReversal=allowFlowReversal1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,60})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort TConOut(
    tau=0,
    m_flow_nominal=con.m_flow_nominal,
    redeclare package Medium = Medium2,
    allowFlowReversal=allowFlowReversal2) "Outlet temperature at condenser"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-50,-60})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTemConIn(
    tau=0,
    m_flow_nominal=con.m_flow_nominal,
    redeclare package Medium = Medium2,
    allowFlowReversal=allowFlowReversal2) "Outlet temperature at condenser"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-60})));
  // smooth approximation of maximum of condenser inlet and outlet temperature
  // using maximum for convergence reasons
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEvaIn(
    m_flow_nominal=eva.m_flow_nominal,
    tau=0,
    redeclare package Medium = Medium1,
    allowFlowReversal=allowFlowReversal1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,60})));
  Modelica.Blocks.Sources.RealExpression Q_con(final y=if on_internal then QCon
         else 0)
    annotation (Placement(transformation(extent={{100,-30},{40,-10}})));

  Modelica.Units.SI.MassFlowRate smoothMin=UnitTests.Confidential.smoothMin2(
      m1_flow,
      m2_flow,
      10);
  Modelica.Blocks.Interfaces.BooleanInput on
    if use_onIn
    "On/off signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,110})));
  Modelica.Blocks.Interfaces.RealOutput QCon=mod*smoothMin*4180*dT_max annotation (
    Placement(visible = true, transformation(origin = {-20, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 270), iconTransformation(origin = {110, 29}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput COP "Coefficient of performance" annotation (
    Placement(visible = true, transformation(origin = {-60, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 270), iconTransformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput TCon "Condenser outlet temperature" annotation (
    Placement(visible = true, transformation(origin = {20, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 270), iconTransformation(origin = {110, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
protected
  Modelica.Blocks.Interfaces.BooleanInput on_internal "Internal on signal";

equation
  connect(on,on_internal);
  if not use_onIn then
    on_internal=true;
  end if;
  connect(P_HP.y, PEl)
    annotation (Line(points={{21,96},{0,96},{0,110}}, color={0,0,127}));
  connect(Q_eva.y, eva.u)
    annotation (Line(points={{21,72},{-30,72},{-30,66}}, color={0,0,127}));
  connect(con.port_b, TConOut.port_a)
    annotation (Line(points={{-10,-60},{-40,-60}}, color={0,127,255}));
  connect(TConOut.port_b, port_b2)
    annotation (Line(points={{-60,-60},{-100,-60}}, color={0,127,255}));
  connect(TEvaOut.port_a, eva.port_b)
    annotation (Line(points={{20,60},{-8,60}}, color={0,127,255}));
  connect(TEvaOut.port_b, port_b1)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(con.port_a, senTemConIn.port_b)
    annotation (Line(points={{10,-60},{40,-60}}, color={0,127,255}));
  connect(senTemConIn.port_a, port_a2)
    annotation (Line(points={{60,-60},{100,-60}}, color={0,127,255}));
  connect(eva.port_a, TEvaIn.port_b)
    annotation (Line(points={{-28,60},{-60,60}}, color={0,127,255}));
  connect(TEvaIn.port_a, port_a1)
    annotation (Line(points={{-80,60},{-100,60}}, color={0,127,255}));
  connect(Q_con.y, con.u)
    annotation (Line(points={{37,-20},{12,-20},{12,-54}}, color={0,0,127}));
  connect(COPExp.y, COP) annotation (
    Line(points={{21,84},{-60,84},{-60,110}},        color = {0, 0, 127}));
  connect(TConOut.T, TCon) annotation (
    Line(points={{-50,-49},{-50,0},{20,0},{20,110}},          color = {0, 0, 127}));
  annotation (
    Documentation(info="<html>
</html>"),
    Icon(graphics={  Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern =                                                                                                   FillPattern.Solid, extent = {{-70, 80}, {70, -80}}), Line(rotation = 90, points = {{-20, 0}, {40, 2.44929e-15}}, color = {255, 0, 0}, thickness = 0.5), Line(origin = {-1, -14}, rotation = 270, points = {{-14, 21}, {6, 1}, {-14, -23}}, color = {255, 0, 0}, thickness = 0.5), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{-99, -56}, {102, -66}}), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{-99, 64}, {102, 54}})}));
end HeatPump_AirWaterInsideBase;
