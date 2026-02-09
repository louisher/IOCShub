within IOCSmod.Simulation.StijnStreuvel;
model StijnStreuvel
  import Buildings;
  extends IOCSmod.Optimization.Interface(sim(n50=buildings.Houses.n50, incAndAziInBus={{IDEAS.Types.Tilt.Ceiling,
          0},{IDEAS.Types.Tilt.Wall,buildings.Houses.downAngle},{IDEAS.Types.Tilt.Wall,
          buildings.Houses.leftAngle},{IDEAS.Types.Tilt.Wall,buildings.Houses.upAngle},
          {IDEAS.Types.Tilt.Wall,buildings.Houses.rightAngle},{IDEAS.Types.Tilt.Floor,
          0}}, interZonalAirFlowType=IDEAS.BoundaryConditions.Types.InterZonalAirFlow.OnePort),
      priceSim(path_economic_params_json=
          "/home/u0148284/Workdir/iocs/input_data/economic_params.json"));

    // PI controller parameters
    parameter Real k_tank=1;
    parameter Real Ti_tank=300;

      // Parameters
    parameter Boolean hasReg=true "Boolean to create external ports for regeneration";

    parameter Modelica.Units.SI.HeatFlowRate Qnom_GsHp=40000 annotation(Dialog(group="Heat Flows"));

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



  parameter Modelica.Units.SI.MassFlowRate m_flow_panels_nominal=pvt.m_flow_nominal "Nominal mass flow rate in pvt panels";
  replaceable parameter IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.PVT_DualSun_Spring425_ShingleBlack per_PVT constrainedby
    Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic                                                                                               "Performance data"
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

  IOCSmod.Simulation.StijnStreuvel.Buildings.StijnStreuvelCluster buildings
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-200,92})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_gshp_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-200,72})));
  UnitTests_Simulation.Components.HeatPump_WaterWater   GsHp(
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
        origin={-170,82})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-140,92})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_gshp_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-140,72})));
    IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hexCoo(
    redeclare package Medium1 = IDEAS.Media.Water,
    redeclare package Medium2 = IDEAS.Media.Water,
    m1_flow_nominal=m_flow_bor_nominal,
    m2_flow_nominal=m_flow_hex_coo_nominal,
    dp1_nominal=5000,
    dp2_nominal=5000)  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,82})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooConOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-90,92})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooEvaOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_hex_coo_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-90,72})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooConIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-30,92})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooEvaIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_hex_coo_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-30,72})));
    IDEAS.Fluid.Movers.FlowControlled_m_flow     pumHexCooEva(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_hex_coo_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=hexCoo.dp2_nominal)  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-80,42})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow     pumGsHpCon(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=GsHp.m2_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Stages,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=GsHp.dp_nominalCon) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-170,42})));
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
        origin={-140,116})));
  IDEAS.Fluid.Movers.FlowControlled_dp   pumHexCooCon(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_bor_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=hexCoo.dp1_nominal) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-44,116})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBorIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-142,170})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBorOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-82,170})));
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
        origin={-172,170})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-214,178},{-194,198}})));
  IDEAS.Fluid.FixedResistances.Junction junGsHpRet(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-180,140})));

  IDEAS.Fluid.FixedResistances.Junction junGsHpSup(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-160,140})));

  IDEAS.Fluid.FixedResistances.Junction junRegRet(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,m_flow_bor_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-132,140})));
  IDEAS.Fluid.FixedResistances.Junction junRegSup(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,m_flow_bor_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-112,140})));
  IDEAS.Fluid.FixedResistances.Junction junHexCooRet(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-82,140})));

  IDEAS.Fluid.FixedResistances.Junction junHexCooSup(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-62,140})));

  ComponentModels.Thermal.SimpleTank tan(
    m_flow_nominal=1,                    VTan=0.5, nPorts=9)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.PasCoo                             pasCoo(TSetPasCoo=287.15)
    annotation (Placement(transformation(extent={{-92,0},{-72,20}})));
  Controls.AsHPGsHpModulating                             rbcHps(
    conPI(k=k_tank, Ti=Ti_tank))
    annotation (Placement(transformation(extent={{-300,80},{-280,100}})));
  Modelica.Blocks.Math.Gain gain(k=pumHexCooEva.m_flow_nominal)
    annotation (Placement(transformation(extent={{-64,0},{-44,20}})));
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
        origin={68,-64})));
     IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpConOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={38,-54})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTAsHpConIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=AsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={38,-74})));
  Modelica.Blocks.Sources.RealExpression ExprTamb(y=sim.Te) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={116,-68})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow     pumpHpAir(
    inputType=IDEAS.Fluid.Types.InputType.Stages,
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
        origin={68,-114})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-76,-76},{-56,-56}})));
  Modelica.Blocks.Sources.RealExpression ExprCooPer(y=buildings.Houses.CoolingPeriod)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,30})));
  Modelica.Blocks.Sources.RealExpression ExprTSup(y=tan.vol.T) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-10})));
  Modelica.Blocks.Sources.RealExpression ExprTBor(y=senTBorOut.T) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,10})));
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
        nBor=8,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043)),
    groTemResDat(rCel(rCel={1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0,512.0,1024.0,
            2048.0,4096.0,8192.0,16384.0,32768.0,65536.0,131072.0,88257.0}),
        kappa(kappa={7.271578798977166e-05,3.186830674329873e-05,2.8696768274641995e-05,
            2.809846885118146e-05,2.8148532511696497e-05,2.83209213994724e-05,2.8441939663340472e-05,
            2.852953364457033e-05,2.944046541050537e-05,3.643485068673732e-05,5.530584162640427e-05,
            8.360466028627312e-05,0.00011409346402735919,0.00013845367529981615,
            0.00015009775656239603,0.00014662961529245675,0.0001299678115521995,
            0.0001037624015716998,3.440217513557011e-05})))
                    annotation (Placement(transformation(extent={{-120,160},{-100,
            180}})));

  Modelica.Blocks.Math.BooleanToInteger HeaPumPumps(integerTrue=0, integerFalse=
       1) annotation (Placement(transformation(extent={{-258,-80},{-238,-60}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=buildings.Houses.coolingPeriod_real.u)
    annotation (Placement(transformation(extent={{-298,-80},{-278,-60}})));
  IDEAS.Fluid.Sources.Boundary_pT bou2(redeclare package Medium =
        MediumPVT,
      nPorts=1)
    annotation (Placement(transformation(extent={{-18,190},{-8,200}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPanelsOut(
    redeclare package Medium = MediumPVT,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={14,196})));
  ComponentModels.Thermal.SolarCollectors.PhotoVoltaicThermalCollector pvt(
    U_pvt=35,
    G_STC=1000,
    P_STC=370,
    gamma=-0.0037,
    P_loss_factor=0.14,
    module_efficiency=0.3,
    eta_nom_inverter=0.96,
    P_ac0=0.7*(pvt.ATot_internal/pvt.per.A)*pvt.P_STC,
    redeclare package Medium = MediumPVT,
    nSeg=3,
    azi=0,
    til=2*Modelica.Constants.pi*(45/360),
    rho=0.2,
    final nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=20,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    per=per_PVT,
    dT_nominal=-10,
    dTMax=20) annotation (Dialog(group="Model", enable=false), Placement(
        transformation(extent={{46,186},{26,206}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTPanelsIn(
    redeclare package Medium = MediumPVT,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={56,196})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow     pumPanels(
    redeclare package Medium = MediumPVT,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_panels_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    dp_nominal=pvt.dp_nominal)
    annotation (Placement(transformation(extent={{94,186},{74,206}})));
   IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hexPvt(
    redeclare package Medium1 = MediumPVT,
    redeclare package Medium2 = IDEAS.Media.Water,
    m1_flow_nominal=m_flow_panels_nominal,
    m2_flow_nominal=m_flow_panels_nominal,
    dp1_nominal=1,
    dp2_nominal=1000)
    annotation (Placement(transformation(extent={{26,146},{46,166}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={54,150})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={14,150})));
  UnitTests.Components.FlowControlled_dp   pumPanelHex(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_panels_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    use_inputFilter=false,
    dp_nominal=hexPvt.dp2_nominal)
    annotation (Placement(transformation(extent={{96,140},{76,160}})));
  Controls.RbcPvt rbcPvt
    annotation (Placement(transformation(extent={{28,220},{48,240}})));
  Modelica.Blocks.Sources.RealExpression ExprTBor1(y=senTBorOut.T) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={4,232})));
  Modelica.Blocks.Sources.RealExpression ExprSolRad(y=sim.weaBus.solGloHor)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={6,218})));
  Modelica.Blocks.Math.Gain gain1(k=pumPanels.m_flow_nominal)
    annotation (Placement(transformation(extent={{60,220},{80,240}})));
  Modelica.Blocks.Sources.RealExpression ExprTPvt(y=pvt.vol[3].T) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={2,250})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseGsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Sources.RealExpression ExprPgshp(y=GsHp.PEl)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,50})));
  Modelica.Blocks.Continuous.Integrator ExprHeatGsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Modelica.Blocks.Sources.RealExpression ExprQgshp(y=GsHp.QCon)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,10})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseAsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{200,40},{220,60}})));
  Modelica.Blocks.Sources.RealExpression ExprPgshp1(y=AsHp.PEl)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={180,50})));
  Modelica.Blocks.Continuous.Integrator ExprHeatAsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{200,0},{220,20}})));
  Modelica.Blocks.Sources.RealExpression ExprQgshp1(y=AsHp.QCon)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={180,10})));
  Modelica.Blocks.Continuous.Integrator ExprHeatPvt(k=1/3600000)
    annotation (Placement(transformation(extent={{260,42},{280,62}})));
  Modelica.Blocks.Sources.RealExpression ExprQPvt(y=hexPvt.Q1_flow) annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={240,52})));
  Modelica.Blocks.Continuous.Integrator ExprElecyieldPvt(k=1/3600000)
    annotation (Placement(transformation(extent={{260,2},{280,22}})));
  Modelica.Blocks.Sources.RealExpression ExprPPvt(y=pvt.P) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={240,12})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseBui(k=1/3600000)
    annotation (Placement(transformation(extent={{120,-34},{140,-14}})));
  Modelica.Blocks.Sources.RealExpression ExprPBui(y=buildings.P) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,-24})));
  Modelica.Blocks.Sources.RealExpression ExprTotDiscmfCoo(y=buildings.Houses.DiscmfCoo_nr3.y
         + buildings.Houses.DiscmfCoo_nr5.y + buildings.Houses.DiscmfCoo_nr7.y
         + buildings.Houses.DiscmfCoo_nr9.y + buildings.Houses.DiscmfCoo_nr11.y
         + buildings.Houses.DiscmfCoo_nr13.y + buildings.Houses.DiscmfCoo_nr15.y
         + buildings.Houses.DiscmfCoo_nr17.y + buildings.Houses.DiscmfCoo_nr19.y
         + buildings.Houses.DiscmfCoo_nr21.y + buildings.Houses.DiscmfCoo_nr23.y
         + buildings.Houses.DiscmfCoo_nr25.y + buildings.Houses.DiscmfCoo_nr27.y
         + buildings.Houses.DiscmfCoo_nr29.y + buildings.Houses.DiscmfCoo_nr31.y)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={182,-20})));
  Modelica.Blocks.Sources.RealExpression ExprTotDiscmfHea(y=buildings.Houses.DiscmfHea_nr3.y
         + buildings.Houses.DiscmfHea_nr5.y + buildings.Houses.DiscmfHea_nr7.y
         + buildings.Houses.DiscmfHea_nr9.y + buildings.Houses.DiscmfHea_nr11.y
         + buildings.Houses.DiscmfHea_nr13.y + buildings.Houses.DiscmfHea_nr15.y
         + buildings.Houses.DiscmfHea_nr17.y + buildings.Houses.DiscmfHea_nr19.y
         + buildings.Houses.DiscmfHea_nr21.y + buildings.Houses.DiscmfHea_nr23.y
         + buildings.Houses.DiscmfHea_nr25.y + buildings.Houses.DiscmfHea_nr27.y
         + buildings.Houses.DiscmfHea_nr29.y + buildings.Houses.DiscmfHea_nr31.y)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={182,-40})));
  Modelica.Blocks.Continuous.Integrator ExprTotalOfftake_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{252,-48},{272,-28}})));
  Modelica.Blocks.Sources.RealExpression ExprPOfftake(y=max(0, GsHp.PEl + AsHp.PEl
         + buildings.P + pvt.P + pv.P))
                                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={232,-38})));
  Modelica.Blocks.Continuous.Integrator ExprTotalInjection_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{252,-82},{272,-62}})));
  Modelica.Blocks.Sources.RealExpression ExprPInj(y=max(0, -1*(GsHp.PEl + AsHp.PEl
         + buildings.P + pvt.P + pv.P)))
                                  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={232,-72})));
  ComponentModels.Electrical.PVPanelDC pv(PVArea=100)
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Modelica.Blocks.Continuous.Integrator ExprElecyieldPv(k=1/3600000)
    annotation (Placement(transformation(extent={{320,0},{340,20}})));
  Modelica.Blocks.Sources.RealExpression ExprPPv(y=pv.P) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={300,10})));
