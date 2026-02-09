within IOCSmod.Blocks.EnergyHub;
model SwitchingFrameworkOpt
    extends BaseClasses.EnergyHubInterface;

  /* Cost parameters */
  parameter String path_devices_json "path the devices.json file";
  parameter String path_economic_params_json "path the the economic_params.json file";


  parameter Modelica.Units.SI.MassFlowRate m_flow_hexReg_nominal = 12000/4180/5;


    replaceable parameter IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.PVT_DualSun_Spring425_ShingleBlack per_PVT constrainedby
    Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic                                                                                               "Performance data"
    annotation (Dialog(tab="PVT", group="Thermal"), Placement(transformation(extent={{110,82},{130,102}})), choicesAllMatching=true);

  ComponentModels.Thermal.SizeOpt.SimpleTankOpt
                                     tan1(
    inv_cost=inv_cost_Tank,
    interest_rate=priceSim.interest_rate,
    lifetime=lifetime_Tank,
    observation_time=priceSim.observation_time,
                                          m_flow_nominal=GsHp.m_flow_gshp_nominal,
                                          nPorts=8)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  ComponentModels.Thermal.SizeOpt.SimpleTankOpt
                                     tan2(
    inv_cost=inv_cost_Tank,
    interest_rate=priceSim.interest_rate,
    lifetime=lifetime_Tank,
    observation_time=priceSim.observation_time,
                                          m_flow_nominal=GsHp.m_flow_gshp_nominal,
                                          nPorts=4)
    annotation (Placement(transformation(extent={{-22,118},{-2,138}})));
  ComponentModels.Thermal.SizeOpt.GsHpOpt
                               GsHp(
    addDummyEquation=addDummyEquation,
    inv_cost_hp=inv_cost_GsHp,
    inv_cost_bor=inv_cost_Bor,
    interest_rate=priceSim.interest_rate,
    lifetime_hp=lifetime_GsHp,
    lifetime_bor=lifetime_Bor,
    observation_time=priceSim.observation_time,
    TBorMin=273.15,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        dp_nominal(displayUnit="Pa"))),
    pumHexCooEva(m_flow_in=0.0001,inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-470,-50})));

  ComponentModels.Thermal.SizeOpt.AsHpOpt
                               AsHp(addDummyEquation=addDummyEquation,
    inv_cost=inv_cost_AsHp,
    interest_rate=priceSim.interest_rate,
    lifetime=lifetime_AsHp,
    observation_time=priceSim.observation_time,
    copDef=5.8854,
    TAir_nominal=285.75,
    TConOut_nominal=307.52,
    coeffEva=0.1537,
    coeffCon=-0.1421)               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-470,90})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hexReg(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_hexReg_nominal,
    m2_flow_nominal=m_flow_hexReg_nominal,
    dp1_nominal=10000,
    dp2_nominal=10000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-390,20})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hexAsHp(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=AsHp.m_flow_ashp_nominal,
    m2_flow_nominal=AsHp.m_flow_ashp_nominal,
    dp1_nominal=10000,
    dp2_nominal=1,
    eps=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-390,90})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hexGsHp(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=GsHp.m_flow_gshp_nominal,
    m2_flow_nominal=GsHp.m_flow_gshp_nominal,
    dp1_nominal=10000,
    dp2_nominal=1,
    eps=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-390,-50})));
  UnitTests.Confidential.FlowControlled_dp pumAsHpHex(redeclare package Medium =
        Medium,
    m_flow_nominal=AsHp.m_flow_ashp_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    dp_nominal=30000)
    annotation (Placement(transformation(extent={{-320,100},{-340,120}})));
  UnitTests.Confidential.FlowControlled_dp pumGsHpHex(redeclare package Medium =
        Medium,
    m_flow_nominal=GsHp.m_flow_gshp_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    dp_nominal=30000)
    annotation (Placement(transformation(extent={{-322,-40},{-342,-20}})));

  UnitTests.Components.TwoWayLinear valAsHpC2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=AsHp.m_flow_ashp_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-310,150})));
  UnitTests.Components.TwoWayLinear valAsHpH2(redeclare package Medium =
        IDEAS.Media.Water,
    m_flow_nominal=AsHp.m_flow_ashp_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-280,150})));
  UnitTests.Components.TwoWayLinear valAsHpC1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=AsHp.m_flow_ashp_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-310,-110})));
  UnitTests.Components.TwoWayLinear valAsHpH1(redeclare package Medium =
        IDEAS.Media.Water,
    m_flow_nominal=AsHp.m_flow_ashp_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-280,-110})));
  UnitTests.Components.TwoWayLinear valHexH2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexReg.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-230,150})));
  UnitTests.Components.TwoWayLinear valHexC2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexReg.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,150})));
  UnitTests.Components.TwoWayLinear valHexH1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexReg.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-230,-110})));
  UnitTests.Components.TwoWayLinear valHexC1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexReg.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-200,-110})));
  UnitTests.Components.TwoWayLinear valGsHpC2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexGsHp.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-150,150})));
  UnitTests.Components.TwoWayLinear valGsHpH2(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexGsHp.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-120,150})));
  UnitTests.Components.TwoWayLinear valGsHpH1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexGsHp.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-120,-110})));
  UnitTests.Components.TwoWayLinear valGsHpC1(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=hexGsHp.m1_flow_nominal,
    dpValve_nominal=10000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-150,-110})));
  UnitTests.Confidential.FlowControlled_dp pumHex(redeclare package Medium =
        Medium,
    m_flow_nominal=m_flow_hexReg_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    dp_nominal=30000)
    annotation (Placement(transformation(extent={{-320,30},{-340,50}})));
  Modelica.Blocks.Interfaces.RealInput conValAshp2(
    quantity="free",
    min=0.001,
    max=1,
    nominal=1/AsHp.AsHp.HP.Q_flow_nominal)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-298,240})));
  Modelica.Blocks.Interfaces.RealInput conValAshp1(
    quantity="free",
    min=0.001,
    max=1,
    nominal=1/AsHp.AsHp.HP.Q_flow_nominal)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-296,-200})));
  Modelica.Blocks.Interfaces.RealInput conValGshp1(
    quantity="free",
    min=0.001,
    max=1,
    nominal=1/GsHp.GsHp.Q_flow_nominal)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-136,-200})));
  Modelica.Blocks.Interfaces.RealInput conValGshp2(
    quantity="free",
    min=0.001,
    max=1,
    nominal=1/GsHp.GsHp.Q_flow_nominal)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-132,240})));
  Modelica.Blocks.Interfaces.RealInput conValHex1(
    quantity="free",
    min=0.001,
    max=1,
    nominal=1/(pumHex.m_flow_nominal*4180*5))
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-214,-200})));
  Modelica.Blocks.Interfaces.RealInput conValHex2(
    quantity="free",
    min=0.001,
    max=1,
    nominal=1/(pumHex.m_flow_nominal*4180*5))
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-212,240})));
  ComponentModels.Thermal.SizeOpt.StcOpt stc(
    addDummyEquation=addDummyEquation,
    inv_cost=inv_cost_STC,
    interest_rate=priceSim.interest_rate,
    lifetime=lifetime_STC,
    observation_time=priceSim.observation_time,
    hasReg=false,
    selDefault=0,
    azi=0.8936085770211,
    til=0.92502450355699,
    rho=0.2,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    dT_nominal=30,
    redeclare
      IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F
      per)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-26})));

  UnitTests.Confidential.FlowControlled_dp pumHexBor(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_hexReg_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    dp_nominal=10000)
    annotation (Placement(transformation(extent={{-450,-10},{-430,10}})));
  Modelica.Blocks.Math.Sum Pnet(nin=4)
    annotation (Placement(visible = true, transformation(origin={-60,90},     extent={{10,-10},
            {-10,10}},                                                                                         rotation=0)));
  Modelica.Units.SI.HeatFlowRate QEnergyHub;
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-444,104},{-456,116}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-444,-36},{-456,-24}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexAsHpPrimIn(
    redeclare package Medium = Medium,
    m_flow_nominal=AsHp.m_flow_ashp_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-410,70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexAsHpPrimOut(
    redeclare package Medium = Medium,
    m_flow_nominal=AsHp.m_flow_ashp_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-410,110})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexAsHpSecOut(
    redeclare package Medium = Medium,
    m_flow_nominal=hexAsHp.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-360,70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexAsHpSecIn(
    redeclare package Medium = Medium,
    m_flow_nominal=hexAsHp.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-360,110})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexRegPrimIn(
    redeclare package Medium = Medium,
    m_flow_nominal=hexReg.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-410,0})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexRegPrimOut(
    redeclare package Medium = Medium,
    m_flow_nominal=hexReg.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-410,40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexRegSecIn(
    redeclare package Medium = Medium,
    m_flow_nominal=hexReg.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-360,40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexRegSecOut(
    redeclare package Medium = Medium,
    m_flow_nominal=hexReg.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-360,0})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexGsHpPrimOut(
    redeclare package Medium = Medium,
    m_flow_nominal=hexGsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-410,-30})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexGsHpPrimIn(
    redeclare package Medium = Medium,
    m_flow_nominal=hexGsHp.m2_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-410,-70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexGsHpSecIn(
    redeclare package Medium = Medium,
    m_flow_nominal=hexGsHp.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-360,-30})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexGsHpSecOut(
    redeclare package Medium = Medium,
    m_flow_nominal=hexGsHp.m1_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-360,-70})));
  IDEAS.Fluid.FixedResistances.Junction junAsHpIn(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={hexAsHp.m1_flow_nominal,hexAsHp.m1_flow_nominal,hexAsHp.m1_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=90,
        origin={-310,110})));

  IDEAS.Fluid.FixedResistances.Junction junAsHpOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={hexAsHp.m1_flow_nominal,hexAsHp.m1_flow_nominal,hexAsHp.m1_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=90,
        origin={-280,70})));

  IDEAS.Fluid.FixedResistances.Junction junRegIn(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={hexReg.m1_flow_nominal,hexReg.m1_flow_nominal,hexReg.m1_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=90,
        origin={-230,40})));

  IDEAS.Fluid.FixedResistances.Junction junRegOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={hexReg.m1_flow_nominal,hexReg.m1_flow_nominal,hexReg.m1_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=90,
        origin={-200,0})));

  IDEAS.Fluid.FixedResistances.Junction junGsHpIn(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={hexGsHp.m1_flow_nominal,hexGsHp.m1_flow_nominal,hexGsHp.m1_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=90,
        origin={-150,-30})));

  IDEAS.Fluid.FixedResistances.Junction junGsHpOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={hexGsHp.m1_flow_nominal,hexGsHp.m1_flow_nominal,hexGsHp.m1_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=90,
        origin={-120,-70})));


  IDEAS.Fluid.Sensors.TemperatureTwoPort senTtan1HFlow(
    redeclare package Medium = Medium,
    m_flow_nominal=hexAsHp.m1_flow_nominal + hexReg.m1_flow_nominal + hexGsHp.m1_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-60,-130})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTtan1CFlow(
    redeclare package Medium = Medium,
    m_flow_nominal=hexAsHp.m1_flow_nominal + hexReg.m1_flow_nominal + hexGsHp.m1_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-60,-150})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTtanIntFlow(
    redeclare package Medium = Medium,
    m_flow_nominal=hexAsHp.m1_flow_nominal + hexReg.m1_flow_nominal + hexGsHp.m1_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-12,48})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTtan2CFlow(
    redeclare package Medium = Medium,
    m_flow_nominal=hexAsHp.m1_flow_nominal + hexReg.m1_flow_nominal + hexGsHp.m1_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-60,134})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTtan2HFlow(
    redeclare package Medium = Medium,
    m_flow_nominal=hexAsHp.m1_flow_nominal + hexReg.m1_flow_nominal + hexGsHp.m1_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-60,160})));

  Modelica.Fluid.Interfaces.FluidPort_a ColH2(redeclare package Medium = Medium)
    if hasHyd "Hydronic inlet port"
    annotation (Placement(transformation(extent={{-270,190},{-250,210}})));
  Modelica.Fluid.Interfaces.FluidPort_a ColC2(redeclare package Medium = Medium)
    if hasHyd "Hydronic inlet port"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  Modelica.Fluid.Interfaces.FluidPort_a ColH1(redeclare package Medium = Medium)
    if hasHyd "Hydronic inlet port"
    annotation (Placement(transformation(extent={{-270,-170},{-250,-150}})));
  Modelica.Fluid.Interfaces.FluidPort_a ColC1(redeclare package Medium = Medium)
    if hasHyd "Hydronic inlet port"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  ComponentModels.Electrical.SizeOpt.LinearBatteryOpt bat(
    inv_cost=inv_cost_Bat,
    interest_rate=priceSim.interest_rate,
    lifetime=lifetime_Bat,
    observation_time=priceSim.observation_time)
    annotation (Placement(transformation(extent={{-78,80},{-98,100}})));
  ComponentModels.Thermal.SizeOpt.PvtOpt pvt(
    inv_cost=inv_cost_PVT,
    interest_rate=priceSim.interest_rate,
    lifetime=lifetime_PVT,
    observation_time=priceSim.observation_time,
    addDummyEquation=addDummyEquation,
    optSel=true,
    azi=0,
    til=0.78539816339745,
    rho=0.2,
    dT_nominal=10,                           per=per_PVT)
    annotation (Placement(transformation(extent={{36,2},{56,22}})));
  ComponentModels.Electrical.SizeOpt.PVPanelDC_AreaOpt pv(
    inv_cost=inv_cost_PV,
    interest_rate=priceSim.interest_rate,
    lifetime=lifetime_PV,
    observation_time=priceSim.observation_time)
    annotation (Placement(transformation(extent={{-34,80},{-14,100}})));


  /* Investement cost parameters*/
  parameter ExternData.JSONFile jsonreader_devices(fileName=path_devices_json) annotation(evaluate=false);

  parameter Real inv_cost_GsHp(fixed=false, start=0) "Investment cost per unit of Size (€/kW)";
  parameter Integer lifetime_GsHp(fixed=false, start=0) "Lifetime of GSHP";
  parameter Real inv_cost_AsHp(fixed=false, start=0) "Investment cost per unit of Size (€/kW)";
  parameter Integer lifetime_AsHp(fixed=false, start=0) "Lifetime of ASHP";
  parameter Real inv_cost_Bor(fixed=false, start=0) "Investment cost per unit of Size (€/m)";
  parameter Integer lifetime_Bor(fixed=false, start=0) "Lifetime of borefield";
  parameter Real inv_cost_STC(fixed=false, start=0) "Investment cost per unit of Size (€/m2)";
  parameter Integer lifetime_STC(fixed=false, start=0) "Lifetime of solar collectors";
  parameter Real inv_cost_PVT(fixed=false, start=0) "Investment cost per unit of Size (€/m2)";
  parameter Integer lifetime_PVT(fixed=false, start=0) "Lifetime of PVT";
  parameter Real inv_cost_PV(fixed=false, start=0) "Investment cost per unit of Size (€/m2)";
  parameter Integer lifetime_PV(fixed=false, start=0) "Lifetime of PV";
  parameter Real inv_cost_Bat(fixed=false, start=0) "Investment cost per unit of Size (€/kWh)";
  parameter Integer lifetime_Bat(fixed=false, start=0) "Lifetime of battery";
  parameter Real inv_cost_Tank(fixed=false, start=0) "Investment cost per unit of Size (€/m3)";
  parameter Integer lifetime_Tank(fixed=false, start=0) "Lifetime of tank";
