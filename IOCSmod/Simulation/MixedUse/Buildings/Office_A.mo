within IOCSmod.Simulation.MixedUse.Buildings;
model Office_A "Office building A + hvac + ventilo"
  extends DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Office.Office_A( office(
  useFluPor=true, redeclare package Medium = MediumAir));
  replaceable package MediumAir = IDEAS.Media.Air "Medium in the component";
  parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";
  parameter Boolean isDh=true "=true, if the system is connected to a DH grid";
  parameter Real [nZones] n= (3.6/nZones).*office.AZones./office.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*office.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = office.nZones
    "Number of conditioned thermal building zones";
      //Thermal Comfort
  parameter Modelica.Units.SI.Temperature TSetOffHea = 273.15 + 21 "setpoint temperature office for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetOffCoo = 273.15 + 23 "setpoint temperature nightzone for cooling if people are present";
  parameter Modelica.Units.SI.Temperature TSetDefHea = 273.15 + 15 "setpoint temperature for heating if no people present";
  parameter Modelica.Units.SI.Temperature TSetDefCoo = 273.15 + 27 "setpoint temperature for cooling if no people present";

  Modelica.Fluid.Interfaces.FluidPort_b Ret(redeclare package Medium =
        IDEAS.Media.Water) if isDh "Return water connection to the DH grid"
    annotation (Placement(transformation(extent={{94,-26},{106,-14}}),
        iconTransformation(extent={{114,-26},{126,-14}})));
  Modelica.Fluid.Interfaces.FluidPort_a Sup(redeclare package Medium =
        IDEAS.Media.Water) if isDh "Supply water connection to the DH grid"
    annotation (Placement(transformation(extent={{94,14},{106,26}}),
        iconTransformation(extent={{114,14},{126,26}})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness
                                             hex(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=m_flow_nominal_air,
    m2_flow_nominal=m_flow_nominal_air,
    eps=0.84,
    dp1_nominal=65,
    dp2_nominal=225) "Heat recovery unit"
    annotation (Placement(transformation(extent={{-50,36},{-70,56}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanSup[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=100)                                       "Supply fan"
    annotation (Placement(transformation(extent={{-30,24},{-10,44}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanRet[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=80)                                        "Return fan"
    annotation (Placement(transformation(extent={{-10,50},{-30,70}})));
  IDEAS.Fluid.Sources.Boundary_pT bouAir(
    use_T_in=true,
    redeclare package Medium = MediumAir,
    nPorts=2)                             "Boundary for air model"
    annotation (Placement(transformation(extent={{-94,40},{-82,52}})));
  Modelica.Blocks.Sources.RealExpression Te(y=sim.Te) "Ambient air"
    annotation (Placement(transformation(extent={{-114,40},{-102,54}})));
  Substation substation(
    nZones=office.nZones,
    hasIntCon=true,
    Q_design={3830,3830},
    A_floor=office.AZones)
    annotation (Placement(transformation(extent={{32,-10},{74,10}})));
  Modelica.Blocks.Interfaces.BooleanInput coolingOn1
    "Connector of Boolean input signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));
  Modelica.Blocks.Interfaces.RealInput TSet1[size(substation.TSet, 1)]
                        "Setpoint temperature for the zones" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-20,120})));
  Modelica.Blocks.Continuous.Integrator DiscmfCoo1(k=1/3600)
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Modelica.Blocks.Continuous.Integrator DiscmfCoo2(k=1/3600)
    annotation (Placement(transformation(extent={{-160,28},{-140,48}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea1(k=1/3600)
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea2(k=1/3600)
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=max(0, substation.TSensor[
        1] - TSetOffCooExpr.y))
    annotation (Placement(transformation(extent={{-202,60},{-182,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=max(0, substation.TSensor[
        2] - TSetOffCooExpr.y))
    annotation (Placement(transformation(extent={{-200,28},{-180,48}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=max(0,
        TSetOffHeaExpr.y - substation.TSensor[1]))
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=max(0,
        TSetOffHeaExpr.y - substation.TSensor[2]))
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Modelica.Blocks.Sources.RealExpression DiscmfHea(y=DiscmfHea1.y + DiscmfHea2.y)
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Modelica.Blocks.Sources.CombiTimeTable officeHours1(
    fileName=Modelica.Utilities.Files.loadResource("modelica://DistrictHeating_5GDHC/Resources/OccupancyProfiles/office_hours_hourly.txt"),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-200,126},{-186,140}})));

  Modelica.Blocks.Sources.RealExpression offPres1(y=officeHours.y[1])
    annotation (Placement(transformation(extent={{-200,104},{-180,124}})));
  Modelica.Blocks.Sources.RealExpression resPres(y=1 - offPres.y)
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Modelica.Blocks.Sources.RealExpression TSetOffHeaExpr(y=offPres.y*TSetOffHea +
        (1 - offPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{-168,104},{-148,124}})));
  Modelica.Blocks.Sources.RealExpression TSetOffCooExpr(y=offPres.y*TSetOffCoo +
        (1 - offPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{-168,90},{-148,110}})));
  Modelica.Blocks.Sources.RealExpression DiscmfCoo(y=DiscmfCoo1.y + DiscmfCoo2.y)
    annotation (Placement(transformation(extent={{-180,-96},{-160,-76}})));
equation
  // connection ventilation model
  connect(Te.y,bouAir. T_in) annotation (Line(points={{-101.4,47},{-101.4,48.4},
          {-95.2,48.4}},  color={0,0,127}));
  for i in 1:nZones loop
    connect(hex.port_b2,fanSup [i].port_a) annotation (Line(points={{-50,40},{-42,
          40},{-42,34},{-30,34}}, color={0,127,255}));
  end for;
  for i in 1:nZones loop
    connect(hex.port_a1,fanRet [i].port_b) annotation (Line(points={{-50,52},{-42,
          52},{-42,60},{-30,60}}, color={0,127,255}));
  end for;
  connect(hex.port_b1,bouAir. ports[1]) annotation (Line(points={{-70,52},{-82,52},
          {-82,47.2}},      color={0,127,255}));
  connect(hex.port_a2,bouAir. ports[2]) annotation (Line(points={{-70,40},{-82,40},
          {-82,44.8}},      color={0,127,255}));
  connect(office.port_a, fanSup.port_b) annotation (Line(points={{1,10},{2,10},{
          2,34},{-10,34}}, color={0,127,255}));
  connect(office.port_b, fanRet.port_a) annotation (Line(points={{-3,10},{-2,10},
          {-2,60},{-10,60}}, color={0,127,255}));
  connect(substation.heatPortEmb, office.heatPortEmb)
    annotation (Line(points={{32,6},{14,6}}, color={191,0,0}));
  connect(substation.port_a, Sup) annotation (Line(points={{74,6},{88,6},{88,20},
          {100,20}}, color={0,127,255}));
  connect(substation.port_b, Ret) annotation (Line(points={{74,-6},{88,-6},{88,
          -20},{100,-20}}, color={0,127,255}));
  connect(substation.coolingOn, coolingOn1)
    annotation (Line(points={{52,12},{60,12},{60,120}}, color={255,0,255}));
  connect(substation.TSet, TSet1) annotation (Line(points={{52,-10.2},{52,-26},
          {-18,-26},{-18,120},{-20,120}}, color={0,0,127}));
  connect(office.TSensor, substation.TSensor)
    annotation (Line(points={{14.6,-6},{31.6,-6}}, color={0,0,127}));
  connect(realExpression.y, DiscmfCoo1.u)
    annotation (Line(points={{-181,70},{-162,70}}, color={0,0,127}));
  connect(realExpression1.y, DiscmfCoo2.u)
    annotation (Line(points={{-179,38},{-162,38}}, color={0,0,127}));
  connect(realExpression2.y, DiscmfHea1.u)
    annotation (Line(points={{-179,0},{-162,0}}, color={0,0,127}));
  connect(realExpression3.y, DiscmfHea2.u)
    annotation (Line(points={{-179,-40},{-162,-40}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-120,-100},{100,100}})));
end Office_A;
