within IOCSmod.ComponentModels.Thermal;
model revAsHp "Model of a reversible ASHP:
  The COP parameters of the heat pump are determined using the calibration script in IOCS/Datasheets/TacoCalibration.py and are based on the Viessmann VitoCal200A of 2024"
  extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface;

  // parameters:
  parameter Boolean isRev=false "Boolean to select whether the heat pump is reversible or not. If not, the cooling part is turned off";
  parameter Modelica.Units.SI.Power Qnom_AsHp "Nominal heat flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_ashp_nominal = Qnom_AsHp/4180/5
    "Nominal mass flow rate at water side";
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

  UnitTests.Confidential.FlowControlled_m_flow pumpHpAir(
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
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
  AirSourceHeatPumps.HeatPump_AirWater
                         AsHp(
    copDef=copDef,
    TAir_nominal=TAir_nominal,
    TConOut_nominal=TConOut_nominal,
    coeffEva=coeffEva,
    coeffCon=coeffCon,
    m2_flow_nominal=m_flow_ashp_nominal,
    dp_nominalCon(displayUnit="Pa") = dp_nominalCon,
    addDummyEquation=addDummyEquation,
    Q_flow_nominal=Qnom_AsHp,
    HP(mod_start=0))      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,10})));
  Modelica.Blocks.Sources.RealExpression ExprTamb(y=sim.Te) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,30})));


  Modelica.Blocks.Sources.RealExpression exprPelAsHp(y=AsHp.PEl + AsChi.PEl)
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Modelica.Blocks.Continuous.Integrator EAsHp_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  AirSourceChillers.Chiller_AirWater AsChi(
    Q_flow_nominal=0.8*Qnom_AsHp,          Chi(mod(max=mod_max_cooling)),
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
protected
  parameter Real mod_max_cooling = if isRev then 1 else 0;
equation
  connect(port_a, pumpHpAir.port_a)
    annotation (Line(points={{60,-100},{60,-40},{20,-40}}, color={0,127,255}));
  connect(pumpHpAir.port_b, senTAsHpIn.port_a) annotation (Line(points={{0,-40},
          {-40,-40},{-40,0},{-26,0}}, color={0,127,255}));
  connect(senTAsHpIn.port_b, AsHp.port_a)
    annotation (Line(points={{-14,0},{0,0},{0,4}}, color={0,127,255}));
  connect(senTAsHpOut.port_b, port_b) annotation (Line(points={{-26,56},{-60,56},
          {-60,-100}}, color={0,127,255}));
  connect(ExprTamb.y, AsHp.Tair)
    annotation (Line(points={{29,30},{24,30},{24,7},{20,7}},
                                                    color={0,0,127}));
  connect(exprPelAsHp.y,EAsHp_kWh. u)
    annotation (Line(points={{131,90},{138,90}},       color={0,0,127}));
  connect(senTAsHpOut.port_a, AsChi.port_b)
    annotation (Line(points={{-14,56},{0,56}}, color={0,127,255}));
  connect(AsHp.port_b, senTAsHpHeaCooBtwn.port_a)
    annotation (Line(points={{0,16},{-1.11022e-15,24}}, color={0,127,255}));
  connect(senTAsHpHeaCooBtwn.port_b, AsChi.port_a) annotation (Line(points={{1.11022e-15,
          36},{0,36},{0,44}}, color={0,127,255}));
  connect(ExprTamb.y, AsChi.Tair) annotation (Line(points={{29,30},{24,30},{24,53},
          {20,53}}, color={0,0,127}));
  connect(exprPelAsHp.y, P) annotation (Line(points={{131,90},{134,90},{134,74},
          {0,74},{0,90},{-110,90}}, color={0,0,127}));
  annotation (defaultComponentName="AsHp", Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-74,35},{74,-35}},
          textColor={238,46,47},
          textString="ASHP"),Text(
          extent={{-152,100},{148,140}},
          textColor={0,0,0},
          textString="%name")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end revAsHp;
