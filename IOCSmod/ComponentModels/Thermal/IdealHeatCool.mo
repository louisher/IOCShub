within IOCSmod.ComponentModels.Thermal;
model IdealHeatCool
  extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface(hasEl=false);

    // Parameters
    parameter Modelica.Units.SI.HeatFlowRate Qnom_Hea "Nominal heat flow of heating";
    parameter Modelica.Units.SI.HeatFlowRate Qnom_Coo "Nominal heat flow of cooling";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
      "Nominal mass flow";

  IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=Qnom_Hea)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=-Qnom_Coo)
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  UnitTests.Confidential.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=hea.dp_nominal + coo.dp_nominal) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,0})));

  Modelica.Blocks.Interfaces.RealInput uHea(quantity="free",
      min=0,
      max=1,
      nominal=1/Qnom_Hea,
      start=0) "Control input of ideal heater" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={110,20})));
  Modelica.Blocks.Interfaces.RealInput uCoo(quantity="free",
      min=0,
      max=1,
      nominal=1/Qnom_Coo,
      start=0) "Control input of ideal cooler" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={110,60})));

equation
  connect(port_a, pum.port_a)
    annotation (Line(points={{60,-100},{60,0},{50,0}}, color={0,127,255}));
  connect(pum.port_b, hea.port_a)
    annotation (Line(points={{30,0},{10,0}}, color={0,127,255}));
  connect(hea.port_b, coo.port_a)
    annotation (Line(points={{-10,0},{-30,0}}, color={0,127,255}));
  connect(coo.port_b, port_b)
    annotation (Line(points={{-50,0},{-60,0},{-60,-100}}, color={0,127,255}));
  connect(coo.u, uCoo) annotation (Line(points={{-28,6},{-18,6},{-18,60},{110,60}},
        color={0,0,127}));
  connect(hea.u, uHea)
    annotation (Line(points={{12,6},{12,20},{110,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{0,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{0,-100}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-74,58},{76,-44}},
          textColor={255,255,255},
          textString="IDEAL")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealHeatCool;
