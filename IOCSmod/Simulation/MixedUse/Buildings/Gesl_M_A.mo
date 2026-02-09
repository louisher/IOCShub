within IOCSmod.Simulation.MixedUse.Buildings;
model Gesl_M_A "Terraced building A + hvac system"
  replaceable package MediumAir = IDEAS.Media.Air "Medium in the component";
  parameter Real [nZones] n= (3.6/nZones).*bui.AZones./bui.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*bui.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = bui.nZones
    "Number of conditioned thermal building zones";
  DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Gesl_M.Gesl_M_Structure_A bui(useFluPor=
       true, redeclare package Medium = MediumAir)
        annotation (Placement(transformation(extent={{-14,-10},{16,10}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=0)
    annotation(Placement(transformation(extent={{60, 30}, {40, 50}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=0)
    annotation(Placement(transformation(extent={{60, 10}, {40, 30}})));
    parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";
    parameter Boolean isDh=true "=true, if the system is connected to a DH grid";

  Modelica.Fluid.Interfaces.FluidPort_a Sup(redeclare package Medium =
        IDEAS.Media.Water) if isDh "Supply water connection to the DH grid"
    annotation (Placement(transformation(extent={{94,14},{106,26}}),
        iconTransformation(extent={{114,14},{126,26}})));
  Modelica.Fluid.Interfaces.FluidPort_b Ret(redeclare package Medium =
        IDEAS.Media.Water) if isDh "Return water connection to the DH grid"
    annotation (Placement(transformation(extent={{94,-26},{106,-14}}),
        iconTransformation(extent={{114,-26},{126,-14}})));
  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness
    hex(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=m_flow_nominal_air,
    m2_flow_nominal=m_flow_nominal_air,
    eps=0.84,
    dp1_nominal=65,
    dp2_nominal=225) "Heat recovery unit"
    annotation (Placement(transformation(extent={{-48,36},{-68,56}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanSup[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=100)                                       "Supply fan"
    annotation (Placement(transformation(extent={{-28,24},{-8,44}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanRet[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=80)                                        "Return fan"
    annotation (Placement(transformation(extent={{-8,50},{-28,70}})));
  IDEAS.Fluid.Sources.Boundary_pT bouAir(
    use_T_in=true,
    redeclare package Medium = MediumAir,
    nPorts=2)
    "Boundary for air model"
    annotation (Placement(transformation(extent={{-92,40},{-80,52}})));
  Modelica.Blocks.Sources.RealExpression Te(y=sim.Te) "Ambient air"
    annotation (Placement(transformation(extent={{-112,40},{-100,54}})));
  Substation substation(
    nZones=bui.nZones,
    hasIntCon=true,
    Q_design={2130,1534},
    A_floor=bui.AZones)
    annotation (Placement(transformation(extent={{34,-10},{76,10}})));
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
        origin={20,120})));
  Modelica.Blocks.Continuous.Integrator DiscmfCoo1(k=1/3600)
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Modelica.Blocks.Continuous.Integrator DiscmfCoo2(k=1/3600)
    annotation (Placement(transformation(extent={{-200,48},{-180,68}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea1(k=1/3600)
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea2(k=1/3600)
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=max(0, substation.TSensor[
        1] - (substation.TSet[1] + 0.5)))
    annotation (Placement(transformation(extent={{-242,78},{-222,98}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=max(0, substation.TSensor[
        2] - (substation.TSet[2] + 0.5)))
    annotation (Placement(transformation(extent={{-242,48},{-222,68}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=max(0, substation.TSet[
        1] - 0.5 - substation.TSensor[1]))
    annotation (Placement(transformation(extent={{-240,10},{-220,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=max(0, substation.TSet[
        2] - 0.5 - substation.TSensor[2]))
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Modelica.Blocks.Sources.RealExpression DiscmfHea(y=DiscmfHea1.y + DiscmfHea2.y)
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  Modelica.Blocks.Sources.RealExpression DiscmfCoo(y=DiscmfCoo1.y + DiscmfCoo2.y)
    annotation (Placement(transformation(extent={{-194,-70},{-174,-50}})));
equation
  connect(occ1.y, bui.occ[1]) annotation(Line(points={{39, 40}, {11, 40}, {11, 10}}, color={0, 0, 127}));
  connect(occ2.y, bui.occ[2]) annotation(Line(points={{39, 20}, {11, 20}, {11, 10}}, color={0, 0, 127}));
  connect(Te.y,bouAir. T_in) annotation (Line(points={{-99.4,47},{-99.4,48.4},{-93.2,
          48.4}},         color={0,0,127}));
  for i in 1:nZones loop
    connect(hex.port_b2,fanSup [i].port_a) annotation (Line(points={{-48,40},{-40,
          40},{-40,34},{-28,34}}, color={0,127,255}));
  end for;
  for i in 1:nZones loop
    connect(hex.port_a1,fanRet [i].port_b) annotation (Line(points={{-48,52},{-40,
          52},{-40,60},{-28,60}}, color={0,127,255}));
  end for;
  connect(hex.port_b1,bouAir. ports[1]) annotation (Line(points={{-68,52},{-80,52},
          {-80,47.2}},      color={0,127,255}));
  connect(hex.port_a2,bouAir. ports[2]) annotation (Line(points={{-68,40},{-80,40},
          {-80,44.8}},      color={0,127,255}));
  connect(fanSup.port_b, bui.port_a) annotation (Line(points={{-8,34},{3,34},{3,10}},  color={0,127,255}));
  connect(fanRet.port_a, bui.port_b) annotation (Line(points={{-8,60},{-1,60},{-1,10}},  color={0,127,255}));
  connect(substation.heatPortEmb, bui.heatPortEmb)
    annotation (Line(points={{34,6},{16,6}}, color={191,0,0}));
  connect(substation.port_a, Sup) annotation (Line(points={{76,6},{86,6},{86,20},
          {100,20}}, color={0,127,255}));
  connect(Ret, substation.port_b) annotation (Line(points={{100,-20},{86,-20},{
          86,-6},{76,-6}}, color={0,127,255}));
  connect(substation.coolingOn, coolingOn1) annotation (Line(points={{54,12},{
          54,60},{54,120},{60,120}}, color={255,0,255}));
  connect(substation.TSet, TSet1) annotation (Line(points={{54,-10.2},{54,-22},
          {20,-22},{20,120}}, color={0,0,127}));
  connect(bui.TSensor, substation.TSensor)
    annotation (Line(points={{16.6,-6},{33.6,-6}}, color={0,0,127}));
  connect(realExpression.y, DiscmfCoo1.u) annotation (Line(points={{-221,88},{
          -212,88},{-212,90},{-202,90}}, color={0,0,127}));
  connect(realExpression1.y, DiscmfCoo2.u)
    annotation (Line(points={{-221,58},{-202,58}}, color={0,0,127}));
  connect(realExpression2.y, DiscmfHea1.u)
    annotation (Line(points={{-219,20},{-202,20}}, color={0,0,127}));
  connect(realExpression3.y, DiscmfHea2.u)
    annotation (Line(points={{-219,-20},{-202,-20}}, color={0,0,127}));
annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {100,100}}),                                     graphics={
  Line(points={{-70, 4}, {-70, -86}, {-16, -86}, {-16, -30}, {16, -30}, {16, -86}, {70, -86}, {70, 4}, {0, 74}, {-70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-70, 4}, {-76, -2}, {-88, -2}, {0, 86}, {88, -2}, {76, -2}, {70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-14, 28}, {14, 28}, {14, 0}, {-14, 0}, {-14, 28}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{30, -30}, {58, -30}, {58, -58}, {30, -58}, {30, -30}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-58, -30}, {-30, -30}, {-30, -58}, {-58, -58}, {-58, -30}}, color={244, 125, 35}, thickness=0.5),
        Text(
          extent={{-180,140},{180,100}},
          textColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}})),
  experiment(StopTime=86000, __Dymola_Algorithm="Dassl"),
  Documentation(info="<html> 
         <p>Q_design = QzoneDay kW (DayZone) &amp; QzoneNight kW (NightZone)</p> 
         <p>UA_building = UAbuilding W/K</p> 
         <p>Roof</p> 
         <ul><li>Side1: Surface1 m2, tilt = Tilt1 rad (Tilt1deg &deg;)</li><li>Side2: Surface2 m2, tilt = Tilt2 rad (Tilt2deg &deg;)<br></li></ul> 
         </html>", revisions="<html><ul><li>March 5, 2024, by Lucas Verleyen:<br> Remove mass flow sources and set useFluPor = false.<li>October 9, 2023, by Lucas Verleyen:<br> Initial implementation.</li></ul></html>"));
end Gesl_M_A;
