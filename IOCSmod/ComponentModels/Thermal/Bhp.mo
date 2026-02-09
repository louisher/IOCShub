within IOCSmod.ComponentModels.Thermal;
model Bhp "Model of booster heat pump"

  parameter String Qbhp_profile_name = "FTE_PTE_School_BHP" "house nb";
  parameter String QConBhpFile = Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/BHP_profiles/" + Qbhp_profile_name + ".txt")
    "Directory containing the data files, default under IDEAS/Inputs/";

  parameter Modelica.Units.SI.HeatFlowRate Qbhp_nominal=8000 "Nominal power bhp";

    parameter Modelica.Units.SI.MassFlowRate m_flow_nominalCon=Qbhp_nominal/4180/bhp.dT_max
    "Nominal mass flow rate condensor bhp";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominalEva=Qbhp_nominal*((bhp.copDef-1)/bhp.copDef)/4180/5;
  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal=0
    "Pressure drop of pipe and other resistances that are in series";
  parameter Real Kv=valBhp.m_flow_nominal/sqrt(valBhp.dpValve_nominal)/(valBhp.rhoStd
      /3600/sqrt(1E5)) "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]";

  UnitTests.Components.HeatPump_WaterWater bhp(
    redeclare package Medium1 = IDEAS.Media.Water,
    redeclare package Medium2 = IDEAS.Media.Water,
    m1_flow_nominal=m_flow_nominalEva,
    m2_flow_nominal=m_flow_nominalCon,
    dp_nominalEva=0,
    dp_nominalCon=50000,
    dT_max=7.6,
    copDef=3.87,
    coeffEva={-301.4,0.08046},
    coeffCon={-328.15,-0.07626}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90)));
  IDEAS.Fluid.Sources.Boundary_pT bou3(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={32,20})));
  IDEAS.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow=m_flow_nominalCon,
    T=323.15,
    nPorts=1) annotation (Placement(transformation(extent={{42,-36},{22,-16}})));
  Modelica.Blocks.Sources.CombiTimeTable Qcon_profile(
    tableOnFile=true,
    tableName="data",
    fileName=QConBhpFile,
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Modelica.Blocks.Sources.RealExpression modBhpExpr(y=Qcon_profile.y[1]/(bhp.smoothMin
        *4180*bhp.dT_max)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={32,48})));
  UnitTests.Components.TwoWayLinear valBhp(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_nominalEva,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=Kv,
    dpFixed_nominal=dpFixed_nominal)
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        IDEAS.Media.Water)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        IDEAS.Media.Water)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBhpEvaIn(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=bhp.m1_flow_nominal,
    redeclare package Medium = IDEAS.Media.Water)
    "Inlet temperature of evaporator" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBhpEvaOut(
    allowFlowReversal=false,
    tau=0,
    m_flow_nominal=bhp.m1_flow_nominal,
    redeclare package Medium = IDEAS.Media.Water)
    "Outlet temperature of evaporator" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-30,-40})));
  Modelica.Blocks.Sources.RealExpression valOpe(y=max(0, min(1, Qcon_profile.y[1])))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-76,72})));

  Modelica.Blocks.Interfaces.RealOutput PEl
    "Electrical power use of the booster heat pump"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
equation
  connect(boundary.ports[1], bhp.port_a2)
    annotation (Line(points={{22,-26},{6,-26},{6,-10}}, color={0,127,255}));
  connect(bhp.port_b2, bou3.ports[1])
    annotation (Line(points={{6,10},{6,20},{22,20}}, color={0,127,255}));
  connect(valBhp.port_a, port_a)
    annotation (Line(points={{-70,40},{-100,40}}, color={0,127,255}));
  connect(port_a, port_a)
    annotation (Line(points={{-100,40},{-100,40}}, color={0,127,255}));
  connect(valBhp.port_b, senTBhpEvaIn.port_a)
    annotation (Line(points={{-50,40},{-40,40}}, color={0,127,255}));
  connect(bhp.port_b1, senTBhpEvaOut.port_a)
    annotation (Line(points={{-6,-10},{-6,-40},{-20,-40}}, color={0,127,255}));
  connect(senTBhpEvaOut.port_b, port_b)
    annotation (Line(points={{-40,-40},{-100,-40}}, color={0,127,255}));
  connect(senTBhpEvaIn.port_b, bhp.port_a1)
    annotation (Line(points={{-20,40},{-6,40},{-6,10}}, color={0,127,255}));
  connect(valOpe.y, valBhp.y)
    annotation (Line(points={{-65,72},{-60,72},{-60,52}}, color={0,0,127}));
  connect(modBhpExpr.y, bhp.mod)
    annotation (Line(points={{21,48},{0,48},{0,11}}, color={0,0,127}));
  connect(bhp.PEl, PEl) annotation (Line(points={{-7.21645e-16,-11},{-7.21645e-16,
          -40},{110,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-100,0},{-100,100},{100,100},{100,0}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,0},{-100,-100},{100,-100},{100,0}},
          color={28,108,200},
          thickness=1),
        Text(
          extent={{-64,82},{72,6}},
          textColor={238,46,47},
          textString="DHW"),
        Text(
          extent={{-62,-24},{62,-70}},
          textColor={28,108,200},
          textString="%house_nb")}),                             Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Bhp;