equation
  connect(pumBor.port_b, senTBorIn.port_a)
    annotation (Line(points={{-162,170},{-148,170}}, color={0,127,255}));
  connect(senTBorOut.port_b, junHexCooSup.port_1) annotation (Line(points={{-76,
          170},{-40,170},{-40,140},{-56,140}}, color={0,127,255}));
  connect(junHexCooSup.port_2, junHexCooRet.port_1)
    annotation (Line(points={{-68,140},{-76,140}}, color={0,127,255}));
  connect(junHexCooRet.port_2, junRegSup.port_1)
    annotation (Line(points={{-88,140},{-106,140}}, color={0,127,255}));
  connect(junRegSup.port_2, junRegRet.port_1)
    annotation (Line(points={{-118,140},{-126,140}}, color={0,127,255}));
  connect(junRegRet.port_2, junGsHpSup.port_1)
    annotation (Line(points={{-138,140},{-154,140}}, color={0,127,255}));
  connect(junGsHpSup.port_2, junGsHpRet.port_1)
    annotation (Line(points={{-166,140},{-174,140}}, color={0,127,255}));
  connect(junGsHpRet.port_2, pumBor.port_a) annotation (Line(points={{-186,140},
          {-200,140},{-200,170},{-182,170}}, color={0,127,255}));
  connect(junGsHpSup.port_3, pumGsHpEva.port_a) annotation (Line(points={{-160,134},
          {-160,116},{-150,116}}, color={0,127,255}));
  connect(pumGsHpEva.port_b, senTGsHpEvaIn.port_a) annotation (Line(points={{-130,
          116},{-120,116},{-120,92},{-134,92}}, color={0,127,255}));
  connect(senTGsHpEvaIn.port_b, GsHp.port_a1) annotation (Line(points={{-146,92},
          {-160,92},{-160,88}}, color={0,127,255}));
  connect(GsHp.port_b1, senTGsHpEvaOut.port_a) annotation (Line(points={{-180,88},
          {-180,92},{-194,92}}, color={0,127,255}));
  connect(senTGsHpEvaOut.port_b, junGsHpRet.port_3) annotation (Line(points={{-206,
          92},{-206,116},{-180,116},{-180,134}}, color={0,127,255}));
  connect(junHexCooSup.port_3, pumHexCooCon.port_a) annotation (Line(points={{-62,
          134},{-62,116},{-54,116}}, color={0,127,255}));
  connect(pumHexCooCon.port_b, senTHexCooConIn.port_a) annotation (Line(points={
          {-34,116},{-20,116},{-20,92},{-24,92}}, color={0,127,255}));
  connect(senTHexCooConIn.port_b, hexCoo.port_a1) annotation (Line(points={{-36,
          92},{-44,92},{-44,88},{-50,88}}, color={0,127,255}));
  connect(hexCoo.port_b1, senTHexCooConOut.port_a)
    annotation (Line(points={{-70,88},{-84,88},{-84,92}}, color={0,127,255}));
  connect(senTHexCooConOut.port_b, junHexCooRet.port_3) annotation (Line(points=
         {{-96,92},{-96,116},{-82,116},{-82,134}}, color={0,127,255}));
  connect(senTHexCooEvaOut.port_b, hexCoo.port_a2)
    annotation (Line(points={{-84,72},{-70,72},{-70,76}}, color={0,127,255}));
  connect(hexCoo.port_b2, senTHexCooEvaIn.port_a)
    annotation (Line(points={{-50,76},{-50,72},{-36,72}}, color={0,127,255}));
  connect(senTGsHpConIn.port_a, GsHp.port_b2) annotation (Line(points={{-146,72},
          {-160,72},{-160,76}}, color={0,127,255}));
  connect(GsHp.port_a2, senTGsHpConOut.port_b) annotation (Line(points={{-180,76},
          {-180,72},{-194,72}}, color={0,127,255}));
  connect(pumHexCooEva.port_b, senTHexCooEvaOut.port_a) annotation (Line(points=
         {{-90,42},{-106,42},{-106,72},{-96,72}}, color={0,127,255}));
  connect(senTHexCooEvaIn.port_b, tan.ports[1]) annotation (Line(points={{-24,72},
          {-24,-10},{-13.5556,-10},{-13.5556,0}}, color={0,127,255}));
  connect(pumHexCooEva.port_a, tan.ports[2]) annotation (Line(points={{-70,42},
          {-40,42},{-40,-16},{-12.6667,-16},{-12.6667,0}},
                                                color={0,127,255}));
  connect(pumGsHpCon.port_b, senTGsHpConOut.port_a) annotation (Line(points={{-180,
          42},{-194,42},{-194,40},{-206,40},{-206,72}}, color={0,127,255}));
  connect(pumGsHpCon.port_a, tan.ports[3]) annotation (Line(points={{-160,42},{
          -146,42},{-146,-28},{-11.7778,-28},{-11.7778,0}},
                                                       color={0,127,255}));
  connect(senTGsHpConIn.port_b, tan.ports[4]) annotation (Line(points={{-134,72},
          {-122,72},{-122,-22},{-10.8889,-22},{-10.8889,0}}, color={0,127,255}));
  connect(tan.ports[5], buildings.port_a) annotation (Line(points={{-10,0},{-6,0},
          {-6,-16},{54,-16},{54,0},{56,0}}, color={0,127,255}));
  connect(buildings.port_b, tan.ports[6]) annotation (Line(points={{44,0},{44,-12},
          {-9.11111,-12},{-9.11111,0}}, color={0,127,255}));
  connect(rbcHps.yGsHp, GsHp.mod) annotation (Line(points={{-278,90},{-256,90},{
          -256,48},{-152,48},{-152,80},{-157,80}},
                                          color={0,0,127}));
  connect(pasCoo.PasCoo, gain.u)
    annotation (Line(points={{-70,10},{-66,10}}, color={0,0,127}));
  connect(gain.y, pumHexCooEva.m_flow_in) annotation (Line(points={{-43,10},{-50,
          10},{-50,54},{-80,54}}, color={0,0,127}));
  connect(bou.ports[1], pumBor.port_a) annotation (Line(points={{-194,188},{-182,
          188},{-182,170}}, color={0,127,255}));
  connect(tan.ports[7], pumpHpAir.port_a) annotation (Line(points={{-8.22222,0},
          {-8.22222,-134},{88,-134},{88,-114},{78,-114}},
                                                color={0,127,255}));
  connect(pumpHpAir.port_b, senTAsHpConIn.port_a) annotation (Line(points={{58,-114},
          {20,-114},{20,-74},{32,-74}}, color={0,127,255}));
  connect(senTAsHpConOut.port_b, tan.ports[8]) annotation (Line(points={{32,-54},
          {-7.33333,-54},{-7.33333,0}},
                                color={0,127,255}));
  connect(AsHp.port_b, senTAsHpConOut.port_a) annotation (Line(points={{58,-58},
          {50,-58},{50,-54},{44,-54}}, color={0,127,255}));
  connect(AsHp.port_a, senTAsHpConIn.port_b) annotation (Line(points={{58,-70},{
          50,-70},{50,-74},{44,-74}}, color={0,127,255}));
  connect(ExprTamb.y, AsHp.Tair)
    annotation (Line(points={{105,-68},{84,-68},{84,-67},{78,-67}},
                                                          color={0,0,127}));
  connect(bou1.ports[1], tan.ports[9]) annotation (Line(points={{-56,-66},{-6.44444,
          -66},{-6.44444,0}}, color={0,127,255}));
  connect(ExprCooPer.y, pasCoo.activate)
    annotation (Line(points={{-99,30},{-94,30},{-94,16}}, color={0,0,127}));
  connect(pasCoo.TSupply, ExprTSup.y) annotation (Line(points={{-94,4},{-98,4},{
          -98,-2},{-96,-2},{-96,-4},{-94,-4},{-94,-10},{-99,-10}}, color={0,0,127}));
  connect(pasCoo.TBor, ExprTBor.y)
    annotation (Line(points={{-94,10},{-99,10}}, color={0,0,127}));
  connect(ExprTamb.y, rbcHps.TAmb) annotation (Line(points={{105,-68},{100,-68},
          {100,-172},{-350,-172},{-350,-120},{-348,-120},{-348,94},{-302,94}},
        color={0,0,127}));
  connect(ExprTSup.y, rbcHps.TTan) annotation (Line(points={{-99,-10},{-90,-10},
          {-90,-38},{-316,-38},{-316,86},{-302,86}}, color={0,0,127}));
  connect(senTBorIn.port_b, borefield.port_a)
    annotation (Line(points={{-136,170},{-120,170}}, color={0,127,255}));
  connect(borefield.port_b, senTBorOut.port_a)
    annotation (Line(points={{-100,170},{-88,170}}, color={0,127,255}));
  connect(booleanExpression.y, HeaPumPumps.u)
    annotation (Line(points={{-277,-70},{-260,-70}}, color={255,0,255}));
  connect(HeaPumPumps.y, pumpHpAir.stage) annotation (Line(points={{-237,-70},{-186,
          -70},{-186,-106},{68,-106},{68,-102}}, color={255,127,0}));
  connect(HeaPumPumps.y, pumGsHpCon.stage) annotation (Line(points={{-237,-70},{
          -206,-70},{-206,-66},{-170,-66},{-170,54}}, color={255,127,0}));
  connect(senTPanelsOut.port_a, pvt.port_b)
    annotation (Line(points={{20,196},{26,196}}, color={0,127,255}));
  connect(pvt.port_a, senTPanelsIn.port_b)
    annotation (Line(points={{46,196},{50,196}}, color={0,127,255}));
  connect(senTPanelsIn.port_a, pumPanels.port_b)
    annotation (Line(points={{62,196},{74,196}}, color={0,127,255}));
  connect(bou2.ports[1], senTPanelsOut.port_b) annotation (Line(points={{-8,195},
          {-8,196},{8,196}},                color={0,127,255}));
  connect(senTHexOut.port_a, hexPvt.port_b2)
    annotation (Line(points={{20,150},{26,150}}, color={0,127,255}));
  connect(hexPvt.port_a2, senTHexIn.port_b)
    annotation (Line(points={{46,150},{48,150}}, color={0,127,255}));
  connect(pumPanelHex.port_b, senTHexIn.port_a)
    annotation (Line(points={{76,150},{60,150}}, color={0,127,255}));
  connect(hexPvt.port_a1, senTPanelsOut.port_b) annotation (Line(points={{26,162},
          {0,162},{0,196},{8,196}}, color={0,127,255}));
  connect(pumPanels.port_a, hexPvt.port_b1) annotation (Line(points={{94,196},{100,
          196},{100,168},{46,168},{46,162}}, color={0,127,255}));
  connect(junRegSup.port_3, pumPanelHex.port_a) annotation (Line(points={{-112,134},
          {-112,128},{106,128},{106,150},{96,150}}, color={0,127,255}));
  connect(senTHexOut.port_b, junRegRet.port_3) annotation (Line(points={{8,150},
          {-26,150},{-26,132},{-132,132},{-132,134}}, color={0,127,255}));
  connect(ExprTBor1.y, rbcPvt.TBor) annotation (Line(points={{15,232},{22,232},{
          22,234},{26,234}},          color={0,0,127}));
  connect(ExprSolRad.y, rbcPvt.Irr)
    annotation (Line(points={{17,218},{22,218},{22,226},{26,226}},
                                                 color={0,0,127}));
  connect(rbcPvt.yPvt, gain1.u)
    annotation (Line(points={{49,230},{58,230}}, color={0,0,127}));
  connect(gain1.y, pumPanels.m_flow_in)
    annotation (Line(points={{81,230},{84,230},{84,208}}, color={0,0,127}));
  connect(ExprTPvt.y, rbcPvt.Tpvt) annotation (Line(points={{13,250},{18,250},{18,
          240},{26,240}}, color={0,0,127}));
  connect(ExprPgshp.y, ExprEnergyUseGsHp.u)
    annotation (Line(points={{111,50},{118,50}}, color={0,0,127}));
  connect(ExprQgshp.y, ExprHeatGsHp.u)
    annotation (Line(points={{111,10},{118,10}}, color={0,0,127}));
  connect(ExprPgshp1.y, ExprEnergyUseAsHp.u)
    annotation (Line(points={{191,50},{198,50}}, color={0,0,127}));
  connect(ExprQgshp1.y, ExprHeatAsHp.u)
    annotation (Line(points={{191,10},{198,10}}, color={0,0,127}));
  connect(ExprQPvt.y, ExprHeatPvt.u)
    annotation (Line(points={{251,52},{258,52}}, color={0,0,127}));
  connect(ExprPPvt.y, ExprElecyieldPvt.u)
    annotation (Line(points={{251,12},{258,12}}, color={0,0,127}));
  connect(ExprPBui.y, ExprEnergyUseBui.u)
    annotation (Line(points={{111,-24},{118,-24}}, color={0,0,127}));
  connect(ExprPOfftake.y, ExprTotalOfftake_kWh.u)
    annotation (Line(points={{243,-38},{250,-38}}, color={0,0,127}));
  connect(ExprPInj.y, ExprTotalInjection_kWh.u)
    annotation (Line(points={{243,-72},{250,-72}}, color={0,0,127}));
  connect(ExprPPv.y, ExprElecyieldPv.u)
    annotation (Line(points={{311,10},{318,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StijnStreuvel;
