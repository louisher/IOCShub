within IOCSmod.Simulation.IndividualBuildings;
model Office_A_ASHP_ASCHI

  replaceable package MediumAir = IDEAS.Media.Air "Medium in the component";
  replaceable package Medium = IDEAS.Media.Water;
 inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";

  parameter Real [nZones] n= (3.6/nZones).*office.AZones./office.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*office.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = office.nZones
    "Number of conditioned thermal building zones";

  parameter Modelica.Units.SI.Power[nZones] Q_design = {6000,6000}
    "Total design heat load for heating system based on heat losses"
    annotation (Dialog(enable=InInterface));
  parameter Modelica.Units.SI.Area A_floor[nZones] = office.AZones "Floor/tabs surface area";

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_nominal = 4184 "Specific heat capacity of water";


  // Floor Heating
  parameter Modelica.Units.SI.TemperatureDifference dTFloHea_nom=5 "Nominal temperature difference in floor heating";
  Modelica.Blocks.Sources.RealExpression nOccOff(y=10*offPres.y)
    "min 10 m2/officer (100m2/zone)"                             annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,22})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QflowComNor
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={4,-24})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QflowComSou
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={4,-40})));
  Modelica.Blocks.Sources.RealExpression QCom(y=55*nOccOff.y)     annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-32,-32})));
  Modelica.Blocks.Sources.RealExpression offPres(y=officeHours.y[1])
    annotation (Placement(transformation(extent={{80,64},{98,80}})));
  Modelica.Blocks.Sources.CombiTimeTable officeHours(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://DistrictHeating_5GDHC/Resources/OccupancyProfiles/office_hours_hourly.txt"),
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{82,80},{96,94}})));
  DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Office.Office_Structure_A office(useFluPor=true, redeclare
      package Medium =                                                                                                            MediumAir)
    annotation (Placement(transformation(extent={{-16,-10},{14,10}})));

   IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hex(redeclare package
      Medium1 =                                                                     MediumAir,
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
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_design[1]/dTFloHea_nom/cp_nominal,
    dp_nominal=1000,
    A_floor=A_floor[1])    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={184,4})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=90,
        origin={174,102})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=Q_design[2]/dTFloHea_nom/cp_nominal,
    dp_nominal=1000,
    A_floor=A_floor[2])
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={154,24})));
  UnitTests.Components.TwoWayLinear   valFloHea1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea1.m_flow_nominal,
    Kv=5,
    dpValve_nominal=10000)             annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={184,54})));
  UnitTests.Components.TwoWayLinear   valFloHea2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea2.m_flow_nominal,
    Kv=5,
    dpValve_nominal=10000)             annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={154,54})));
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
        origin={244,84})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEmIn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=floHea1.m_flow_nominal + floHea2.m_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={204,84})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TEmOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=floHea1.m_flow_nominal + floHea2.m_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={204,-36})));
  IDEAS.Fluid.MixingVolumes.MixingVolume Tank(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=1,
    V=AsHp.Qnom_AsHp*3600/100/4180/40,
    nPorts=6) annotation (Placement(transformation(extent={{264,20},{284,40}})));
  ComponentModels.Thermal.AsHp AsHp(
    addDummyEquation=false,
    Qnom_AsHp=10000,
    AsHp(HP(
        mod=ASHPControl.y,
        con(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
        eva(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))))
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={324,-38})));
  Modelica.Blocks.Sources.RealExpression ASHPControl(y=if stateHpOn.active and
        HeaOn.y then 1 else 0)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={360,-36})));
  Modelica_StateGraph2.Step stateHpOff(
    initialStep=true,
    nOut=1,
    nIn=1) annotation (Placement(transformation(extent={{288,-78},{296,-86}})));
  Modelica_StateGraph2.Transition transHpOn(
    use_conditionPort=false,
    condition=(Tank.T < heatingCurveTSet.y - 3) and (timerHpOff.y > 300 -
        transHpOn.waitTime) and (timerStartHp.y > 1800 - transHpOn.waitTime),
    delayedTransition=false,
    waitTime=180) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={312,-72})));
  Modelica_StateGraph2.Transition transHpOff(
    use_conditionPort=false,
    condition=(Tank.T > heatingCurveTSet.y + 5) and (timerHpOn.y > 1200 -
        transHpOff.waitTime),
    delayedTransition=false,
    waitTime=300) annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={312,-92})));
  Modelica_StateGraph2.Step stateHpOn(
    initialStep=false,
    use_activePort=true,
    nIn=1,
    nOut=1) annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=180,
        origin={332,-82})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{347,-117},{357,-107}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{297,-117},{287,-107}})));
  Modelica.Blocks.Logical.Timer timerHpOff
    annotation (Placement(transformation(extent={{277,-117},{267,-107}})));
  Modelica.Blocks.MathBoolean.RisingEdge startHp
    annotation (Placement(transformation(extent={{328,-116},{336,-108}})));
  Modelica.Blocks.Logical.Timer timerStartHp
    annotation (Placement(transformation(extent={{367,-117},{377,-107}})));
  Modelica.Blocks.Logical.Timer timerHpOn
    annotation (Placement(transformation(extent={{357,-67},{367,-57}})));
  IDEAS.Controls.Continuous.LimPID ChiPi(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reverseActing=false,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={416,38})));
  Modelica.Blocks.Sources.RealExpression TtankExpr(y=Tank.T) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={380,18})));
  Modelica.Blocks.Sources.RealExpression TtankSetCoo(y=17 + 273.15) annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={380,38})));
  Modelica.Blocks.Sources.RealExpression ASCHIControl(y=if CooOn.y then ChiPi.y
         else 0)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={322,34})));
  ComponentModels.Thermal.AsChi AsChi(
    addDummyEquation=false,
    Qnom_AsChi=15000,
    AsChi(Chi(mod=ASCHIControl.y)))
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={324,4})));
  DeSchipjes.Components.RunningMeanTemperature runningMeanTemperature1
    annotation (Placement(transformation(extent={{-42,192},{-22,212}})));
  IDEAS.Controls.SetPoints.Table heatingCurveTSet(table=[273.15 - 10,273.15 + 45;
        273.15 + 5,273.15 + 40; 273.15 + 20,273.15 + 25])
    annotation (Placement(transformation(extent={{-12,192},{8,212}})));
  IDEAS.Controls.Continuous.LimPID radPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={104,144})));
  DeSchipjes.Components.OnOff onOffHeaDay
    annotation (Placement(transformation(extent={{134,134},{154,154}})));
  Modelica.Blocks.Sources.RealExpression TSetDayHea(y=21.5 + 273.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={76,144})));
  Modelica.Blocks.Sources.RealExpression TSetNigHea1(y=21.5 + 273.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={90,182})));
  IDEAS.Controls.Continuous.LimPID radPI1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={118,182})));
  DeSchipjes.Components.OnOff onOffHeaNig
    annotation (Placement(transformation(extent={{148,172},{168,192}})));
  Modelica.Blocks.Sources.BooleanExpression HeaOn(y=if (runningMeanTemperature1.y >
        (13 + 273.15)) or (office.TSensor[1] > 23 + 273.15 and office.TSensor[2] >
        23 + 273.15) then false else true)
    annotation (Placement(transformation(extent={{14,154},{34,174}})));
  Modelica.Blocks.Logical.Switch switchNig annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={208,158})));
  Modelica.Blocks.Sources.RealExpression TSetCooNig(y=23 + 273.15) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={358,184})));
  IDEAS.Controls.Continuous.LimPID radPI2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reverseActing=false,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={324,184})));
  DeSchipjes.Components.OnOff onOffCooNig
    annotation (Placement(transformation(extent={{294,174},{274,194}})));
  DeSchipjes.Components.OnOff onOffCooDay
    annotation (Placement(transformation(extent={{294,134},{274,154}})));
  IDEAS.Controls.Continuous.LimPID radPI3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.8*0.2,
    Ti=1.5*1000,
    yMax=1,
    reverseActing=false,
    reset=IDEAS.Types.Reset.Parameter) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={324,144})));
  Modelica.Blocks.Sources.RealExpression TSetDayCoo(y=23 + 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={358,144})));
  Modelica.Blocks.Sources.BooleanExpression CooOn(y=if HeaOn.y then false else true)
    annotation (Placement(transformation(extent={{394,150},{374,170}})));
  Modelica.Blocks.Logical.Switch switchDay annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={238,158})));
