within IOCSmod.Demand.BuildingModels;
model MixedUse
  "Model of 5GDHC network of 6 buildings: 3 office buildings and 3 residential buildings (EPC A)"

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

  parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";
  //Tank - balancing unit
  parameter Modelica.Units.SI.Volume VTan "Tank volumes";
  parameter Modelica.Units.SI.Length rTan= sqrt(VTan/(Modelica.Constants.pi*hTan))
    "Radius of the storage tank (without insulation)";
  parameter Modelica.Units.SI.Length hTan = (4*VTan/Modelica.Constants.pi)^(1/3) "height of the tank";
  //parameter Modelica.Units.SI.Length dInsTan = 0.1 "thickness of the tank insulation";
  //parameter Modelica.Units.SI.ThermalConductivity kInsTan=0.04
    //"Thermal conductivity of the water tank insulation material";
  parameter Modelica.Units.SI.Area A_tank = 2*rTan*Modelica.Constants.pi*hTan + 2*Modelica.Constants.pi*rTan^2 "Tank area";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer U_tank=0.5 "overall heat loss coefficient of the tank";

  parameter Modelica.Units.SI.ThermalResistance RTan=1/(U_tank*A_tank)
    "Thermal resistance of the storage tank";
  //Network
 parameter Modelica.Units.SI.MassFlowRate m_flow_nom_NET=house1.hvac.m_flow_nom_dh + house2.hvac.m_flow_nom_dh + house3.hvac.m_flow_nom_dh + office1.hvac.m_flow_nom_dh + office2.hvac.m_flow_nom_dh + office3.hvac.m_flow_nom_dh;
 parameter Modelica.Units.SI.PressureDifference dp_nom_NET=office1.hvac.dp_nominal;
  //Thermal Comfort
  parameter Modelica.Units.SI.Temperature TSetOffHea = 273.15 + 21 "setpoint temperature office for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetOffCoo = 273.15 + 23 "setpoint temperature nightzone for cooling if people are present";

  parameter Modelica.Units.SI.Temperature TSetDayHea = 273.15 + 21 "setpoint temperature dayzone for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetNigHea = 273.15 + 18 "setpoint temperature nightzone for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetDayCoo = 273.15 + 24 "setpoint temperature dayzone for cooling if people are present";
  parameter Modelica.Units.SI.Temperature TSetNigCoo = 273.15 + 26 "setpoint temperature nightzone for cooling if people are present";
  parameter Modelica.Units.SI.Temperature TSetDefHea = 273.15 + 15 "setpoint temperature for heating if no people present";
  parameter Modelica.Units.SI.Temperature TSetDefCoo = 273.15 + 27 "setpoint temperature for cooling if no people present";
  parameter Modelica.Units.SI.Temperature TTanMax = 273.15 + 16 "maximum allowable tank temperature";
  parameter Modelica.Units.SI.Temperature TTanMin = 273.15 + 5 "minimum allowable tank temperature";

  Modelica.Blocks.Sources.CombiTimeTable officeHours(
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://DistrictHeating_5GDHC/Resources/OccupancyProfiles/office_hours_hourly.txt"),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{222,140},{236,154}})));

  Modelica.Blocks.Sources.RealExpression offPres(y=officeHours.y[1])
    annotation (Placement(transformation(extent={{222,118},{242,138}})));
  Modelica.Blocks.Sources.RealExpression resPres(y=1 - offPres.y)
    annotation (Placement(transformation(extent={{222,104},{242,124}})));
  Modelica.Blocks.Sources.RealExpression TSetOffHeaExpr(y=offPres.y*TSetOffHea +
        (1 - offPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{222,90},{242,110}})));
  Modelica.Blocks.Sources.RealExpression TSetOffCooExpr(y=offPres.y*TSetOffCoo +
        (1 - offPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{222,76},{242,96}})));
  Modelica.Blocks.Sources.RealExpression TSetNigCooExpr(y=resPres.y*TSetNigCoo +
        (1 - resPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{222,20},{242,40}})));
  Modelica.Blocks.Sources.RealExpression TSetNigHeaExpr(y=resPres.y*TSetNigHea +
        (1 - resPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{222,34},{242,54}})));
  Modelica.Blocks.Sources.RealExpression TSetDayHeaExpr(y=resPres.y*TSetDayHea +
        (1 - resPres.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{222,62},{242,82}})));
  Modelica.Blocks.Sources.RealExpression TSetDayCooExpr(y=resPres.y*TSetDayCoo +
        (1 - resPres.y)*TSetDefCoo)
    annotation (Placement(transformation(extent={{222,48},{242,68}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{90,150},{110,170}}),
    iconTransformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-110,150},{-90,170}}),
    iconTransformation(extent={{10,-110},{30,-90}})));

  Modelica.Blocks.Interfaces.RealOutput P
    annotation(Placement(transformation(extent={{200,-90},{220,-70}}),
      iconTransformation(extent={{100,-64},{120,-44}})));

  BS2025.Buildings.Gesl_M_A house1(hvac(heaPum(mod(max=0))),
  redeclare package MediumAir =IDEAS.Media.Specialized.DryAir,
  addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-58,-40},{-38,-20}})));
  BS2025.Buildings.Gesl_M_A house2(hvac(heaPum(mod(max=0))),
  redeclare package MediumAir =IDEAS.Media.Specialized.DryAir,
  addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-58,-94},{-38,-74}})));
  BS2025.Buildings.Gesl_M_A house3(hvac(heaPum(mod(max=0))),
  redeclare package MediumAir =IDEAS.Media.Specialized.DryAir,
  addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-58,-154},{-38,-134}})));
  BS2025.Buildings.Office_A office1(hvac(heaPum(mod(max=0))),
  redeclare package MediumAir =IDEAS.Media.Specialized.DryAir,
  addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{58,-68},{38,-48}})));
  BS2025.Buildings.Office_A office2(hvac(heaPum(mod(max=0))),
  redeclare package MediumAir =IDEAS.Media.Specialized.DryAir,
  addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{58,-122},{38,-102}})));
  BS2025.Buildings.Office_A office3(hvac(heaPum(mod(max=0))),
  redeclare package MediumAir =IDEAS.Media.Specialized.DryAir,
  addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{58,-180},{38,-160}})));
  IDEAS.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,-m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=270,
        origin={-6,-32})));
  IDEAS.Fluid.FixedResistances.Junction jun3(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,-m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=270,
        origin={-6,-60})));
  IDEAS.Fluid.FixedResistances.Junction jun4(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=270,
        origin={8,-50})));
  IDEAS.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={8,-22})));
  IDEAS.Fluid.FixedResistances.Junction jun6(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,-m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=270,
        origin={-6,-86})));
  IDEAS.Fluid.FixedResistances.Junction jun5(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={8,-74})));
  IDEAS.Fluid.FixedResistances.Junction jun7(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,-m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=270,
        origin={-6,-114})));
  IDEAS.Fluid.FixedResistances.Junction jun8(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=270,
        origin={8,-104})));
  IDEAS.Fluid.FixedResistances.Junction jun9(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={8,-134})));
  IDEAS.Fluid.FixedResistances.Junction jun10(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_NET,-m_flow_nom_NET,-m_flow_nom_NET},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=270,
        origin={-6,-146})));
  Modelica.Blocks.Sources.RealExpression ExprElecPowerDistrictHeaPumps(y=house1.hvac.heaPum.PEl
         + house2.hvac.heaPum.PEl + house3.hvac.heaPum.PEl + office1.hvac.heaPum.PEl
         + office2.hvac.heaPum.PEl + office3.hvac.heaPum.PEl)
    annotation (Placement(transformation(extent={{108,-90},{128,-70}})));
  UnitTests.Circuits.CircuitCollector collector(redeclare package Medium =
                       IDEAS.Media.Water, m_flow_nominal=m_flow_nom_NET)
    annotation (Placement(transformation(extent={{9,80},{-11,100}})));

  Modelica.Blocks.Math.Sum Pnet(nin=2)
    annotation (Placement(visible = true, transformation(origin={168,-80},    extent = {{-10, -10}, {10, 10}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression ExprElecPowerPumps(y=house1.hvac.pumCon.P
         + house2.hvac.pumCon.P + house3.hvac.pumCon.P + office1.hvac.pumCon.P
         + office2.hvac.pumCon.P + office3.hvac.pumCon.P)
    annotation (Placement(transformation(extent={{108,-110},{128,-90}})));
equation
  connect(jun1.port_3, house1.Sup) annotation (Line(points={{2,-22},{-16,-22},{
          -16,-28},{-36.1818,-28}},
                           color={0,127,255}));
  connect(house1.Ret, jun2.port_3)
    annotation (Line(points={{-36.1818,-32},{-12,-32}},
                                                   color={0,127,255}));
  connect(jun1.port_2, jun4.port_1)
    annotation (Line(points={{8,-28},{8,-44}}, color={0,127,255}));
  connect(jun4.port_3, office1.Sup) annotation (Line(points={{14,-50},{24,-50},
          {24,-56},{36.1818,-56}},
                             color={0,127,255}));
  connect(jun3.port_3, office1.Ret)
    annotation (Line(points={{0,-60},{36.1818,-60}},
                                                color={0,127,255}));
  connect(jun5.port_1, jun4.port_2)
    annotation (Line(points={{8,-68},{8,-56}}, color={0,127,255}));
  connect(house2.Ret, jun6.port_3)
    annotation (Line(points={{-36.1818,-86},{-12,-86}},
                                                   color={0,127,255}));
  connect(house2.Sup, jun5.port_3) annotation (Line(points={{-36.1818,-82},{-16,
          -82},{-16,-74},{2,-74}},
                              color={0,127,255}));
  connect(jun2.port_1, jun3.port_2)
    annotation (Line(points={{-6,-38},{-6,-54}}, color={0,127,255}));
  connect(jun3.port_1, jun6.port_2)
    annotation (Line(points={{-6,-66},{-6,-80}}, color={0,127,255}));
  connect(jun7.port_2, jun6.port_1)
    annotation (Line(points={{-6,-108},{-6,-92}}, color={0,127,255}));
  connect(jun8.port_1, jun5.port_2)
    annotation (Line(points={{8,-98},{8,-80}}, color={0,127,255}));
  connect(jun7.port_3, office2.Ret)
    annotation (Line(points={{0,-114},{36.1818,-114}},
                                                  color={0,127,255}));
  connect(office2.Sup, jun8.port_3) annotation (Line(points={{36.1818,-110},{20,
          -110},{20,-104},{14,-104}},
                                color={0,127,255}));
  connect(jun8.port_2, jun9.port_1)
    annotation (Line(points={{8,-110},{8,-128}}, color={0,127,255}));
  connect(jun7.port_1, jun10.port_2)
    annotation (Line(points={{-6,-120},{-6,-140}}, color={0,127,255}));
  connect(jun9.port_3, house3.Sup) annotation (Line(points={{2,-134},{-16,-134},
          {-16,-142},{-36.1818,-142}},
                                  color={0,127,255}));
  connect(house3.Ret, jun10.port_3)
    annotation (Line(points={{-36.1818,-146},{-12,-146}},
                                                     color={0,127,255}));
  connect(jun9.port_2, office3.Sup)
    annotation (Line(points={{8,-140},{8,-168},{36.1818,-168}},
                                                           color={0,127,255}));
  connect(jun10.port_1, office3.Ret) annotation (Line(points={{-6,-152},{-6,
          -172},{36.1818,-172}},
                      color={0,127,255}));
  connect(collector.port_a1, port_a)
    annotation (Line(points={{9,96},{100,96},{100,160}}, color={0,127,255}));
  connect(collector.port_b1, port_b) annotation (Line(points={{-11,96},{-100,96},
          {-100,160}}, color={0,127,255}));
  connect(collector.port_b2, jun1.port_1)
    annotation (Line(points={{9,84},{8,84},{8,-16}}, color={0,127,255}));
  connect(jun2.port_2, collector.port_a2) annotation (Line(points={{-6,-26},{-4,
          -26},{-4,74},{-18,74},{-18,84},{-11,84}}, color={0,127,255}));
  connect(ExprElecPowerDistrictHeaPumps.y, Pnet.u[1]) annotation (Line(points={
          {129,-80},{142,-80},{142,-81},{156,-81}}, color={0,0,127}));
  connect(ExprElecPowerPumps.y, Pnet.u[2]) annotation (Line(points={{129,-100},
          {140,-100},{140,-79},{156,-79}}, color={0,0,127}));
  connect(Pnet.y, P)
    annotation (Line(points={{179,-80},{210,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{-56,-26},{-56,-92},{-12,-92},{-12,-46},{10,-46},{10,-92},{56,
              -92},{56,-26},{0,14},{-56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-56,-26},{-66,-34},{-72,-26},{0,26},{72,-26},{68,-34},{56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-44,-46},{-26,-46},{-26,-64},{-44,-64},{-44,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{24,-46},{42,-46},{42,-64},{24,-64},{24,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-10,-14},{8,-14},{8,-32},{-10,-32},{-10,-14}},
          color={244,125,35},
          thickness=0.5),
        Polygon(
          points={{56,32},{76,32},{84,30},{86,26},{86,22},{86,18},{80,18},{80,22},
              {80,24},{76,26},{56,26},{56,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,32},{72,32},{72,40},{76,38},{76,42},{66,42},{66,38},{70,40},
              {70,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,16},{82,12},{82,10},{84,8},{86,10},{86,12},{84,16}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-40,20}},
          textColor={0,0,0},
          textStyle={TextStyle.Italic},
          textString="6"),
        Polygon(
          points={{84,-40},{90,-40},{84,-54},{92,-54},{78,-80},{84,-58},{76,-58},
              {84,-40}},
          lineColor={0,0,0},
          fillColor={244,221,46},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,160}})));
end MixedUse;