initial equation
  inv_cost_GsHp = jsonreader_devices.getReal("GSHP.inv_cost");
  lifetime_GsHp = jsonreader_devices.getInteger("GSHP.life_time");

  inv_cost_AsHp   = jsonreader_devices.getReal("ASHP.inv_cost");
  lifetime_AsHp   = jsonreader_devices.getInteger("ASHP.life_time");

  inv_cost_Bor    = jsonreader_devices.getReal("Borefield.inv_cost");
  lifetime_Bor    = jsonreader_devices.getInteger("Borefield.life_time");

  inv_cost_STC    = jsonreader_devices.getReal("STC.inv_cost");
  lifetime_STC    = jsonreader_devices.getInteger("STC.life_time");

  inv_cost_PVT    = jsonreader_devices.getReal("PVT.inv_cost");
  lifetime_PVT    = jsonreader_devices.getInteger("PVT.life_time");

  inv_cost_PV     = jsonreader_devices.getReal("PV.inv_cost");
  lifetime_PV     = jsonreader_devices.getInteger("PV.life_time");

  inv_cost_Bat    = jsonreader_devices.getReal("BAT.inv_cost");
  lifetime_Bat    = jsonreader_devices.getInteger("BAT.life_time");

  inv_cost_Tank    = jsonreader_devices.getReal("TES.inv_cost");
  lifetime_Tank    = jsonreader_devices.getInteger("TES.life_time");


