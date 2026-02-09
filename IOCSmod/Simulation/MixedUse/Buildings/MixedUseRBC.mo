within IOCSmod.Simulation.MixedUse.Buildings;
model MixedUseRBC
  "Model of 5GDHC network of 6 buildings: 3 office buildings and 3 residential buildings (EPC A)"

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

  parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";
  //Tank - balancing unit

  //Network
 parameter Modelica.Units.SI.MassFlowRate m_flow_nom_NET=house1.substation.m_flow_nom_dh + house2.substation.m_flow_nom_dh + house3.substation.m_flow_nom_dh + office1.substation.m_flow_nom_dh + office2.substation.m_flow_nom_dh + office3.substation.m_flow_nom_dh;
 parameter Modelica.Units.SI.PressureDifference dp_nom_NET= office1.substation.valHex.dpValve_nominal;
  //Thermal Comfort
  parameter Modelica.Units.SI.Temperature TSetOffHea = 273.15 + 21 "setpoint temperature office for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetOffCoo = 273.15 + 23 "setpoint temperature nightzone for cooling if people are present";

  parameter Modelica.Units.SI.Temperature TSetDayHea = 273.15 + 21 "setpoint temperature dayzone for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetNigHea = 273.15 + 18 "setpoint temperature nightzone for heating if people are present";
  parameter Modelica.Units.SI.Temperature TSetDayCoo = 273.15 + 24 "setpoint temperature dayzone for cooling if people are present";
  parameter Modelica.Units.SI.Temperature TSetNigCoo = 273.15 + 26 "setpoint temperature nightzone for cooling if people are present";
  parameter Modelica.Units.SI.Temperature TSetDefHea = 273.15 + 19 "setpoint temperature for heating if no people present";
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
  Modelica.Blocks.Sources.RealExpression TSetOffHeaExpr(y=offPres_shift.y*
        TSetOffHea + (1 - offPres_shift.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{142,-104},{122,-84}})));
  Modelica.Blocks.Sources.RealExpression TSetOffCooExpr(y=offPres_shift.y*
        TSetOffHea + (1 - offPres_shift.y)*TSetDefHea)
    annotation (Placement(transformation(extent={{140,-88},{120,-68}})));

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
  Modelica.Blocks.Sources.RealExpression ExprElecPowerDistrictHeaPumps(y=0)
    annotation (Placement(transformation(extent={{230,-154},{250,-134}})));
  UnitTests.Circuits.CircuitCollector collector(redeclare package Medium =
                       IDEAS.Media.Water, m_flow_nominal=m_flow_nom_NET)
    annotation (Placement(transformation(extent={{9,80},{-11,100}})));

  Modelica.Blocks.Math.Sum Pnet(nin=2)
    annotation (Placement(visible = true, transformation(origin={168,-80},    extent = {{-10, -10}, {10, 10}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression ExprElecPowerPumps(y=house1.substation.pumCon.P
         + house2.substation.pumCon.P + house3.substation.pumCon.P + office1.substation.pumCon.P
         + office2.substation.pumCon.P + office3.substation.pumCon.P)
    annotation (Placement(transformation(extent={{230,-174},{250,-154}})));
  Gesl_M_A house1
    annotation (Placement(transformation(extent={{-88,-42},{-66,-22}})));
  Gesl_M_A house2
    annotation (Placement(transformation(extent={{-88,-98},{-66,-78}})));
  Gesl_M_A house3
    annotation (Placement(transformation(extent={{-84,-150},{-62,-130}})));
  Office_A office1
    annotation (Placement(transformation(extent={{60,-64},{38,-44}})));
  Office_A office2
    annotation (Placement(transformation(extent={{60,-118},{38,-98}})));
  Office_A office3
    annotation (Placement(transformation(extent={{60,-152},{38,-132}})));
  Modelica.Blocks.Logical.Switch TSetSwitchHou1Day
    annotation (Placement(transformation(extent={{-138,0},{-118,20}})));
  Modelica.Blocks.Math.BooleanToReal coolingPeriod_real
    annotation (Placement(transformation(extent={{-220,42},{-200,62}})));
  RunningMeanTemperature runningMeanTemperature
    annotation (Placement(transformation(extent={{-338,108},{-318,128}})));
  Modelica.Blocks.Sources.RealExpression TSetNigCooExpr(y=resPres.y*(TSetNigCoo -
        0.5) + (1 - resPres.y)*(TSetNigCoo - 0.5))
    annotation (Placement(transformation(extent={{-334,-62},{-314,-42}})));
  Modelica.Blocks.Sources.RealExpression TSetNigHeaExpr(y=resPres.y*(TSetNigHea +
        0.5) + (1 - resPres.y)*(TSetDefHea + 0.5))
    annotation (Placement(transformation(extent={{-334,-48},{-314,-28}})));
  Modelica.Blocks.Sources.RealExpression TSetDayHeaExpr(y=resPres.y*(TSetDayHea +
        0.5) + (1 - resPres.y)*(TSetDefHea + 0.5))
    annotation (Placement(transformation(extent={{-334,-20},{-314,0}})));
  Modelica.Blocks.Sources.RealExpression TSetDayCooExpr(y=resPres.y*(TSetDayCoo -
        0.5) + (1 - resPres.y)*(TSetDefCoo - 0.5))
    annotation (Placement(transformation(extent={{-334,-34},{-314,-14}})));
  Modelica.Blocks.Logical.Switch TSetSwitchHou1Nig
    annotation (Placement(transformation(extent={{-138,-30},{-118,-10}})));
  Modelica.Blocks.Logical.Switch TSetSwitchHou2Day
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Logical.Switch TSetSwitchHou2Nig
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Modelica.Blocks.Logical.Switch TSetSwitchHou3Day
    annotation (Placement(transformation(extent={{-138,-148},{-118,-128}})));
  Modelica.Blocks.Logical.Switch TSetSwitchHou3Nig
    annotation (Placement(transformation(extent={{-138,-178},{-118,-158}})));
  Modelica.Blocks.Logical.Switch TSetSwitchOff1
    annotation (Placement(transformation(extent={{90,-46},{70,-26}})));
  Modelica.Blocks.Logical.Switch TSetSwitchOff2
    annotation (Placement(transformation(extent={{90,-98},{70,-78}})));
  Modelica.Blocks.Logical.Switch TSetSwitchOff3
    annotation (Placement(transformation(extent={{90,-138},{70,-118}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold=12.5 + 273.15)
    annotation (Placement(transformation(extent={{-300,108},{-280,128}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-248,88},{-228,108}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-300,50},{-280,70}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=offPres.y > 0)
    annotation (Placement(transformation(extent={{-340,18},{-320,38}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=TSetOffCoo - 1.25, uHigh=
        TSetOffCoo - 1)
    annotation (Placement(transformation(extent={{-362,60},{-342,80}})));
  Modelica.Blocks.Sources.RealExpression TSenOffExpr(y=max(office1.substation.TSensor[
        1], office1.substation.TSensor[2])) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-392,70})));
  Modelica.Blocks.Sources.CombiTimeTable officeHours_Timeshift(
    fileName=Modelica.Utilities.Files.loadResource("modelica://DistrictHeating_5GDHC/Resources/OccupancyProfiles/office_hours_hourly.txt"),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    columns={2},
    shiftTime=-7200,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{222,66},{236,80}})));

  Modelica.Blocks.Sources.RealExpression offPres_shift(y=officeHours_Timeshift.y[
        1]) annotation (Placement(transformation(extent={{218,46},{238,66}})));
equation
  connect(jun1.port_2, jun4.port_1)
    annotation (Line(points={{8,-28},{8,-44}}, color={0,127,255}));
  connect(jun5.port_1, jun4.port_2)
    annotation (Line(points={{8,-68},{8,-56}}, color={0,127,255}));
  connect(jun2.port_1, jun3.port_2)
    annotation (Line(points={{-6,-38},{-6,-54}}, color={0,127,255}));
  connect(jun3.port_1, jun6.port_2)
    annotation (Line(points={{-6,-66},{-6,-80}}, color={0,127,255}));
  connect(jun7.port_2, jun6.port_1)
    annotation (Line(points={{-6,-108},{-6,-92}}, color={0,127,255}));
  connect(jun8.port_1, jun5.port_2)
    annotation (Line(points={{8,-98},{8,-80}}, color={0,127,255}));
  connect(jun8.port_2, jun9.port_1)
    annotation (Line(points={{8,-110},{8,-128}}, color={0,127,255}));
  connect(jun7.port_1, jun10.port_2)
    annotation (Line(points={{-6,-120},{-6,-140}}, color={0,127,255}));
  connect(collector.port_a1, port_a)
    annotation (Line(points={{9,96},{100,96},{100,160}}, color={0,127,255}));
  connect(collector.port_b1, port_b) annotation (Line(points={{-11,96},{-100,96},
          {-100,160}}, color={0,127,255}));
  connect(collector.port_b2, jun1.port_1)
    annotation (Line(points={{9,84},{8,84},{8,-16}}, color={0,127,255}));
  connect(jun2.port_2, collector.port_a2) annotation (Line(points={{-6,-26},{-4,
          -26},{-4,74},{-18,74},{-18,84},{-11,84}}, color={0,127,255}));
  connect(ExprElecPowerDistrictHeaPumps.y, Pnet.u[1]) annotation (Line(points={{251,
          -144},{264,-144},{264,-81},{156,-81}},    color={0,0,127}));
  connect(ExprElecPowerPumps.y, Pnet.u[2]) annotation (Line(points={{251,-164},{
          262,-164},{262,-79},{156,-79}},  color={0,0,127}));
  connect(Pnet.y, P)
    annotation (Line(points={{179,-80},{210,-80}}, color={0,0,127}));
  connect(jun1.port_3, house1.Sup)
    annotation (Line(points={{2,-22},{-64,-22},{-64,-30}}, color={0,127,255}));
  connect(house1.Ret, jun2.port_3) annotation (Line(points={{-64,-34},{-18,-34},
          {-18,-32},{-12,-32}}, color={0,127,255}));
  connect(house2.Sup, jun5.port_3) annotation (Line(points={{-64,-86},{-18,-86},
          {-18,-74},{2,-74}}, color={0,127,255}));
  connect(house2.Ret, jun6.port_3) annotation (Line(points={{-64,-90},{-18,-90},
          {-18,-98},{-10,-98},{-10,-90},{-12,-90},{-12,-86}}, color={0,127,255}));
  connect(house3.Sup, jun9.port_3) annotation (Line(points={{-60,-138},{-18,-138},
          {-18,-134},{2,-134}}, color={0,127,255}));
  connect(jun10.port_3, house3.Ret) annotation (Line(points={{-12,-146},{-60,-146},
          {-60,-142}}, color={0,127,255}));
  connect(office1.Sup, jun4.port_3) annotation (Line(points={{36,-52},{20,-52},{
          20,-50},{14,-50}}, color={0,127,255}));
  connect(office1.Ret, jun3.port_3) annotation (Line(points={{36,-56},{22,-56},{
          22,-60},{0,-60}}, color={0,127,255}));
  connect(office2.Sup, jun8.port_3) annotation (Line(points={{36,-106},{20,-106},
          {20,-104},{14,-104}}, color={0,127,255}));
  connect(office2.Ret, jun7.port_3) annotation (Line(points={{36,-110},{30,-110},
          {30,-112},{0,-112},{0,-114}}, color={0,127,255}));
  connect(office3.Sup, jun9.port_2) annotation (Line(points={{36,-140},{26,-140},
          {26,-142},{8,-142},{8,-140}}, color={0,127,255}));
  connect(office3.Ret, jun10.port_1) annotation (Line(points={{36,-144},{30,-144},
          {30,-160},{-6,-160},{-6,-152}}, color={0,127,255}));
  connect(TSetSwitchHou1Day.u2, TSetSwitchHou1Nig.u2) annotation (Line(points={{
          -140,10},{-160,10},{-160,-20},{-140,-20}}, color={255,0,255}));
  connect(TSetSwitchHou1Day.y, house1.TSet1[1])
    annotation (Line(points={{-117,10},{-74,10},{-74,-20}}, color={0,0,127}));
  connect(TSetSwitchHou1Nig.y, house1.TSet1[2]) annotation (Line(points={{-117,-20},
          {-104,-20},{-104,-6},{-74,-6},{-74,-20}}, color={0,0,127}));
  connect(TSetDayCooExpr.y, TSetSwitchHou1Day.u1) annotation (Line(points={{-313,
          -24},{-200,-24},{-200,18},{-140,18}}, color={0,0,127}));
  connect(TSetDayHeaExpr.y, TSetSwitchHou1Day.u3) annotation (Line(points={{-313,
          -10},{-184,-10},{-184,2},{-140,2}},                       color={0,0,127}));
  connect(TSetNigHeaExpr.y, TSetSwitchHou1Nig.u3) annotation (Line(points={{-313,
          -38},{-160,-38},{-160,-28},{-140,-28}}, color={0,0,127}));
  connect(TSetNigCooExpr.y, TSetSwitchHou1Nig.u1) annotation (Line(points={{-313,
          -52},{-236,-52},{-236,-54},{-180,-54},{-180,-12},{-140,-12}}, color={0,
          0,127}));
  connect(TSetSwitchHou2Day.y, house2.TSet1[1]) annotation (Line(points={{-119,-70},
          {-74,-70},{-74,-76}}, color={0,0,127}));
  connect(TSetSwitchHou2Nig.y, house2.TSet1[2]) annotation (Line(points={{-119,-100},
          {-100,-100},{-100,-62},{-74,-62},{-74,-76}}, color={0,0,127}));
  connect(TSetSwitchHou2Day.u1, TSetDayCooExpr.y) annotation (Line(points={{-142,
          -62},{-200,-62},{-200,-24},{-313,-24}}, color={0,0,127}));
  connect(TSetNigCooExpr.y, TSetSwitchHou2Nig.u1) annotation (Line(points={{-313,
          -52},{-236,-52},{-236,-54},{-180,-54},{-180,-92},{-142,-92}}, color={0,
          0,127}));
  connect(TSetSwitchHou2Day.u3, TSetSwitchHou1Day.u3) annotation (Line(points={{
          -142,-78},{-150,-78},{-150,2},{-140,2}}, color={0,0,127}));
  connect(TSetSwitchHou2Nig.u3, TSetSwitchHou1Nig.u3) annotation (Line(points={{
          -142,-108},{-160,-108},{-160,-28},{-140,-28}}, color={0,0,127}));
  connect(TSetSwitchHou1Nig.u2, TSetSwitchHou2Day.u2) annotation (Line(points={{
          -140,-20},{-156,-20},{-156,-70},{-142,-70}}, color={255,0,255}));
  connect(TSetSwitchHou1Nig.u2, TSetSwitchHou2Nig.u2) annotation (Line(points={{
          -140,-20},{-156,-20},{-156,-100},{-142,-100}}, color={255,0,255}));
  connect(TSetSwitchHou3Day.y, house3.TSet1[1]) annotation (Line(points={{-117,-138},
          {-110,-138},{-110,-136},{-102,-136},{-102,-116},{-72,-116},{-72,-128},
          {-70,-128}}, color={0,0,127}));
  connect(TSetSwitchHou3Nig.y, house3.TSet1[2]) annotation (Line(points={{-117,-168},
          {-92,-168},{-92,-108},{-70,-108},{-70,-128}}, color={0,0,127}));
  connect(TSetSwitchHou2Nig.u2, TSetSwitchHou3Day.u2) annotation (Line(points={{
          -142,-100},{-156,-100},{-156,-138},{-140,-138}}, color={255,0,255}));
  connect(TSetSwitchHou3Nig.u2, TSetSwitchHou3Day.u2) annotation (Line(points={{
          -140,-168},{-156,-168},{-156,-138},{-140,-138}}, color={255,0,255}));
  connect(TSetSwitchHou3Day.u1, TSetDayCooExpr.y) annotation (Line(points={{-140,
          -130},{-200,-130},{-200,-24},{-313,-24}}, color={0,0,127}));
  connect(TSetSwitchHou3Day.u3, TSetSwitchHou1Day.u3) annotation (Line(points={{
          -140,-146},{-150,-146},{-150,2},{-140,2}}, color={0,0,127}));
  connect(TSetSwitchHou3Nig.u1, TSetSwitchHou2Nig.u1) annotation (Line(points={{
          -140,-160},{-180,-160},{-180,-92},{-142,-92}}, color={0,0,127}));
  connect(TSetSwitchHou3Nig.u3, TSetSwitchHou1Nig.u3) annotation (Line(points={{
          -140,-176},{-160,-176},{-160,-28},{-140,-28}}, color={0,0,127}));
  connect(house1.coolingOn1, house2.coolingOn1) annotation (Line(points={{-70,-20},
          {-58,-20},{-58,-76},{-70,-76}}, color={255,0,255}));
  connect(house3.coolingOn1, house2.coolingOn1) annotation (Line(points={{-66,-128},
          {-58,-128},{-58,-76},{-70,-76}}, color={255,0,255}));
  connect(house1.coolingOn1, coolingPeriod_real.u) annotation (Line(points={{-70,
          -20},{-70,62},{-228,62},{-228,52},{-222,52}}, color={255,0,255}));
  connect(house1.coolingOn1, office1.coolingOn1) annotation (Line(points={{-70,-20},
          {-58,-20},{-58,0},{40,0},{40,-42},{42,-42}}, color={255,0,255}));
  connect(office2.coolingOn1, office1.coolingOn1) annotation (Line(points={{42,-96},
          {30,-96},{30,-42},{42,-42}}, color={255,0,255}));
  connect(office3.coolingOn1, office1.coolingOn1) annotation (Line(points={{42,-130},
          {30,-130},{30,-42},{42,-42}}, color={255,0,255}));
  connect(TSetOffCooExpr.y, TSetSwitchOff1.u1) annotation (Line(points={{119,-78},
          {110,-78},{110,-28},{92,-28}}, color={0,0,127}));
  connect(TSetOffHeaExpr.y, TSetSwitchOff1.u3) annotation (Line(points={{121,-94},
          {116,-94},{116,-44},{92,-44}}, color={0,0,127}));
  connect(TSetSwitchOff1.y, office1.TSet1[1])
    annotation (Line(points={{69,-36},{50,-36},{50,-42}}, color={0,0,127}));
  connect(TSetSwitchOff1.y, office1.TSet1[2])
    annotation (Line(points={{69,-36},{60,-36},{60,-30},{52,-30},{52,-36},{50,
          -36},{50,-42}},                                 color={0,0,127}));
  connect(TSetOffCooExpr.y, TSetSwitchOff2.u1) annotation (Line(points={{119,-78},
          {100,-78},{100,-80},{92,-80}}, color={0,0,127}));
  connect(TSetOffHeaExpr.y, TSetSwitchOff2.u3) annotation (Line(points={{121,-94},
          {100,-94},{100,-96},{92,-96}}, color={0,0,127}));
  connect(TSetSwitchOff2.u2, TSetSwitchOff1.u2) annotation (Line(points={{92,-88},
          {102,-88},{102,-36},{92,-36}},                   color={255,0,255}));
  connect(TSetSwitchOff2.y, office2.TSet1[1])
    annotation (Line(points={{69,-88},{50,-88},{50,-96}}, color={0,0,127}));
  connect(TSetSwitchOff2.y, office2.TSet1[2])
    annotation (Line(points={{69,-88},{50,-88},{50,-96}}, color={0,0,127}));
  connect(TSetSwitchOff3.y, office3.TSet1[1]) annotation (Line(points={{69,-128},
          {62,-128},{62,-126},{46,-126},{46,-130},{50,-130}}, color={0,0,127}));
  connect(TSetSwitchOff3.y, office3.TSet1[2]) annotation (Line(points={{69,-128},
          {62,-128},{62,-126},{50,-126},{50,-130}}, color={0,0,127}));
  connect(TSetOffCooExpr.y, TSetSwitchOff3.u1) annotation (Line(points={{119,-78},
          {110,-78},{110,-120},{92,-120}}, color={0,0,127}));
  connect(TSetOffHeaExpr.y, TSetSwitchOff3.u3) annotation (Line(points={{121,-94},
          {116,-94},{116,-136},{92,-136}}, color={0,0,127}));
  connect(TSetSwitchOff2.u2, TSetSwitchOff3.u2) annotation (Line(points={{92,-88},
          {102,-88},{102,-128},{92,-128}}, color={255,0,255}));
  connect(TSetSwitchOff1.u2, coolingPeriod_real.u) annotation (Line(points={{92,
          -36},{102,-36},{102,62},{-228,62},{-228,52},{-222,52}}, color={255,0,
          255}));
  connect(TSetSwitchHou1Day.u2, coolingPeriod_real.u) annotation (Line(points={{
          -140,10},{-228,10},{-228,52},{-222,52}}, color={255,0,255}));
  connect(runningMeanTemperature.y, greaterThreshold2.u)
    annotation (Line(points={{-317.4,118},{-302,118}}, color={0,0,127}));
  connect(greaterThreshold2.y, or1.u1) annotation (Line(points={{-279,118},{-264,
          118},{-264,98},{-250,98}}, color={255,0,255}));
  connect(or1.y, coolingPeriod_real.u) annotation (Line(points={{-227,98},{-214,
          98},{-214,78},{-238,78},{-238,52},{-222,52}}, color={255,0,255}));
  connect(booleanExpression.y, and2.u2) annotation (Line(points={{-319,28},{-308,
          28},{-308,52},{-302,52}}, color={255,0,255}));
  connect(and2.y, or1.u2) annotation (Line(points={{-279,60},{-260,60},{-260,90},
          {-250,90}}, color={255,0,255}));
  connect(hysteresis.y, and2.u1) annotation (Line(points={{-341,70},{-326,70},{-326,
          68},{-302,68},{-302,60}}, color={255,0,255}));
  connect(TSenOffExpr.y, hysteresis.u)
    annotation (Line(points={{-381,70},{-364,70}}, color={0,0,127}));
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
end MixedUseRBC;
