within IOCSmod.Simulation.IndividualBuildings;
model Gesl_M_A_ASHP_ASCHI
  replaceable package MediumAir = IDEAS.Media.Air "Medium in the component";
  replaceable package Medium = IDEAS.Media.Water;

  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  parameter Real [nZones] n= (3.6/nZones).*bui.AZones./bui.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*bui.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = bui.nZones
    "Number of conditioned thermal building zones";
  parameter Modelica.Units.SI.Power[nZones] Q_design = {2130,1534}
    "Total design heat load for heating system based on heat losses"
    annotation (Dialog(enable=InInterface));
  parameter Modelica.Units.SI.Area A_floor[nZones] = bui.AZones "Floor/tabs surface area";



  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_nominal = 4184 "Specific heat capacity of water";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_dh= sum(Q_design)/cp_nominal/3 "Nominal mass flow rate coming from dhc net (maximum T variation of +-3°C)";

  // Heat Pump
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_eva= m_flow_nom_dh "Nominal mass flow rate at the evaporator side";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_con= floHea1.m_flow_nominal+floHea2.m_flow_nominal "Nominal mass flow rate at the condenser side (or at cold side of HExCool)";
  parameter Modelica.Units.SI.PressureDifference dp_nom_eva=20000 "Nominal pressure drop at the evaporator side";
  parameter Modelica.Units.SI.PressureDifference dp_nom_con=20000 "Nominal pressure drop at the condenser side";

  // Floor Heating
  parameter Modelica.Units.SI.TemperatureDifference dTFloHea_nom=5 "Nominal temperature difference in floor heating";

  // Three Way Valves
  //parameter Real Kv_TWValves=6.3;
  //final parameter Modelica.Units.SI.PressureDifference dp_nom_TWvalFH=(m_flow_nom_con/(threeWayValFh.Kv*1000/3600/sqrt(1E5)))^2;
  //final parameter Modelica.Units.SI.PressureDifference dp_nom_TWvalSelSup=(m_flow_nom_dh/(threeWayValSelSup.Kv*1000/3600/sqrt(1E5)))^2;

  //Final
  parameter Modelica.Units.SI.PressureDifference dp_nominal = dp_nom_eva "Nominal pressure drop of the HVAC block seen by the central pump";

   DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Gesl_M.Gesl_M_Structure_A bui(useFluPor=
       true, redeclare package Medium = MediumAir)
        annotation (Placement(transformation(extent={{-14,-10},{16,10}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=0)
    annotation(Placement(transformation(extent={{60, 30}, {40, 50}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=0)
    annotation(Placement(transformation(extent={{60, 10}, {40, 30}})));
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


  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_design[1]/dTFloHea_nom/cp_nominal,
    dp_nominal=1000,
    A_floor=A_floor[1])    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={110,-10})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=90,
        origin={100,88})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_design[2]/dTFloHea_nom/cp_nominal,
    dp_nominal=1000,
    A_floor=A_floor[2])
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,10})));
  UnitTests.Components.TwoWayLinear   valFloHea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea1.m_flow_nominal,
    Kv=5,
    dpValve_nominal=10000)             annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={110,40})));
  UnitTests.Components.TwoWayLinear   valFloHea2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea2.m_flow_nominal,
    Kv=5,
    dpValve_nominal=10000)             annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={80,40})));
  IDEAS.Fluid.Movers.FlowControlled_dp pumFloHea(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=floHea1.m_flow_nominal + floHea2.m_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    use_inputFilter=false,
    dp_nominal=floHea1.dp_nominal + valFloHea1.dpValve_nominal)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={170,70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEmIn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_con,
    tau=0) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={130,70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEmOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_con,
    tau=0) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={130,-50})));
  IDEAS.Fluid.MixingVolumes.MixingVolume Tank(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=AsHp.Qnom_AsHp*3600/100/4180/40,
    nPorts=6) annotation (Placement(transformation(extent={{190,6},{210,26}})));
  DeSchipjes.Components.RunningMeanTemperature runningMeanTemperature1
    annotation (Placement(transformation(extent={{-116,178},{-96,198}})));
  IDEAS.Controls.SetPoints.Table heatingCurveTSet(table=[273.15 - 10,273.15 + 45;
        273.15 + 5,273.15 + 40; 273.15 + 20,273.15 + 25])
    annotation (Placement(transformation(extent={{-86,178},{-66,198}})));
  IDEAS.Controls.Continuous.LimPID radPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,130})));
  DeSchipjes.Components.OnOff onOffHeaDay
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Modelica.Blocks.Sources.RealExpression TSetDayHea(y=21.5 + 273.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={2,130})));
  Modelica.Blocks.Sources.RealExpression TSetNigHea1(y=18.5 + 273.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={16,168})));
  IDEAS.Controls.Continuous.LimPID radPI1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={44,168})));
  DeSchipjes.Components.OnOff onOffHeaNig
    annotation (Placement(transformation(extent={{74,158},{94,178}})));
  ComponentModels.Thermal.AsHp AsHp(
    addDummyEquation=false,
    Qnom_AsHp=10000,
    AsHp(HP(mod=ASHPControl.y,
        con(
    energyDynamics =           Modelica.Fluid.Types.Dynamics.SteadyState),
        eva(
    energyDynamics =           Modelica.Fluid.Types.Dynamics.SteadyState))))
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={250,-52})));
  Modelica.Blocks.Sources.BooleanExpression HeaOn(y=if (runningMeanTemperature1.y >
        (15 + 273.15)) or (bui.TSensor[1] > 23.5 + 273.15 and bui.TSensor[2] > 21
         + 273.15) then false else true)
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Modelica.Blocks.Sources.RealExpression ASHPControl(y=if stateHpOn.active and
        HeaOn.y then 1 else 0)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={286,-50})));
  Modelica_StateGraph2.Step stateHpOff(
    initialStep=true,
    nOut=1,
    nIn=1) annotation (Placement(transformation(extent={{214,-92},{222,-100}})));
  Modelica_StateGraph2.Transition transHpOn(
    use_conditionPort=false,
    condition=(Tank.T < heatingCurveTSet.y - 3) and (timerHpOff.y > 300 -
        transHpOn.waitTime) and (timerStartHp.y > 1800 - transHpOn.waitTime),
    delayedTransition=false,
    waitTime=180) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={238,-86})));
  Modelica_StateGraph2.Transition transHpOff(
    use_conditionPort=false,
    condition=(Tank.T > heatingCurveTSet.y + 5) and (timerHpOn.y > 1200 -
        transHpOff.waitTime),
    delayedTransition=false,
    waitTime=300) annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={238,-106})));

  Modelica_StateGraph2.Step stateHpOn(
    initialStep=false,
    use_activePort=true,
    nIn=1,
    nOut=1) annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=180,
        origin={258,-96})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{273,-131},{283,-121}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{223,-131},{213,-121}})));
  Modelica.Blocks.Logical.Timer timerHpOff
    annotation (Placement(transformation(extent={{203,-131},{193,-121}})));
  Modelica.Blocks.MathBoolean.RisingEdge startHp
    annotation (Placement(transformation(extent={{254,-130},{262,-122}})));
  Modelica.Blocks.Logical.Timer timerStartHp
    annotation (Placement(transformation(extent={{293,-131},{303,-121}})));
  Modelica.Blocks.Logical.Timer timerHpOn
    annotation (Placement(transformation(extent={{283,-81},{293,-71}})));
  IDEAS.Controls.Continuous.LimPID ChiPi(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reverseActing=false,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={342,24})));
  Modelica.Blocks.Sources.RealExpression TtankExpr(y=Tank.T) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={306,4})));
  Modelica.Blocks.Sources.RealExpression TtankSetCoo(y=17 + 273.15) annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={306,24})));
  Modelica.Blocks.Sources.RealExpression ASCHIControl(y=if CooOn.y then ChiPi.y
         else 0)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={248,20})));
  ComponentModels.Thermal.AsChi AsChi(
    addDummyEquation=false,           Qnom_AsChi=8000,
    AsChi(Chi(
  mod =         ASCHIControl.y)))
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={250,-10})));
  Modelica.Blocks.Logical.Switch switchNig annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={134,144})));
  Modelica.Blocks.Sources.RealExpression TSetCooNig(y=23 + 273.15) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={284,170})));
  IDEAS.Controls.Continuous.LimPID radPI2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reverseActing=false,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={250,170})));
  DeSchipjes.Components.OnOff onOffCooNig
    annotation (Placement(transformation(extent={{220,160},{200,180}})));
  DeSchipjes.Components.OnOff onOffCooDay
    annotation (Placement(transformation(extent={{220,120},{200,140}})));
  IDEAS.Controls.Continuous.LimPID radPI3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reverseActing=false,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={250,130})));
  Modelica.Blocks.Sources.RealExpression TSetDayCoo(y=23 + 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={284,130})));
  Modelica.Blocks.Sources.BooleanExpression CooOn(y=if HeaOn.y then false else true)
    annotation (Placement(transformation(extent={{320,136},{300,156}})));
  Modelica.Blocks.Logical.Switch switchDay annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={164,144})));
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
  connect(floHea1.heatPortEmb[1], bui.heatPortEmb[1]) annotation (Line(points={{
          100,-10},{40,-10},{40,6},{16,6}}, color={191,0,0}));
  connect(floHea2.heatPortEmb[1], bui.heatPortEmb[2])
    annotation (Line(points={{70,10},{40,10},{40,6},{16,6}}, color={191,0,0}));
  connect(valFloHea2.port_b, floHea2.port_a)
    annotation (Line(points={{80,32},{80,20}}, color={0,127,255}));
  connect(valFloHea1.port_b, floHea1.port_a)
    annotation (Line(points={{110,32},{110,0}}, color={0,127,255}));
  connect(floHea2.port_b, TEmOut.port_a)
    annotation (Line(points={{80,0},{80,-50},{124,-50}}, color={0,127,255}));
  connect(floHea1.port_b, TEmOut.port_a) annotation (Line(points={{110,-20},{110,
          -50},{124,-50}}, color={0,127,255}));
  connect(TEmIn.port_b, valFloHea1.port_a)
    annotation (Line(points={{124,70},{110,70},{110,48}}, color={0,127,255}));
  connect(TEmIn.port_b, valFloHea2.port_a)
    annotation (Line(points={{124,70},{80,70},{80,48}}, color={0,127,255}));
  connect(bou.ports[1], TEmIn.port_b)
    annotation (Line(points={{100,82},{100,70},{124,70}}, color={0,127,255}));
  connect(pumFloHea.port_b, TEmIn.port_a)
    annotation (Line(points={{160,70},{136,70}}, color={0,127,255}));
  connect(pumFloHea.port_a, Tank.ports[1]) annotation (Line(points={{180,70},{
          180,-2},{196.667,-2},{196.667,6}},
                                 color={0,127,255}));
  connect(TEmOut.port_b, Tank.ports[2])
    annotation (Line(points={{136,-50},{198,-50},{198,6}}, color={0,127,255}));
  connect(runningMeanTemperature1.y, heatingCurveTSet.u)
    annotation (Line(points={{-95.4,188},{-88,188}}, color={0,0,127}));
  connect(radPI.y, onOffHeaDay.u1)
    annotation (Line(points={{41,130},{58,130}}, color={0,0,127}));
  connect(TSetDayHea.y, radPI.u_s)
    annotation (Line(points={{13,130},{18,130}}, color={0,0,127}));
  connect(bui.TSensor[1], radPI.u_m)
    annotation (Line(points={{16.6,-6},{30,-6},{30,118}}, color={0,0,127}));
  connect(TSetNigHea1.y, radPI1.u_s)
    annotation (Line(points={{27,168},{32,168}}, color={0,0,127}));
  connect(bui.TSensor[2], radPI1.u_m) annotation (Line(points={{16.6,-6},{30,-6},
          {30,108},{44,108},{44,156}}, color={0,0,127}));
  connect(radPI1.y, onOffHeaNig.u1)
    annotation (Line(points={{55,168},{72,168}}, color={0,0,127}));
  connect(HeaOn.y, radPI1.trigger)
    annotation (Line(points={{-39,150},{36,150},{36,156}}, color={255,0,255}));
  connect(onOffHeaNig.u, HeaOn.y)
    annotation (Line(points={{84,156},{84,150},{-39,150}}, color={255,0,255}));
  connect(onOffHeaDay.u, HeaOn.y) annotation (Line(points={{70,118},{70,104},{-28,
          104},{-28,150},{-39,150}}, color={255,0,255}));
  connect(radPI.trigger, HeaOn.y) annotation (Line(points={{22,118},{22,104},{-28,
          104},{-28,150},{-39,150}}, color={255,0,255}));
  connect(transHpOn.inPort,stateHpOff. outPort[1])
    annotation (Line(points={{234,-86},{218,-86},{218,-91.4}},
                                                           color={0,0,0}));
  connect(not1.y,timerHpOff. u)
    annotation (Line(points={{212.5,-126},{204,-126}},
                                                   color={255,0,255}));
  connect(transHpOn.outPort,stateHpOn. inPort[1])
    annotation (Line(points={{243,-86},{258,-86},{258,-92}},
                                                      color={0,0,0}));
  connect(stateHpOn.outPort[1],transHpOff. inPort)
    annotation (Line(points={{258,-100.6},{258,-106},{242,-106}},
                                                        color={0,0,0}));
  connect(transHpOff.outPort,stateHpOff. inPort[1])
    annotation (Line(points={{233,-106},{218,-106},{218,-100}},
                                                         color={0,0,0}));
  connect(not1.u,startHp. u)
    annotation (Line(points={{224,-126},{252.4,-126}},
                                                  color={255,0,255}));
  connect(startHp.y,not2. u)
    annotation (Line(points={{262.8,-126},{272,-126}},
                                                 color={255,0,255}));
  connect(not2.y,timerStartHp. u)
    annotation (Line(points={{283.5,-126},{292,-126}},
                                                 color={255,0,255}));
  connect(stateHpOn.activePort,startHp. u) annotation (Line(points={{262.72,-96},
          {278,-96},{278,-116},{238,-116},{238,-126},{252.4,-126}},
                                                    color={255,0,255}));
  connect(stateHpOn.activePort, timerHpOn.u) annotation (Line(points={{262.72,
          -96},{278,-96},{278,-76},{282,-76}},
                                          color={255,0,255}));
  connect(Tank.ports[3], AsHp.port_a)
    annotation (Line(points={{199.333,6},{199.333,-58},{240,-58}},
                                                           color={0,127,255}));
  connect(AsHp.port_b, Tank.ports[4]) annotation (Line(points={{240,-46},{208,
          -46},{208,-42},{200.667,-42},{200.667,6}},
                                        color={0,127,255}));
  connect(TtankExpr.y, ChiPi.u_m)
    annotation (Line(points={{317,4},{342,4},{342,12}},      color={0,0,127}));
  connect(TtankSetCoo.y, ChiPi.u_s)
    annotation (Line(points={{317,24},{330,24}},   color={0,0,127}));
  connect(AsChi.port_b, Tank.ports[5])
    annotation (Line(points={{240,-4},{202,-4},{202,6}}, color={0,127,255}));
  connect(AsChi.port_a, Tank.ports[6]) annotation (Line(points={{240,-16},{200,
          -16},{200,6},{203.333,6}},
                                color={0,127,255}));
  connect(HeaOn.y, switchNig.u2) annotation (Line(points={{-39,150},{112,150},{112,
          164},{134,164},{134,156}}, color={255,0,255}));
  connect(onOffHeaNig.y, switchNig.u1) annotation (Line(points={{95,168},{95,170},
          {126,170},{126,156}}, color={0,0,127}));
  connect(CooOn.y, radPI2.trigger) annotation (Line(points={{299,146},{258,146},
          {258,158}}, color={255,0,255}));
  connect(CooOn.y, onOffCooNig.u) annotation (Line(points={{299,146},{210,146},{
          210,158}}, color={255,0,255}));
  connect(CooOn.y, radPI3.trigger) annotation (Line(points={{299,146},{298,146},
          {298,110},{258,110},{258,118}}, color={255,0,255}));
  connect(CooOn.y, onOffCooDay.u) annotation (Line(points={{299,146},{298,146},{
          298,110},{210,110},{210,118}}, color={255,0,255}));
  connect(bui.TSensor[1], radPI3.u_m) annotation (Line(points={{16.6,-6},{30,-6},
          {30,102},{250,102},{250,118}}, color={0,0,127}));
  connect(bui.TSensor[2], radPI2.u_m) annotation (Line(points={{16.6,-6},{30,-6},
          {30,102},{184,102},{184,152},{250,152},{250,158}}, color={0,0,127}));
  connect(TSetCooNig.y, radPI2.u_s)
    annotation (Line(points={{273,170},{262,170}}, color={0,0,127}));
  connect(switchDay.u2, switchNig.u2) annotation (Line(points={{164,156},{164,164},
          {134,164},{134,156}}, color={255,0,255}));
  connect(onOffHeaDay.y, switchDay.u1) annotation (Line(points={{81,130},{110,130},
          {110,176},{156,176},{156,156}}, color={0,0,127}));
  connect(onOffCooNig.y, switchNig.u3)
    annotation (Line(points={{199,170},{142,170},{142,156}}, color={0,0,127}));
  connect(onOffCooDay.y, switchDay.u3) annotation (Line(points={{199,130},{178,130},
          {178,156},{172,156}}, color={0,0,127}));
  connect(switchNig.y, valFloHea2.y) annotation (Line(points={{134,133},{134,114},
          {89.6,114},{89.6,40}}, color={0,0,127}));
  connect(valFloHea1.y, switchDay.y) annotation (Line(points={{119.6,40},{150,40},
          {150,114},{164,114},{164,133}}, color={0,0,127}));
  connect(TSetDayCoo.y, radPI3.u_s) annotation (Line(points={{273,130},{273,128},
          {262,128},{262,130}}, color={0,0,127}));
  connect(radPI2.y, onOffCooNig.u1) annotation (Line(points={{239,170},{239,172},
          {222,172},{222,170}}, color={0,0,127}));
  connect(radPI3.y, onOffCooDay.u1)
    annotation (Line(points={{239,130},{222,130}}, color={0,0,127}));
  connect(CooOn.y, ChiPi.trigger) annotation (Line(points={{299,146},{298,146},{
          298,66},{322,66},{322,12},{334,12}}, color={255,0,255}));
annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {340,100}}),                                     graphics={
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{340,100}})),
  experiment(
      StopTime=30240000,
      Interval=60,
      __Dymola_fixedstepsize=15,
      __Dymola_Algorithm="Euler"),
  Documentation(info="<html> 
         <p>Q_design = QzoneDay kW (DayZone) &amp; QzoneNight kW (NightZone)</p> 
         <p>UA_building = UAbuilding W/K</p> 
         <p>Roof</p> 
         <ul><li>Side1: Surface1 m2, tilt = Tilt1 rad (Tilt1deg &deg;)</li><li>Side2: Surface2 m2, tilt = Tilt2 rad (Tilt2deg &deg;)<br></li></ul> 
         </html>", revisions="<html><ul><li>March 5, 2024, by Lucas Verleyen:<br> Remove mass flow sources and set useFluPor = false.<li>October 9, 2023, by Lucas Verleyen:<br> Initial implementation.</li></ul></html>"));
end Gesl_M_A_ASHP_ASCHI;