equation
    QEnergyHub = port_a.m_flow*(inStream(port_a.h_outflow) - port_b.h_outflow);
  connect(port_a, tan1.ports[1]) annotation (Line(points={{60,-100},{60,-52},{-12,
          -52},{-12,-14},{-13.5,-14},{-13.5,-10}},
                          color={0,127,255}));
  connect(stc.port_a, tan1.ports[2]) annotation (Line(points={{36,-32},{30,-32},
          {30,-30},{-8,-30},{-8,-14},{-12.5,-14},{-12.5,-10}},
                              color={0,127,255}));
  connect(stc.port_b, tan1.ports[3]) annotation (Line(points={{36,-20},{-8,-20},
          {-8,-14},{-11.5,-14},{-11.5,-10}},color={0,127,255}));
  connect(hexAsHp.port_b2, senTHexAsHpPrimOut.port_a) annotation (Line(points={{
          -396,100},{-396,110},{-404,110}}, color={0,127,255}));
  connect(hexAsHp.port_a2, senTHexAsHpPrimIn.port_b) annotation (Line(points={{-396,
          80},{-396,70},{-404,70}}, color={0,127,255}));
  connect(AsHp.port_a, senTHexAsHpPrimOut.port_b) annotation (Line(points={{-460,
          96},{-440,96},{-440,110},{-416,110}}, color={0,127,255}));
  connect(AsHp.port_b, senTHexAsHpPrimIn.port_a) annotation (Line(points={{-460,
          84},{-440,84},{-440,70},{-416,70}}, color={0,127,255}));
  connect(senTHexAsHpSecIn.port_b, hexAsHp.port_a1) annotation (Line(points={{-366,
          110},{-384,110},{-384,100}}, color={0,127,255}));
  connect(senTHexAsHpSecOut.port_a, hexAsHp.port_b1) annotation (Line(points={{-366,
          70},{-384,70},{-384,80}}, color={0,127,255}));
  connect(senTHexAsHpSecIn.port_a, pumAsHpHex.port_b)
    annotation (Line(points={{-354,110},{-340,110}}, color={0,127,255}));
  connect(senTHexRegPrimIn.port_b, hexReg.port_a2)
    annotation (Line(points={{-404,0},{-396,0},{-396,10}}, color={0,127,255}));
  connect(hexReg.port_b2, senTHexRegPrimOut.port_a) annotation (Line(points={{-396,
          30},{-396,40},{-404,40}}, color={0,127,255}));
  connect(senTHexRegSecIn.port_b, hexReg.port_a1) annotation (Line(points={{-366,
          40},{-384,40},{-384,30}}, color={0,127,255}));
  connect(senTHexRegSecOut.port_a, hexReg.port_b1)
    annotation (Line(points={{-366,0},{-384,0},{-384,10}}, color={0,127,255}));
  connect(pumHex.port_b, senTHexRegSecIn.port_a)
    annotation (Line(points={{-340,40},{-354,40}}, color={0,127,255}));
  connect(pumHexBor.port_b, senTHexRegPrimIn.port_a)
    annotation (Line(points={{-430,0},{-416,0}}, color={0,127,255}));
  connect(GsHp.port_aReg, senTHexRegPrimOut.port_b) annotation (Line(points={{-475,
          -60},{-475,-66},{-486,-66},{-486,40},{-416,40}}, color={0,127,255}));
  connect(pumHexBor.port_a, GsHp.port_bReg) annotation (Line(points={{-450,0},{-475,
          0},{-475,-40}}, color={0,127,255}));
  connect(senTHexGsHpPrimIn.port_b, hexGsHp.port_a2) annotation (Line(points={{-404,
          -70},{-396,-70},{-396,-60}}, color={0,127,255}));
  connect(hexGsHp.port_b2, senTHexGsHpPrimOut.port_a) annotation (Line(points={{
          -396,-40},{-396,-30},{-404,-30}}, color={0,127,255}));
  connect(senTHexGsHpPrimOut.port_b, GsHp.port_a) annotation (Line(points={{-416,
          -30},{-440,-30},{-440,-44},{-460,-44}}, color={0,127,255}));
  connect(senTHexGsHpPrimIn.port_a, GsHp.port_b) annotation (Line(points={{-416,
          -70},{-440,-70},{-440,-56},{-460,-56}}, color={0,127,255}));
  connect(bou.ports[1], AsHp.port_a) annotation (Line(points={{-456,110},{-456,96},
          {-460,96}}, color={0,127,255}));
  connect(bou1.ports[1], GsHp.port_a) annotation (Line(points={{-456,-30},{-456,
          -44},{-460,-44}}, color={0,127,255}));
  connect(pumGsHpHex.port_b, senTHexGsHpSecIn.port_a)
    annotation (Line(points={{-342,-30},{-354,-30}}, color={0,127,255}));
  connect(senTHexGsHpSecIn.port_b, hexGsHp.port_a1) annotation (Line(points={{-366,
          -30},{-384,-30},{-384,-40}}, color={0,127,255}));
  connect(hexGsHp.port_b1, senTHexGsHpSecOut.port_a) annotation (Line(points={{-384,
          -60},{-384,-70},{-366,-70}}, color={0,127,255}));
  connect(senTHexAsHpSecOut.port_b, junAsHpOut.port_3)
    annotation (Line(points={{-354,70},{-285,70}}, color={0,127,255}));
  connect(pumAsHpHex.port_a, junAsHpIn.port_3)
    annotation (Line(points={{-320,110},{-315,110}}, color={0,127,255}));
  connect(pumHex.port_a, junRegIn.port_3)
    annotation (Line(points={{-320,40},{-235,40}}, color={0,127,255}));
  connect(senTHexRegSecOut.port_b, junRegOut.port_3)
    annotation (Line(points={{-354,0},{-205,3.05311e-16}}, color={0,127,255}));
  connect(junGsHpOut.port_3, senTHexGsHpSecOut.port_b)
    annotation (Line(points={{-125,-70},{-354,-70}}, color={0,127,255}));
  connect(junGsHpIn.port_3, pumGsHpHex.port_a)
    annotation (Line(points={{-155,-30},{-322,-30}}, color={0,127,255}));
  connect(valAsHpC1.y, valAsHpH1.y)
    annotation (Line(points={{-298,-110},{-292,-110}}, color={0,0,127}));
  connect(conValAshp1,valAsHpH1. y) annotation (Line(points={{-296,-200},{-296,-110},
          {-292,-110}}, color={0,0,127}));
  connect(valGsHpC1.y, valGsHpH1.y)
    annotation (Line(points={{-138,-110},{-132,-110}}, color={0,0,127}));
  connect(conValGshp1, valGsHpC1.y) annotation (Line(points={{-136,-200},{-136,-110},
          {-138,-110}}, color={0,0,127}));
  connect(conValHex1, valHexC1.y) annotation (Line(points={{-214,-200},{-214,-110},
          {-212,-110}}, color={0,0,127}));
  connect(valHexH1.y, valHexC1.y)
    annotation (Line(points={{-218,-110},{-212,-110}}, color={0,0,127}));
  connect(valAsHpC2.y, valAsHpH2.y)
    annotation (Line(points={{-298,150},{-292,150}}, color={0,0,127}));
  connect(valAsHpC2.y, conValAshp2)
    annotation (Line(points={{-298,150},{-298,240}}, color={0,0,127}));
  connect(valHexH2.y, valHexC2.y)
    annotation (Line(points={{-218,150},{-212,150}}, color={0,0,127}));
  connect(valGsHpC2.y, valGsHpH2.y)
    annotation (Line(points={{-138,150},{-132,150}}, color={0,0,127}));
  connect(tan2.ports[1], port_b) annotation (Line(points={{-15,118},{-14,118},{-14,
          74},{134,74},{134,-112},{-60,-112},{-60,-100}}, color={0,127,255}));
  connect(AsHp.P, Pnet.u[1]) annotation (Line(points={{-464.6,101},{-464.6,324},
          {-40,324},{-40,88.5},{-48,88.5}},
                                        color={0,0,127}));
  connect(GsHp.P, Pnet.u[2]) annotation (Line(points={{-464.6,-39},{-464.6,324},
          {-40,324},{-40,89.5},{-48,89.5}},
                                        color={0,0,127}));
  connect(conValHex2, valHexC2.y)
    annotation (Line(points={{-212,240},{-212,150}}, color={0,0,127}));
  connect(conValGshp2, valGsHpH2.y)
    annotation (Line(points={{-132,240},{-132,150}}, color={0,0,127}));
  connect(valHexH2.port_b, junRegIn.port_1)
    annotation (Line(points={{-230,140},{-230,45}}, color={0,127,255}));
  connect(valHexC2.port_a, junRegOut.port_1)
    annotation (Line(points={{-200,140},{-200,5}}, color={0,127,255}));
  connect(valAsHpC2.port_b, junAsHpIn.port_1)
    annotation (Line(points={{-310,140},{-310,115}}, color={0,127,255}));
  connect(junAsHpOut.port_1, valAsHpH2.port_a)
    annotation (Line(points={{-280,75},{-280,140}}, color={0,127,255}));
  connect(valGsHpC2.port_b, junGsHpIn.port_1)
    annotation (Line(points={{-150,140},{-150,-25}}, color={0,127,255}));
  connect(valGsHpH2.port_a, junGsHpOut.port_1)
    annotation (Line(points={{-120,140},{-120,-65}}, color={0,127,255}));
  connect(valAsHpC1.port_b, junAsHpIn.port_2)
    annotation (Line(points={{-310,-100},{-310,105}}, color={0,127,255}));
  connect(junAsHpOut.port_2, valAsHpH1.port_a)
    annotation (Line(points={{-280,65},{-280,-100}}, color={0,127,255}));
  connect(valHexH1.port_b, junRegIn.port_2)
    annotation (Line(points={{-230,-100},{-230,35}}, color={0,127,255}));
  connect(junRegOut.port_2, valHexC1.port_a)
    annotation (Line(points={{-200,-5},{-200,-100}}, color={0,127,255}));
  connect(valGsHpC1.port_b, junGsHpIn.port_2)
    annotation (Line(points={{-150,-100},{-150,-35}}, color={0,127,255}));
  connect(junGsHpOut.port_2, valGsHpH1.port_a)
    annotation (Line(points={{-120,-75},{-120,-100}}, color={0,127,255}));
  connect(senTtan1CFlow.port_a, tan1.ports[4]) annotation (Line(points={{-54,-150},
          {-10.5,-150},{-10.5,-10}},       color={0,127,255}));
  connect(senTtan1HFlow.port_b, tan1.ports[5]) annotation (Line(points={{-54,-130},
          {-9.5,-130},{-9.5,-10}},
                               color={0,127,255}));
  connect(tan1.ports[6], senTtanIntFlow.port_a) annotation (Line(points={{-8.5,-10},
          {-8,-10},{-8,-20},{6,-20},{6,32},{-12,32},{-12,42}},      color={0,127,
          255}));
  connect(senTtanIntFlow.port_b, tan2.ports[2]) annotation (Line(points={{-12,54},
          {-12,74},{-14,74},{-14,114},{-13,114},{-13,118}}, color={0,127,255}));
  connect(senTtan2HFlow.port_b, tan2.ports[3]) annotation (Line(points={{-54,160},
          {-30,160},{-30,106},{-11,106},{-11,118}}, color={0,127,255}));
  connect(senTtan2CFlow.port_a, tan2.ports[4]) annotation (Line(points={{-54,134},
          {-30,134},{-30,106},{-9,106},{-9,118}}, color={0,127,255}));
  connect(valAsHpH2.port_b, ColH2) annotation (Line(points={{-280,160},{-280,
          170},{-260,170},{-260,200}}, color={0,127,255}));
  connect(valHexH2.port_a, ColH2) annotation (Line(points={{-230,160},{-230,170},
          {-260,170},{-260,200}}, color={0,127,255}));
  connect(valGsHpH2.port_b, ColH2) annotation (Line(points={{-120,160},{-120,
          170},{-260,170},{-260,200}}, color={0,127,255}));
  connect(valAsHpC2.port_a, ColC2) annotation (Line(points={{-310,160},{-310,
          180},{-170,180},{-170,200}}, color={0,127,255}));
  connect(valHexC2.port_b, ColC2) annotation (Line(points={{-200,160},{-200,180},
          {-170,180},{-170,200}}, color={0,127,255}));
  connect(valGsHpC2.port_a, ColC2) annotation (Line(points={{-150,160},{-150,
          180},{-170,180},{-170,200}}, color={0,127,255}));
  connect(ColC2, senTtan2CFlow.port_b) annotation (Line(points={{-170,200},{
          -170,260},{-90,260},{-90,134},{-66,134}}, color={0,127,255}));
  connect(ColH2, senTtan2HFlow.port_a) annotation (Line(points={{-260,200},{
          -260,280},{-80,280},{-80,160},{-66,160}}, color={0,127,255}));
  connect(valAsHpH1.port_b, ColH1) annotation (Line(points={{-280,-120},{-280,
          -140},{-260,-140},{-260,-160}}, color={0,127,255}));
  connect(valHexH1.port_a, ColH1) annotation (Line(points={{-230,-120},{-230,
          -140},{-260,-140},{-260,-160}}, color={0,127,255}));
  connect(valGsHpH1.port_b, ColH1) annotation (Line(points={{-120,-120},{-120,
          -140},{-260,-140},{-260,-160}}, color={0,127,255}));
  connect(ColH1, senTtan1HFlow.port_a) annotation (Line(points={{-260,-160},{
          -260,-240},{-90,-240},{-90,-130},{-66,-130}}, color={0,127,255}));
  connect(valAsHpC1.port_a, ColC1) annotation (Line(points={{-310,-120},{-310,
          -130},{-170,-130},{-170,-160}}, color={0,127,255}));
  connect(valHexC1.port_b, ColC1) annotation (Line(points={{-200,-120},{-200,
          -130},{-170,-130},{-170,-160}}, color={0,127,255}));
  connect(valGsHpC1.port_a, ColC1) annotation (Line(points={{-150,-120},{-152,
          -120},{-152,-130},{-170,-130},{-170,-160}}, color={0,127,255}));
  connect(ColC1, senTtan1CFlow.port_b) annotation (Line(points={{-170,-160},{
          -170,-234},{-98,-234},{-98,-150},{-66,-150}}, color={0,127,255}));
  connect(Pnet.y, bat.PDem)
    annotation (Line(points={{-71,90},{-76,90}}, color={0,0,127}));
  connect(bat.PGrid, P)
    annotation (Line(points={{-98,90},{-110,90}}, color={0,0,127}));
  connect(pvt.port_b, tan1.ports[7]) annotation (Line(points={{40,2},{40,-6},{16,
          -6},{16,-22},{-7.5,-22},{-7.5,-10}}, color={0,127,255}));
  connect(pvt.port_a, tan1.ports[8]) annotation (Line(points={{52,2},{52,-10},{20,
          -10},{20,-26},{-6.5,-26},{-6.5,-10}}, color={0,127,255}));
  connect(pvt.port_aReg, GsHp.port_bReg) annotation (Line(points={{56,12},{82,12},
          {82,-244},{-500,-244},{-500,-34},{-475,-34},{-475,-40}}, color={0,127,
          255}));
  connect(pvt.port_bReg, GsHp.port_aReg) annotation (Line(points={{56,4},{70,4},
          {70,-260},{-475,-260},{-475,-60}}, color={0,127,255}));
  connect(pv.P, Pnet.u[3]) annotation (Line(points={{-35,90},{-42,90},{-42,90.5},
          {-48,90.5}}, color={0,0,127}));
  connect(pvt.P, Pnet.u[4]) annotation (Line(points={{57,6.6},{58,6.6},{58,70},{
          -46,70},{-46,91.5},{-48,91.5}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-500,-180},{100,220}})));
end SwitchingFrameworkOpt;
