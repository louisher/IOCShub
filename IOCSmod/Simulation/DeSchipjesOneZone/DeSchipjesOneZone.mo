within IOCSmod.Simulation.DeSchipjesOneZone;
model DeSchipjesOneZone
  import DeSchipjes;
  import Buildings;
  import DistrictHeating;
    extends IOCSmod.Optimization.Interface(
      priceSim(path_economic_params_json="/home/u0148284/Workdir/iocs/input_data/economic_params.json"));
     // PI controller parameters
    parameter Real k_tank=1;
    parameter Real Ti_tank=300;



    parameter Modelica.Units.SI.HeatFlowRate Qnom_GsHp=44000 annotation(Dialog(group="Heat Flows"));

    parameter Modelica.Units.SI.MassFlowRate m_flow_gshp_nominal= Qnom_GsHp/4180/GsHp.dT_max
      "Nominal mass flow gshp condensor" annotation(Dialog(group="Mass Flows"));
    parameter Modelica.Units.SI.MassFlowRate m_flow_bor_nominal= if borefield.borFieDat.conDat.hBor > 1 then 0.2*borefield.borFieDat.conDat.nBor else 0
      "Nominal mass flow borefield loop" annotation(Dialog(group="Mass Flows"));
    parameter Modelica.Units.SI.MassFlowRate m_flow_hex_coo_nominal= m_flow_bor_nominal
      "Nomtinal mass flow of the cooling side of the cooling heat exchanger" annotation(Dialog(group="Mass Flows"));
    parameter Modelica.Units.SI.Temperature TBorMin "Minimum allowable borefield temperature (to be used in objective)";


    parameter Modelica.Units.SI.TemperatureDifference dT_max=5
      "Maximum temperature difference across condenser" annotation(Dialog(group="Heat pump"));
    parameter Real copDef=5.00625 "Default COP" annotation(Dialog(group="Heat pump"));
    parameter Real coeffEva[2]={-280.15, 0.1103557} annotation(Dialog(group="Heat pump"));
    parameter Real coeffCon[2]={-313.15,-0.1037086} annotation(Dialog(group="Heat pump"));



  parameter Modelica.Units.SI.MassFlowRate m_flow_panels_nominal=solCol.m_flow_nominal
    "Nominal mass flow rate in pvt panels";
  replaceable parameter IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F per_STC constrainedby
    Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic "Performance data"
    annotation (Dialog(tab="PVT", group="Thermal"), Placement(transformation(extent={{110,82},{130,102}})), choicesAllMatching=true);
  package MediumPVT = IDEAS.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40, T_min=220);

      parameter Modelica.Units.SI.Power Qnom_AsHp=28000 "Nominal heat flow rate";
      parameter Modelica.Units.SI.MassFlowRate m_flow_ashp_nominal = Qnom_AsHp/4180/5
        "Nominal mass flow rate at water side";
      parameter Modelica.Units.SI.PressureDifference dp_nominalCon_AsHp(displayUnit="Pa")=
           10000 "Pressure difference at condenser (water side)";
      parameter Real copDef_AsHp=4.055 "Default COP";
      parameter Modelica.Units.SI.Temperature TAir_nominal=280.15
        "Nominal air temperature for COP calculation";
      parameter Modelica.Units.SI.Temperature TConOut_nominal=313.15
        "Nominal condensor leaving temperature for COP calculation";
      parameter Real coeffEva_AsHp=0.1095853
        "Linearisation coefficient of air temperature in COP calculation";
      parameter Real coeffCon_AsHp=-0.0895519
        "Linearisation coefficient of leaving condensor temperature in COP calculation";



    IOCSmod.Simulation.DeSchipjesOneZone.Buildings.DeSchipjesOneZoneCluster buildings(addDummyEquation=false)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
     IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpConOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={10,-20})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpConIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={10,-40})));
  ComponentModels.Thermal.AirSourceHeatPumps.HeatPump_AirWater
                         AsHp(
    copDef=copDef_AsHp,
    TAir_nominal=TAir_nominal,
    TConOut_nominal=TConOut_nominal,
    coeffEva=coeffEva_AsHp,
    coeffCon=coeffCon_AsHp,
    m2_flow_nominal=m_flow_ashp_nominal,
    dp_nominalCon(displayUnit="Pa") = dp_nominalCon_AsHp,
    addDummyEquation=false,
    Q_flow_nominal=Qnom_AsHp,
    HP(mod=rbcHps.yAsHp)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-30})));
  Modelica.Blocks.Sources.RealExpression ExprTamb(y=sim.Te) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={88,-34})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-104,-42},{-84,-22}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow     pumpHpAir(
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_ashp_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominalCon_AsHp)
                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-80})));
  ComponentModels.Thermal.SimpleTank tan(
    m_flow_nominal=1,
    VTan=1.9,
    nPorts=9) annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow     pumGsHpCon(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=GsHp.m2_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=GsHp.dp_nominalCon) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-190,44})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_gshp_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-220,74})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-220,94})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-160,94})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_gshp_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-160,74})));
  IDEAS.Fluid.Movers.FlowControlled_dp         pumBor(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_bor_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=borefield.borFieDat.conDat.dp_nominal)
                                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-220,162})));
  ComponentModels.Thermal.Borefields.TwoUTubes_Cont            borefield(
    redeclare package Medium = IDEAS.Media.Water,
    tLoaAgg=3600,
    nSeg=1,
    borFieDat(
      filDat(
        kFil=2,
        cFil=840,
        dFil(displayUnit="kg/m3") = 1818),
      soiDat(
        kSoi=1.9,
        cSoi=900,
        dSoi=1400),
      conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBorFie_flow_nominal=m_flow_bor_nominal,
        dp_nominal(displayUnit="Pa") = 5000,
        hBor=125,
        cooBor=[0,0; 0,3; 3,0; 3,3],
        mBor_flow_nominal=m_flow_bor_nominal/borefield.borFieDat.conDat.nBor,
        nBor=10,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043)),
    groTemResDat(rCel(rCel={1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0,512.0,1024.0,
            2048.0,4096.0,8192.0,16384.0,32768.0,65536.0,131072.0,88257.0}),
        kappa(kappa={5.8172630391817344e-05,2.5494645394638947e-05,2.2957414619713648e-05,
            2.2478775080945156e-05,2.2518826009357176e-05,2.2656737119406577e-05,
            2.2753551927001475e-05,2.2824256598981304e-05,2.358419112820156e-05,
            2.9422627182251287e-05,4.528538358549057e-05,6.965392755597932e-05,9.739002539931637e-05,
            0.00012200931467394284,0.00013693912506484367,0.00013766864861179825,
            0.00012408673529210306,9.959811723621553e-05,3.3008506172307796e-05})))
                    annotation (Placement(transformation(extent={{-168,152},{-148,
            172}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBorIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-190,162})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBorOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-130,162})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-234,180},{-214,200}})));

   UnitTests.Components.HeatPump_WaterWater   GsHp(
    redeclare package Medium1 = IDEAS.Media.Water,
    redeclare package Medium2 = IDEAS.Media.Water,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=m_flow_bor_nominal,
    m2_flow_nominal=m_flow_gshp_nominal,
    dp_nominalEva(displayUnit="Pa") = 29378,
    dp_nominalCon(displayUnit="Pa") = 10000,
    copDef=copDef,
    coeffEva=coeffEva,
    coeffCon=coeffCon,
    dT_max=dT_max,
    con(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, from_dp=false),
    eva(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, from_dp=false))
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-192,82})));
  IDEAS.Fluid.FixedResistances.Junction junGsHpRet(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,m_flow_bor_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-200,140})));

  IDEAS.Fluid.FixedResistances.Junction junGsHpSup(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,m_flow_bor_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-180,140})));

  IDEAS.Fluid.Movers.FlowControlled_dp   pumGsHpEva(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_bor_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=GsHp.dp_nominalEva) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-170,120})));
  IDEAS.Fluid.Sources.Boundary_pT bou2(redeclare package Medium = MediumPVT,
      nPorts=1)
    annotation (Placement(transformation(extent={{-286,-40},{-276,-30}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPanelsOut(
    redeclare package Medium = MediumPVT,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-254,-34})));
  ComponentModels.Thermal.SolarCollectors.EN12975                      solCol(
    redeclare package Medium = MediumPVT,
    nSeg=3,
    azi=0,
    til=2*Modelica.Constants.pi*(45/360),
    rho=0.2,
    final nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=17.6,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    per=per_STC,
    dT_nominal=-10,
    dTMax=20) annotation (Dialog(group="Model", enable=false), Placement(
        transformation(extent={{-222,-44},{-242,-24}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPanelsIn(
    redeclare package Medium = MediumPVT,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-212,-34})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow pumPanels(
    redeclare package Medium = MediumPVT,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_panels_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    dp_nominal=solCol.dp_nominal)
    annotation (Placement(transformation(extent={{-174,-44},{-194,-24}})));
   IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hexStc(
    redeclare package Medium1 = MediumPVT,
    redeclare package Medium2 = IDEAS.Media.Water,
    m1_flow_nominal=m_flow_panels_nominal,
    m2_flow_nominal=m_flow_panels_nominal,
    dp1_nominal=1,
    dp2_nominal=1000)
    annotation (Placement(transformation(extent={{-242,-84},{-222,-64}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-254,-80})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-210,-80})));
  UnitTests.Components.FlowControlled_dp   pumPanelHex(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_panels_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    use_inputFilter=false,
    dp_nominal=hexStc.dp2_nominal)
    annotation (Placement(transformation(extent={{-172,-90},{-192,-70}})));
  Controls.AsHPGsHpModulating                             rbcHps(conPI(k=k_tank,
        Ti=Ti_tank))
    annotation (Placement(transformation(extent={{-340,20},{-320,40}})));
  Modelica.Blocks.Sources.RealExpression ExprTSup(y=tan.vol.T) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-378,26})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1(realTrue=
        m_flow_panels_nominal, realFalse=m_flow_panels_nominal/1000)
    annotation (Placement(transformation(extent={{-392,-66},{-372,-46}})));
  Modelica_StateGraph2.Step stateStcOff(
    initialStep=true,
    nOut=1,
    nIn=1) annotation (Placement(transformation(extent={{-486,-52},{-478,-60}})));
  Modelica_StateGraph2.Step stateStcOn(
    initialStep=false,
    use_activePort=true,
    nIn=1,
    nOut=1) annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=180,
        origin={-442,-56})));
  Modelica_StateGraph2.Transition transStcOn(
    use_conditionPort=false,
    condition=solCol.vol[solCol.nSeg].T >= tan.vol.T + 8,
    delayedTransition=false,
    waitTime=120) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-462,-46})));
  Modelica_StateGraph2.Transition transStcOff(
    use_conditionPort=false,
    condition=solCol.vol[solCol.nSeg].T < tan.vol.T + 4,
    delayedTransition=true,
    waitTime=180) annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={-462,-66})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseGsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{144,42},{164,62}})));
  Modelica.Blocks.Sources.RealExpression ExprPgshp(y=GsHp.PEl)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={124,52})));
  Modelica.Blocks.Continuous.Integrator ExprHeatGsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{144,2},{164,22}})));
  Modelica.Blocks.Sources.RealExpression ExprQgshp(y=GsHp.QCon)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={124,12})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseAsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{224,42},{244,62}})));
  Modelica.Blocks.Sources.RealExpression ExprPgshp1(y=AsHp.PEl)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={204,52})));
  Modelica.Blocks.Continuous.Integrator ExprHeatAsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{224,2},{244,22}})));
  Modelica.Blocks.Sources.RealExpression ExprQgshp1(y=AsHp.QCon)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={204,12})));
  Modelica.Blocks.Continuous.Integrator ExprHeatStc(k=1/3600000)
    annotation (Placement(transformation(extent={{284,44},{304,64}})));
  Modelica.Blocks.Sources.RealExpression ExprQPvt(y=hexStc.Q1_flow) annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={264,54})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseBui(k=1/3600000)
    annotation (Placement(transformation(extent={{144,-36},{164,-16}})));
  Modelica.Blocks.Sources.RealExpression ExprPBui(y=buildings.P) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={124,-26})));
  Modelica.Blocks.Sources.RealExpression ExprTotDiscmfCoo(y=buildings.Houses.nr136.heatingSystem.DiscmfCoo.y
         + buildings.Houses.nr138.heatingSystem.DiscmfCoo.y + buildings.Houses.nr140.heatingSystem.DiscmfCoo.y
         + buildings.Houses.nr142.heatingSystem.DiscmfCoo.y + buildings.Houses.nr144.heatingSystem.DiscmfCoo.y
         + buildings.Houses.nr146.heatingSystem.DiscmfCoo.y + buildings.Houses.nr148.heatingSystem.DiscmfCoo.y
         + buildings.Houses.nr150.heatingSystem.DiscmfCoo.y + buildings.Houses.nr152.heatingSystem.DiscmfCoo.y
         + buildings.Houses.nr154.heatingSystem.DiscmfCoo.y + buildings.Houses.nr156.heatingSystem.DiscmfCoo.y
         + buildings.Houses.nr158.heatingSystem.DiscmfCoo.y) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={124,-62})));
  Modelica.Blocks.Sources.RealExpression ExprTotDiscmfHea(y=buildings.Houses.nr136.heatingSystem.DiscmfHea.y
         + buildings.Houses.nr138.heatingSystem.DiscmfHea.y + buildings.Houses.nr140.heatingSystem.DiscmfHea.y
         + buildings.Houses.nr142.heatingSystem.DiscmfHea.y + buildings.Houses.nr144.heatingSystem.DiscmfHea.y
         + buildings.Houses.nr146.heatingSystem.DiscmfHea.y + buildings.Houses.nr148.heatingSystem.DiscmfHea.y
         + buildings.Houses.nr150.heatingSystem.DiscmfHea.y + buildings.Houses.nr152.heatingSystem.DiscmfHea.y
         + buildings.Houses.nr154.heatingSystem.DiscmfHea.y + buildings.Houses.nr156.heatingSystem.DiscmfHea.y
         + buildings.Houses.nr158.heatingSystem.DiscmfHea.y) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={124,-82})));
  Modelica.Blocks.Continuous.Integrator ExprTotalOfftake_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{214,-36},{234,-16}})));
  Modelica.Blocks.Sources.RealExpression ExprPOfftake(y=max(0, GsHp.PEl + AsHp.PEl
         + buildings.P)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={194,-26})));
  Modelica.Blocks.Continuous.Integrator ExprTotalInjection_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{214,-70},{234,-50}})));
  Modelica.Blocks.Sources.RealExpression ExprPInj(y=max(0, -1*(GsHp.PEl + AsHp.PEl
         + buildings.P))) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={194,-60})));
