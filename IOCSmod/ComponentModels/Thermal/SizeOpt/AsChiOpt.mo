within IOCSmod.ComponentModels.Thermal.SizeOpt;
model AsChiOpt "Model of a air-source chiller with optimized size parameter:
  The EER parameters of the chiller are determined using the calibration script in IOCS/Datasheets/TacoCalibration.py and are based on the GALETTI MPE013H0AA"
  extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface;

  // parameters:
  parameter input Real Size "Heat pump size in kW" annotation(Dialog(group="Optimal sizing"));
  parameter input Real Size_nominal "Nominal HP sizei in kW, used for calculating nominal mass flow rates" annotation(Dialog(group="Optimal sizing"));

  // investemnt
  parameter Real inv_cost(fixed=false, start=0) "Investment cost per unit of Size (€/kW)" annotation(Dialog(group="Investment cost"));
  parameter Real interest_rate(fixed=false, start=0) annotation(Dialog(group="Investment cost"));
  parameter Integer lifetime(fixed=false, start=0) "Lifetime in years" annotation(Dialog(group="Investment cost"));
  parameter Integer observation_time(fixed=false, start=0) "Observation time in years" annotation(Dialog(group="Investment cost"));

  parameter Modelica.Units.SI.PressureDifference dp_nominalEva(displayUnit="Pa")=
       10000 "Pressure difference at evaporator (water side)";
  parameter Real EERDef = 3.99 "Default EER";
  parameter Modelica.Units.SI.Temperature TAir_nominal = 25 + 273.15 "Nominal air temperature for EER calculation";
  parameter Modelica.Units.SI.Temperature TEvaOut_nominal = 7 + 273.15 "Nominal evaporater leaving temperature for EER calculation";
  parameter Real coeffEva = 0.106641 "Linearisation coefficient of evaporator leaving temperature in EER calculation";
  parameter Real coeffCon = -0.0998334 "Linearisation coefficient of air temperature in EER calculation";

  UnitTests.Confidential.FlowControlled_m_flow pumpHpAir(
    inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_aschi_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominalEva)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,-40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsChiEvaIn(
    redeclare package Medium = Medium,
    m_flow_nominal=AsChi.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-20,0})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsChiEvaOut(
    redeclare package Medium = Medium,
    m_flow_nominal=AsChi.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,20})));
  AirSourceChillers.Chiller_AirWaterOpt                              AsChi(
    redeclare package MediumWater = Medium,
    EERDef=EERDef,
    TAir_nominal=TAir_nominal,
    TEvaOut_nominal=TEvaOut_nominal,
    coeffEva=coeffEva,
    coeffCon=coeffCon,
    m1_flow_nominal=m_flow_aschi_nominal,
    dp_nominalEva=dp_nominalEva,
    dp_nominalCon(displayUnit="Pa"),
    addDummyEquation=addDummyEquation)
                               annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,10})));
  Modelica.Blocks.Sources.RealExpression ExprTamb(y=sim.Te) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,20})));


  Modelica.Blocks.Sources.RealExpression exprPelAsChi(y=AsChi.PEl)
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Modelica.Blocks.Continuous.Integrator EAsChi_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Modelica.Blocks.Sources.RealExpression Expr_mFlowCon(y=Size*1000/4180/
        AsChi.dT_max)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,-20})));

  IOCSmod.ComponentModels.BaseClasses.Investment inv(inv_cost=inv_cost,
    interest_rate=interest_rate,
    lifetime=lifetime,
    observation_time=observation_time)
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

protected
    parameter Modelica.Units.SI.MassFlowRate m_flow_aschi_nominal = Size_nominal*1000/4180/AsChi.dT_max "Nominal mass flow rate at water side";
equation
  connect(port_a, pumpHpAir.port_a)
    annotation (Line(points={{60,-100},{60,-40},{20,-40}}, color={0,127,255}));
  connect(pumpHpAir.port_b, senTAsChiEvaIn.port_a) annotation (Line(points={{0,-40},
          {-40,-40},{-40,0},{-26,0}}, color={0,127,255}));
  connect(senTAsChiEvaOut.port_b, port_b) annotation (Line(points={{-26,20},{-60,
          20},{-60,-100}}, color={0,127,255}));
  connect(ExprTamb.y, AsChi.Tair)
    annotation (Line(points={{29,20},{24,20},{24,13},{20,13}},
                                                      color={0,0,127}));
  connect(AsChi.PEl, P)
    annotation (Line(points={{10,21},{10,90},{-110,90}}, color={0,0,127}));
  connect(exprPelAsChi.y, EAsChi_kWh.u)
    annotation (Line(points={{131,90},{138,90}}, color={0,0,127}));
  connect(senTAsChiEvaIn.port_b, AsChi.port_a)
    annotation (Line(points={{-14,0},{-4,0},{-4,4},{0,4}}, color={0,127,255}));
  connect(AsChi.port_b, senTAsChiEvaOut.port_a) annotation (Line(points={{0,16},
          {-8,16},{-8,20},{-14,20}}, color={0,127,255}));
  connect(Expr_mFlowCon.y, pumpHpAir.m_flow_in)
    annotation (Line(points={{25,-20},{10,-20},{10,-28}}, color={0,0,127}));
  annotation (defaultComponentName="AsChi", Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-74,35},{74,-35}},
          textColor={238,46,47},
          textString="CHI"),Text(
          extent={{-152,100},{148,140}},
          textColor={0,0,0},
          textString="%name")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AsChiOpt;
