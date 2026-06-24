within IOCSmod.ComponentModels.Thermal.SizeOpt;
model AsHpOpt "Model of a ASHP:
  The COP parameters of the heat pump are determined using the calibration script in IOCS/Datasheets/TacoCalibration.py and are based on the Viessmann VitoCal200A of 2024"
  extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface;

  // parameters:
  parameter input Real Size "Heat pump size in kW" annotation(Dialog(group="Optimal sizing"));
  parameter input Real Size_nominal "Nominal HP sizei in kW, used for calculating nominal mass flow rates" annotation(Dialog(group="Optimal sizing"));

  // investemnt
  parameter Real inv_cost(fixed=false, start=0) "Investment cost per unit of Size (€/kW)" annotation(Dialog(group="Investment cost"));
  parameter Real interest_rate(fixed=false, start=0) annotation(Dialog(group="Investment cost"));
  parameter Integer lifetime(fixed=false, start=0) "Lifetime in years" annotation(Dialog(group="Investment cost"));
  parameter Integer observation_time(fixed=false, start=0) "Observation time in years" annotation(Dialog(group="Investment cost"));

  // parameters:
  parameter Boolean isRev=false "Boolean to select whether the heat pump is reversible or not. If not, the cooling part is turned off";
  parameter Modelica.Units.SI.Power Qnom_AsHp "Nominal heat flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominalCon(displayUnit="Pa")=
       10000 "Pressure difference at condenser (water side)";
  parameter Modelica.Units.SI.PressureDifference dp_nominalEva=10000
    "Pressure difference at evaporator (water side)";
  parameter Real copDef=4.055 "Default COP";
  parameter Real EERDef=3.2 "Default EER";

  parameter Modelica.Units.SI.Temperature TAir_nominal=280.15
    "Nominal air temperature for COP calculation";
  parameter Modelica.Units.SI.Temperature TConOut_nominal=313.15
    "Nominal condensor leaving temperature for COP calculation";

  parameter Modelica.Units.SI.Temperature TAir_nominal_cooling=35 + 273.15
    "Nominal air temperature for EER calculation";

  parameter Modelica.Units.SI.Temperature TEvaOut_nominal_cooling=18 + 273.15
    "Nominal evaporater leaving temperature for EER calculation";

  parameter Real coeffEva=0.1095853
    "Linearisation coefficient of air temperature in COP calculation";
  parameter Real coeffCon=-0.0895519
    "Linearisation coefficient of leaving condensor temperature in COP calculation";
    IOCSmod.ComponentModels.Thermal.SizeOpt.AirSourceHeatPumps.HeatPump_AirWaterOpt AsHp(
    copDef=copDef,
    TAir_nominal=TAir_nominal,
    TConOut_nominal=TConOut_nominal,
    coeffEva=coeffEva,
    coeffCon=coeffCon,
    m2_flow_nominal=m_flow_ashp_nominal,
    dp_nominalCon(displayUnit="Pa") = dp_nominalCon,
    addDummyEquation=addDummyEquation,
    HP(mod_start=0))      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,10})));


  UnitTests.Confidential.FlowControlled_m_flow pumpHpAir(
    inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_ashp_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=AsHp.dp_nominalCon + AsChi.dp_nominalEva)
                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,-40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpIn(
    redeclare package Medium = Medium,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-20,0})));

  Modelica.Blocks.Sources.RealExpression ExprTamb(y=sim.Te) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,30})));


  Modelica.Blocks.Sources.RealExpression exprPelAsHp(y=AsHp.PEl + AsChi.PEl)
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Modelica.Blocks.Continuous.Integrator EAsHp_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Modelica.Blocks.Sources.RealExpression Expr_mFlowCon(y=Size*1000/4180/AsHp.dT_max)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,-20})));

  IOCSmod.ComponentModels.BaseClasses.Investment inv(inv_cost=inv_cost,
    interest_rate=interest_rate,
    lifetime=lifetime,
    observation_time=observation_time)
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  AirSourceChillers.Chiller_AirWaterOpt
                                     AsChi(
    Chi(mod(max=mod_max_cooling)),
    EERDef=EERDef,
    TAir_nominal=TAir_nominal_cooling,
    TEvaOut_nominal=TEvaOut_nominal_cooling,
    coeffEva=coeffCon,
    coeffCon=coeffEva,
    m1_flow_nominal=m_flow_ashp_nominal,
    dp_nominalEva(displayUnit="Pa") = dp_nominalEva,
    dp_nominalCon(displayUnit="Pa") = 300,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{20,40},{0,60}})));
     IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpOut(
    redeclare package Medium = Medium,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,56})));
   IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpHeaCooBtwn(
    redeclare package Medium = Medium,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=270,
        origin={0,30})));

protected
  parameter Modelica.Units.SI.MassFlowRate m_flow_ashp_nominal = Size_nominal*1000/4180/AsHp.dT_max
    "Nominal mass flow rate at water side";

  parameter Real mod_max_cooling = if isRev then 0.8 else 0;
equation

  connect(port_a, pumpHpAir.port_a)
    annotation (Line(points={{60,-100},{60,-40},{20,-40}}, color={0,127,255}));
  connect(pumpHpAir.port_b, senTAsHpIn.port_a) annotation (Line(points={{0,-40},
          {-40,-40},{-40,0},{-26,0}}, color={0,127,255}));
  connect(senTAsHpIn.port_b, AsHp.port_a)
    annotation (Line(points={{-14,0},{0,0},{0,4}}, color={0,127,255}));
  connect(exprPelAsHp.y,EAsHp_kWh. u)
    annotation (Line(points={{131,90},{138,90}},       color={0,0,127}));
  connect(Expr_mFlowCon.y, pumpHpAir.m_flow_in)
    annotation (Line(points={{25,-20},{10,-20},{10,-28}}, color={0,0,127}));
  connect(AsHp.port_b, senTAsHpHeaCooBtwn.port_a)
    annotation (Line(points={{0,16},{-1.11022e-15,24}}, color={0,127,255}));
  connect(senTAsHpHeaCooBtwn.port_b, AsChi.port_a) annotation (Line(points={{1.11022e-15,
          36},{0,36},{0,44}}, color={0,127,255}));
  connect(AsChi.port_b, senTAsHpOut.port_a)
    annotation (Line(points={{0,56},{-14,56}}, color={0,127,255}));
  connect(senTAsHpOut.port_b, port_b) annotation (Line(points={{-26,56},{-60,56},
          {-60,-100}}, color={0,127,255}));
  connect(ExprTamb.y, AsHp.Tair)
    annotation (Line(points={{29,30},{24,30},{24,7},{20,7}}, color={0,0,127}));
  connect(ExprTamb.y, AsChi.Tair) annotation (Line(points={{29,30},{24,30},{24,53},
          {20,53}}, color={0,0,127}));
  connect(exprPelAsHp.y, P) annotation (Line(points={{131,90},{134,90},{134,74},
          {-80,74},{-80,90},{-110,90}}, color={0,0,127}));
  annotation (defaultComponentName="AsHp", Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-74,35},{74,-35}},
          textColor={238,46,47},
          textString="ASHP"),Text(
          extent={{-152,100},{148,140}},
          textColor={0,0,0},
          textString="%name")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AsHpOpt;