equation
  connect(pumBor.port_b, senTBorIn.port_a)
    annotation (Line(points={{-210,162},{-196,162}}, color={0,127,255}));
  connect(senTBorIn.port_b, borefield.port_a)
    annotation (Line(points={{-184,162},{-168,162}}, color={0,127,255}));
  connect(senTGsHpEvaOut.port_a, GsHp.port_b1) annotation (Line(points={{-214,94},
          {-208,94},{-208,88},{-202,88}}, color={0,127,255}));
  connect(senTGsHpEvaIn.port_b, GsHp.port_a1) annotation (Line(points={{-166,94},
          {-174,94},{-174,88},{-182,88}}, color={0,127,255}));
  connect(junGsHpSup.port_3, pumGsHpEva.port_a)
    annotation (Line(points={{-180,134},{-180,120}}, color={0,127,255}));
  connect(pumGsHpEva.port_b, senTGsHpEvaIn.port_a) annotation (Line(points={{-160,
          120},{-138,120},{-138,94},{-154,94}}, color={0,127,255}));
  connect(senTGsHpEvaOut.port_b, junGsHpRet.port_3) annotation (Line(points={{-226,
          94},{-234,94},{-234,114},{-206,114},{-206,112},{-202,112},{-202,134},{
          -200,134}}, color={0,127,255}));
  connect(junGsHpRet.port_2, pumBor.port_a) annotation (Line(points={{-206,140},
          {-224,140},{-224,138},{-240,138},{-240,162},{-230,162}}, color={0,127,
          255}));
  connect(borefield.port_b, senTBorOut.port_a)
    annotation (Line(points={{-148,162},{-136,162}}, color={0,127,255}));
  connect(senTBorOut.port_b, junGsHpSup.port_1) annotation (Line(points={{-124,162},
          {-120,162},{-120,140},{-174,140}}, color={0,127,255}));
  connect(junGsHpSup.port_2, junGsHpRet.port_1)
    annotation (Line(points={{-186,140},{-194,140}}, color={0,127,255}));
  connect(bou.ports[1], borefield.port_a) annotation (Line(points={{-214,190},{-168,
          190},{-168,162}}, color={0,127,255}));
  connect(pumGsHpCon.port_b, senTGsHpConOut.port_a) annotation (Line(points={{-200,
          44},{-240,44},{-240,74},{-226,74}}, color={0,127,255}));
  connect(GsHp.port_a2, senTGsHpConOut.port_b) annotation (Line(points={{-202,76},
          {-202,74},{-214,74}}, color={0,127,255}));
  connect(GsHp.port_b2, senTGsHpConIn.port_a) annotation (Line(points={{-182,76},
          {-174,76},{-174,74},{-166,74}}, color={0,127,255}));
  connect(pumGsHpCon.port_a, tan.ports[1]) annotation (Line(points={{-180,44},{
          -140,44},{-140,-4},{-78,-4},{-78,-8},{-33.5556,-8},{-33.5556,0}},
                                                                       color={0,
          127,255}));
  connect(senTGsHpConIn.port_b, tan.ports[2]) annotation (Line(points={{-154,74},
          {-132,74},{-132,70},{-100,70},{-100,-4},{-32.6667,-4},{-32.6667,0}},
        color={0,127,255}));
  connect(AsHp.port_b, senTAsHpConOut.port_a) annotation (Line(points={{30,-24},
          {26,-24},{26,-22},{16,-22},{16,-20}}, color={0,127,255}));
  connect(AsHp.port_a, senTAsHpConIn.port_b)
    annotation (Line(points={{30,-36},{16,-36},{16,-40}}, color={0,127,255}));
  connect(pumpHpAir.port_b, senTAsHpConIn.port_a) annotation (Line(points={{30,-80},
          {18,-80},{18,-78},{-2,-78},{-2,-40},{4,-40}}, color={0,127,255}));
  connect(pumpHpAir.port_a, tan.ports[3]) annotation (Line(points={{50,-80},{62,
          -80},{62,-100},{-28,-100},{-28,0},{-31.7778,0}}, color={0,127,255}));
  connect(senTAsHpConOut.port_b, tan.ports[4]) annotation (Line(points={{4,-20},
          {-30.8889,-20},{-30.8889,0}}, color={0,127,255}));
  connect(bou1.ports[1], tan.ports[5])
    annotation (Line(points={{-84,-32},{-30,-32},{-30,0}}, color={0,127,255}));
  connect(tan.ports[6], buildings.port_a) annotation (Line(points={{-29.1111,0},
          {-32,0},{-32,-10},{46,-10},{46,0}}, color={0,127,255}));
  connect(buildings.port_b, tan.ports[7]) annotation (Line(points={{34,0},{34,
          -8},{-28.2222,-8},{-28.2222,0}},
                                       color={0,127,255}));
  connect(ExprTamb.y, AsHp.Tair) annotation (Line(points={{77,-34},{56,-34},{56,
          -33},{50,-33}}, color={0,0,127}));
  connect(pumPanels.port_b, senTPanelsIn.port_a)
    annotation (Line(points={{-194,-34},{-206,-34}}, color={0,127,255}));
  connect(senTPanelsIn.port_b, solCol.port_a)
    annotation (Line(points={{-218,-34},{-222,-34}}, color={0,127,255}));
  connect(solCol.port_b, senTPanelsOut.port_a)
    annotation (Line(points={{-242,-34},{-248,-34}}, color={0,127,255}));
  connect(senTPanelsOut.port_b,hexStc. port_a1) annotation (Line(points={{-260,-34},
          {-268,-34},{-268,-66},{-242,-66},{-242,-68}}, color={0,127,255}));
  connect(hexStc.port_b1, pumPanels.port_a) annotation (Line(points={{-222,-68},
          {-202,-68},{-202,-66},{-160,-66},{-160,-34},{-174,-34}}, color={0,127,
          255}));
  connect(senTHexOut.port_a,hexStc. port_b2)
    annotation (Line(points={{-248,-80},{-242,-80}}, color={0,127,255}));
  connect(senTHexOut.port_b, tan.ports[8]) annotation (Line(points={{-260,-80},
          {-270,-80},{-270,-110},{-27.3333,-110},{-27.3333,0}},color={0,127,255}));
  connect(hexStc.port_a2, senTHexIn.port_b)
    annotation (Line(points={{-222,-80},{-216,-80}}, color={0,127,255}));
  connect(senTHexIn.port_a, pumPanelHex.port_b)
    annotation (Line(points={{-204,-80},{-192,-80}}, color={0,127,255}));
  connect(pumPanelHex.port_a, tan.ports[9]) annotation (Line(points={{-172,-80},
          {-108,-80},{-108,-78},{-26.4444,-78},{-26.4444,0}}, color={0,127,255}));
  connect(bou2.ports[1], senTPanelsOut.port_b)
    annotation (Line(points={{-276,-35},{-260,-34}}, color={0,127,255}));
  connect(rbcHps.yGsHp, GsHp.mod) annotation (Line(points={{-318,30},{-120,30},{
          -120,82},{-181,82}}, color={0,0,127}));
  connect(rbcHps.TAmb, ExprTamb.y) annotation (Line(points={{-342,34},{-360,34},
          {-360,-160},{68,-160},{68,-34},{77,-34}}, color={0,0,127}));
  connect(ExprTSup.y, rbcHps.TTan)
    annotation (Line(points={{-367,26},{-342,26}}, color={0,0,127}));
  connect(transStcOff.outPort,stateStcOff. inPort[1])
    annotation (Line(points={{-467,-66},{-482,-66},{-482,-60}},
                                                            color={0,0,0}));
  connect(stateStcOff.outPort[1],transStcOn. inPort)
    annotation (Line(points={{-482,-51.4},{-482,-46},{-466,-46}},
                                                              color={0,0,0}));
  connect(transStcOn.outPort,stateStcOn. inPort[1])
    annotation (Line(points={{-457,-46},{-442,-46},{-442,-52}},
                                                         color={0,0,0}));
  connect(stateStcOn.outPort[1],transStcOff. inPort)
    annotation (Line(points={{-442,-60.6},{-442,-66},{-458,-66}},
                                                           color={0,0,0}));
  connect(stateStcOn.activePort,booleanToReal1. u)
    annotation (Line(points={{-437.28,-56},{-394,-56}},
                                                    color={255,0,255}));
  connect(booleanToReal1.y, pumPanels.m_flow_in) annotation (Line(points={{-371,
          -56},{-324,-56},{-324,-6},{-184,-6},{-184,-22}}, color={0,0,127}));
  connect(ExprPgshp.y,ExprEnergyUseGsHp. u)
    annotation (Line(points={{135,52},{142,52}}, color={0,0,127}));
  connect(ExprQgshp.y,ExprHeatGsHp. u)
    annotation (Line(points={{135,12},{142,12}}, color={0,0,127}));
  connect(ExprPgshp1.y,ExprEnergyUseAsHp. u)
    annotation (Line(points={{215,52},{222,52}}, color={0,0,127}));
  connect(ExprQgshp1.y,ExprHeatAsHp. u)
    annotation (Line(points={{215,12},{222,12}}, color={0,0,127}));
  connect(ExprQPvt.y,ExprHeatStc. u)
    annotation (Line(points={{275,54},{282,54}}, color={0,0,127}));
  connect(ExprPBui.y, ExprEnergyUseBui.u)
    annotation (Line(points={{135,-26},{142,-26}}, color={0,0,127}));
  connect(ExprPOfftake.y, ExprTotalOfftake_kWh.u)
    annotation (Line(points={{205,-26},{212,-26}}, color={0,0,127}));
  connect(ExprPInj.y, ExprTotalInjection_kWh.u)
    annotation (Line(points={{205,-60},{212,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DeSchipjesOneZone;
