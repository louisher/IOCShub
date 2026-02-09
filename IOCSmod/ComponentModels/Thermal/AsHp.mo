within IOCSmod.ComponentModels.Thermal;
model AsHp "Model of a ASHP:
  The COP parameters of the heat pump are determined using the calibration script in IOCS/Datasheets/TacoCalibration.py and are based on the Viessmann VitoCal200A of 2024"
  extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface;

  // parameters:
  parameter Modelica.Units.SI.Power Qnom_AsHp "Nominal heat flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_ashp_nominal = Qnom_AsHp/4180/5
    "Nominal mass flow rate at water side";
  parameter Modelica.Units.SI.PressureDifference dp_nominalCon(displayUnit="Pa")=
       10000 "Pressure difference at condenser (water side)";
  parameter Real copDef=4.055 "Default COP";
  parameter Modelica.Units.SI.Temperature TAir_nominal=280.15
    "Nominal air temperature for COP calculation";
  parameter Modelica.Units.SI.Temperature TConOut_nominal=313.15
    "Nominal condensor leaving temperature for COP calculation";
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
    dp_nominal=dp_nominalCon)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,-40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpConIn(
    redeclare package Medium = Medium,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-20,0})));
     IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpConOut(
    redeclare package Medium = Medium,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,20})));
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
        origin={38,8})));


  Modelica.Blocks.Sources.RealExpression exprPelAsHp(y=AsHp.PEl)
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Modelica.Blocks.Continuous.Integrator EAsHp_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
equation
  connect(port_a, pumpHpAir.port_a)
    annotation (Line(points={{60,-100},{60,-40},{20,-40}}, color={0,127,255}));
  connect(pumpHpAir.port_b, senTAsHpConIn.port_a) annotation (Line(points={{0,-40},
          {-40,-40},{-40,0},{-26,0}}, color={0,127,255}));
  connect(senTAsHpConIn.port_b, AsHp.port_a)
    annotation (Line(points={{-14,0},{0,0},{0,4}}, color={0,127,255}));
  connect(AsHp.port_b, senTAsHpConOut.port_a)
    annotation (Line(points={{0,16},{0,20},{-14,20}}, color={0,127,255}));
  connect(senTAsHpConOut.port_b, port_b) annotation (Line(points={{-26,20},{-60,
          20},{-60,-100}}, color={0,127,255}));
  connect(ExprTamb.y, AsHp.Tair)
    annotation (Line(points={{27,8},{27,7},{20,7}}, color={0,0,127}));
  connect(AsHp.PEl, P) annotation (Line(points={{10,-1},{10,-10},{60,-10},{60,90},
          {-110,90}}, color={0,0,127}));
  connect(exprPelAsHp.y,EAsHp_kWh. u)
    annotation (Line(points={{131,90},{138,90}},       color={0,0,127}));
  annotation (defaultComponentName="AsHp", Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-74,35},{74,-35}},
          textColor={238,46,47},
          textString="ASHP"),Text(
          extent={{-152,100},{148,140}},
          textColor={0,0,0},
          textString="%name")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AsHp;