equation
  connect(QCom.y,QflowComNor. Q_flow) annotation (Line(points={{-21,-32},{-14,
          -32},{-14,-24},{-6,-24}},
                             color={0,0,127}));
  connect(QCom.y,QflowComSou. Q_flow) annotation (Line(points={{-21,-32},{-14,
          -32},{-14,-40},{-6,-40}},
                               color={0,0,127}));
  connect(nOccOff.y, office.occ[1])
    annotation (Line(points={{19,22},{5,22},{5,10}},color={0,0,127}));
  connect(nOccOff.y, office.occ[2])
    annotation (Line(points={{19,22},{5,22},{5,10}},color={0,0,127}));
  connect(office.heatPortCon[1], QflowComNor.port) annotation (Line(points={{14,
          2},{20,2},{20,-24},{14,-24}}, color={191,0,0}));
  connect(office.heatPortCon[2], QflowComSou.port) annotation (Line(points={{14,
          2},{20,2},{20,-40},{14,-40}}, color={191,0,0}));
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
  connect(office.port_a, fanSup.port_b) annotation (Line(points={{1,10},{2,10},{
          2,34},{-10,34}}, color={0,127,255}));
  connect(office.port_b, fanRet.port_a) annotation (Line(points={{-3,10},{-2,10},
          {-2,60},{-10,60}}, color={0,127,255}));
  connect(bouAir.ports[1], hex.port_b1) annotation (Line(points={{-82,47.2},{-76,
          47.2},{-76,52},{-70,52}}, color={0,127,255}));
  connect(hex.port_a2, bouAir.ports[2]) annotation (Line(points={{-70,40},{-78,40},
          {-78,44.8},{-82,44.8}}, color={0,127,255}));
  connect(valFloHea2.port_b,floHea2. port_a)
    annotation (Line(points={{154,46},{154,34}},
                                               color={0,127,255}));
  connect(valFloHea1.port_b,floHea1. port_a)
    annotation (Line(points={{184,46},{184,14}},color={0,127,255}));
  connect(floHea2.port_b,TEmOut. port_a)
    annotation (Line(points={{154,14},{154,-36},{198,-36}},
                                                         color={0,127,255}));
  connect(floHea1.port_b,TEmOut. port_a) annotation (Line(points={{184,-6},{184,
          -36},{198,-36}}, color={0,127,255}));
  connect(TEmIn.port_b,valFloHea1. port_a)
    annotation (Line(points={{198,84},{184,84},{184,62}}, color={0,127,255}));
  connect(TEmIn.port_b,valFloHea2. port_a)
    annotation (Line(points={{198,84},{154,84},{154,62}},
                                                        color={0,127,255}));
  connect(bou.ports[1],TEmIn. port_b)
    annotation (Line(points={{174,96},{174,84},{198,84}}, color={0,127,255}));
  connect(pumFloHea.port_b,TEmIn. port_a)
    annotation (Line(points={{234,84},{210,84}}, color={0,127,255}));
  connect(pumFloHea.port_a,Tank. ports[1]) annotation (Line(points={{254,84},{
          254,12},{270.667,12},{270.667,20}},
                                 color={0,127,255}));
  connect(TEmOut.port_b,Tank. ports[2])
    annotation (Line(points={{210,-36},{272,-36},{272,20}},color={0,127,255}));
  connect(transHpOn.inPort,stateHpOff. outPort[1])
    annotation (Line(points={{308,-72},{292,-72},{292,-77.4}},
                                                           color={0,0,0}));
  connect(not1.y,timerHpOff. u)
    annotation (Line(points={{286.5,-112},{278,-112}},
                                                   color={255,0,255}));
  connect(transHpOn.outPort,stateHpOn. inPort[1])
    annotation (Line(points={{317,-72},{332,-72},{332,-78}},
                                                      color={0,0,0}));
  connect(stateHpOn.outPort[1],transHpOff. inPort)
    annotation (Line(points={{332,-86.6},{332,-92},{316,-92}},
                                                        color={0,0,0}));
  connect(transHpOff.outPort,stateHpOff. inPort[1])
    annotation (Line(points={{307,-92},{292,-92},{292,-86}},
                                                         color={0,0,0}));
  connect(not1.u,startHp. u)
    annotation (Line(points={{298,-112},{326.4,-112}},
                                                  color={255,0,255}));
  connect(startHp.y,not2. u)
    annotation (Line(points={{336.8,-112},{346,-112}},
                                                 color={255,0,255}));
  connect(not2.y,timerStartHp. u)
    annotation (Line(points={{357.5,-112},{366,-112}},
                                                 color={255,0,255}));
  connect(stateHpOn.activePort,startHp. u) annotation (Line(points={{336.72,-82},
          {352,-82},{352,-102},{312,-102},{312,-112},{326.4,-112}},
                                                    color={255,0,255}));
  connect(stateHpOn.activePort,timerHpOn. u) annotation (Line(points={{336.72,-82},
          {352,-82},{352,-62},{356,-62}}, color={255,0,255}));
  connect(Tank.ports[3],AsHp. port_a)
    annotation (Line(points={{273.333,20},{273.333,-44},{314,-44}},
                                                           color={0,127,255}));
  connect(AsHp.port_b,Tank. ports[4]) annotation (Line(points={{314,-32},{282,
          -32},{282,-28},{274.667,-28},{274.667,20}},
                                        color={0,127,255}));
  connect(TtankExpr.y,ChiPi. u_m)
    annotation (Line(points={{391,18},{416,18},{416,26}},    color={0,0,127}));
  connect(TtankSetCoo.y,ChiPi. u_s)
    annotation (Line(points={{391,38},{404,38}},   color={0,0,127}));
  connect(AsChi.port_b,Tank. ports[5])
    annotation (Line(points={{314,10},{276,10},{276,20}},color={0,127,255}));
  connect(AsChi.port_a,Tank. ports[6]) annotation (Line(points={{314,-2},{274,
          -2},{274,20},{277.333,20}},
                                color={0,127,255}));
  connect(runningMeanTemperature1.y,heatingCurveTSet. u)
    annotation (Line(points={{-21.4,202},{-14,202}}, color={0,0,127}));
  connect(radPI.y,onOffHeaDay. u1)
    annotation (Line(points={{115,144},{132,144}},
                                                 color={0,0,127}));
  connect(TSetDayHea.y,radPI. u_s)
    annotation (Line(points={{87,144},{92,144}}, color={0,0,127}));
  connect(TSetNigHea1.y,radPI1. u_s)
    annotation (Line(points={{101,182},{106,182}},
                                                 color={0,0,127}));
  connect(radPI1.y,onOffHeaNig. u1)
    annotation (Line(points={{129,182},{146,182}},
                                                 color={0,0,127}));
  connect(HeaOn.y,radPI1. trigger)
    annotation (Line(points={{35,164},{110,164},{110,170}},color={255,0,255}));
  connect(onOffHeaNig.u,HeaOn. y)
    annotation (Line(points={{158,170},{158,164},{35,164}},color={255,0,255}));
  connect(onOffHeaDay.u,HeaOn. y) annotation (Line(points={{144,132},{144,118},{
          46,118},{46,164},{35,164}},color={255,0,255}));
  connect(radPI.trigger,HeaOn. y) annotation (Line(points={{96,132},{96,118},{46,
          118},{46,164},{35,164}},   color={255,0,255}));
  connect(HeaOn.y,switchNig. u2) annotation (Line(points={{35,164},{186,164},{186,
          178},{208,178},{208,170}}, color={255,0,255}));
  connect(onOffHeaNig.y,switchNig. u1) annotation (Line(points={{169,182},{169,184},
          {200,184},{200,170}}, color={0,0,127}));
  connect(CooOn.y,radPI2. trigger) annotation (Line(points={{373,160},{332,160},
          {332,172}}, color={255,0,255}));
  connect(CooOn.y,onOffCooNig. u) annotation (Line(points={{373,160},{284,160},{
          284,172}}, color={255,0,255}));
  connect(CooOn.y,radPI3. trigger) annotation (Line(points={{373,160},{372,160},
          {372,124},{332,124},{332,132}}, color={255,0,255}));
  connect(CooOn.y,onOffCooDay. u) annotation (Line(points={{373,160},{372,160},{
          372,124},{284,124},{284,132}}, color={255,0,255}));
  connect(TSetCooNig.y,radPI2. u_s)
    annotation (Line(points={{347,184},{336,184}}, color={0,0,127}));
  connect(switchDay.u2,switchNig. u2) annotation (Line(points={{238,170},{238,178},
          {208,178},{208,170}}, color={255,0,255}));
  connect(onOffHeaDay.y,switchDay. u1) annotation (Line(points={{155,144},{184,144},
          {184,190},{230,190},{230,170}}, color={0,0,127}));
  connect(onOffCooNig.y,switchNig. u3)
    annotation (Line(points={{273,184},{216,184},{216,170}}, color={0,0,127}));
  connect(onOffCooDay.y,switchDay. u3) annotation (Line(points={{273,144},{252,144},
          {252,170},{246,170}}, color={0,0,127}));
  connect(TSetDayCoo.y,radPI3. u_s) annotation (Line(points={{347,144},{347,142},
          {336,142},{336,144}}, color={0,0,127}));
  connect(radPI2.y,onOffCooNig. u1) annotation (Line(points={{313,184},{313,186},
          {296,186},{296,184}}, color={0,0,127}));
  connect(radPI3.y,onOffCooDay. u1)
    annotation (Line(points={{313,144},{296,144}}, color={0,0,127}));
  connect(floHea2.heatPortEmb[1], office.heatPortEmb[2]) annotation (Line(
        points={{144,24},{60,24},{60,6},{14,6}}, color={191,0,0}));
  connect(floHea1.heatPortEmb[1], office.heatPortEmb[1]) annotation (Line(
        points={{174,4},{134,4},{134,6},{14,6}}, color={191,0,0}));
  connect(office.TSensor[1], radPI.u_m)
    annotation (Line(points={{14.6,-6},{104,-6},{104,132}}, color={0,0,127}));
  connect(office.TSensor[1], radPI3.u_m) annotation (Line(points={{14.6,-6},{104,
          -6},{104,104},{324,104},{324,132}}, color={0,0,127}));
  connect(office.TSensor[2], radPI1.u_m)
    annotation (Line(points={{14.6,-6},{118,-6},{118,170}}, color={0,0,127}));
  connect(office.TSensor[2], radPI2.u_m) annotation (Line(points={{14.6,-6},{118,
          -6},{118,104},{304,104},{304,166},{324,166},{324,172}}, color={0,0,127}));
  connect(valFloHea2.y, switchNig.y) annotation (Line(points={{163.6,54},{162,54},
          {162,124},{208,124},{208,147}}, color={0,0,127}));
  connect(switchDay.y, valFloHea1.y) annotation (Line(points={{238,147},{238,128},
          {224,128},{224,54},{193.6,54}}, color={0,0,127}));
  connect(ChiPi.trigger, radPI3.trigger) annotation (Line(points={{408,26},{358,
          26},{358,124},{332,124},{332,132}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-182,140},{178,100}},
          textColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Rectangle(
          extent={{-64,80},{64,-100}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-50,70},{-30,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-10,70},{10,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{30,70},{50,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-50,30},{-30,0}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-10,30},{10,0}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{30,30},{50,0}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-50,-10},{-30,-40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-10,-10},{10,-40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{30,-10},{50,-40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-20,-60},{20,-100}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-26,-52},{26,-60}},
          lineColor={0,0,0},
          lineThickness=0.5)}),  Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=5184000,
      __Dymola_Algorithm="Dassl"));
end Office_A_ASHP_ASCHI;
