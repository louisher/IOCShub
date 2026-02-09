within IOCSmod.Simulation.MixedUse;
model MixedUse
  import Buildings;
  extends IOCSmod.Optimization.Interface(
      priceSim(path_economic_params_json=
          "/home/u0148284/Workdir/iocs/input_data/economic_params.json"));

    // PI controller parameters
    parameter Real k_tank=1;
    parameter Real Ti_tank=300;

      // Parameters
    parameter Boolean hasReg=true "Boolean to create external ports for regeneration";

    parameter Modelica.Units.SI.HeatFlowRate Qnom_GsHp=30000 annotation(Dialog(group="Heat Flows"));

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


  IOCSmod.Simulation.MixedUse.Buildings.MixedUseCluster           buildings
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
    m_flow_nominal=1,                    VTan=0.5, nPorts=8)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.PasCoo                             pasCoo(TSetPasCoo=281.15)
    annotation (Placement(transformation(extent={{-92,0},{-72,20}})));
  Controls.RbcGshpModulating                              rbcHps
    annotation (Placement(transformation(extent={{-300,80},{-280,100}})));
  Modelica.Blocks.Math.Gain gain(k=pumHexCooEva.m_flow_nominal)
    annotation (Placement(transformation(extent={{-64,0},{-44,20}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-76,-76},{-56,-56}})));
  Modelica.Blocks.Sources.RealExpression ExprCooPer(y=buildings.Houses.coolingPeriod_real.y)
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
        hBor=170,
        cooBor=[0,0; 0,3; 3,0; 3,3],
        mBor_flow_nominal=m_flow_bor_nominal/borefield.borFieDat.conDat.nBor,
        nBor=18,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043)),
    groTemResDat(rCel(rCel={1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0,512.0,1024.0,
            2048.0,4096.0,8192.0,16384.0,32768.0,65536.0,131072.0,88257.0}),
        kappa(kappa={2.3760168457610467e-05,1.0424327160600505e-05,9.386774480676342e-06,
            9.18755592971206e-06,9.206160433351316e-06,9.266475652772272e-06,9.311622677271432e-06,
            9.350102668976697e-06,9.727215362475693e-06,1.2577215101069076e-05,2.0660479951241465e-05,
            3.460465979771661e-05,5.365855085786038e-05,7.446020314051132e-05,9.166449267662279e-05,
            0.00010006415566590472,9.728606060688624e-05,8.455322647575375e-05,3.0062985074257487e-05})))
                    annotation (Placement(transformation(extent={{-120,160},{-100,
            180}})));

  Modelica.Blocks.Math.BooleanToInteger HeaPumPumps(integerTrue=0, integerFalse=
       1) annotation (Placement(transformation(extent={{-258,-80},{-238,-60}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=buildings.Houses.coolingPeriod_real.u)
    annotation (Placement(transformation(extent={{-298,-80},{-278,-60}})));

  Modelica.Blocks.Sources.RealExpression ExprTamb(y=sim.Te) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-332,102})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseGsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Modelica.Blocks.Sources.RealExpression ExprPgshp(y=GsHp.PEl)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={120,70})));
  Modelica.Blocks.Continuous.Integrator ExprHeatGsHp(k=1/3600000)
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Modelica.Blocks.Sources.RealExpression ExprQgshp(y=GsHp.QCon)
                                                            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={120,30})));
  Modelica.Blocks.Continuous.Integrator ExprEnergyUseBui(k=1/3600000)
    annotation (Placement(transformation(extent={{140,-12},{160,8}})));
  Modelica.Blocks.Sources.RealExpression ExprPBui(y=buildings.P) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={120,-2})));
  Modelica.Blocks.Sources.RealExpression ExprTotDiscmfCoo(y=buildings.Houses.office1.DiscmfCoo.y
         + buildings.Houses.office2.DiscmfCoo.y + buildings.Houses.office3.DiscmfCoo.y
         + buildings.Houses.house1.DiscmfCoo.y + buildings.Houses.house2.DiscmfCoo.y
         + buildings.Houses.house3.DiscmfCoo.y) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={148,-30})));
  Modelica.Blocks.Sources.RealExpression ExprTotDiscmfHea(y=buildings.Houses.office1.DiscmfHea.y
         + buildings.Houses.office2.DiscmfHea.y + buildings.Houses.office3.DiscmfHea.y
         + buildings.Houses.house1.DiscmfHea.y + buildings.Houses.house2.DiscmfHea.y
         + buildings.Houses.house3.DiscmfHea.y) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={148,-50})));
  Modelica.Blocks.Continuous.Integrator ExprTotalOfftake_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{204,18},{224,38}})));
  Modelica.Blocks.Sources.RealExpression ExprPOfftake(y=max(0, GsHp.PEl +
        buildings.P)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={184,28})));
  Modelica.Blocks.Continuous.Integrator ExprTotalInjection_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{204,-16},{224,4}})));
  Modelica.Blocks.Sources.RealExpression ExprPInj(y=max(0, -1*(GsHp.PEl +
        buildings.P))) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={184,-6})));
equation
  connect(pumBor.port_b, senTBorIn.port_a)
    annotation (Line(points={{-162,170},{-148,170}}, color={0,127,255}));
  connect(senTBorOut.port_b, junHexCooSup.port_1) annotation (Line(points={{-76,
          170},{-40,170},{-40,140},{-56,140}}, color={0,127,255}));
  connect(junHexCooSup.port_2, junHexCooRet.port_1)
    annotation (Line(points={{-68,140},{-76,140}}, color={0,127,255}));
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
          {-24,-10},{-13.5,-10},{-13.5,0}},       color={0,127,255}));
  connect(pumHexCooEva.port_a, tan.ports[2]) annotation (Line(points={{-70,42},{
          -40,42},{-40,-16},{-12.5,-16},{-12.5,0}},
                                                color={0,127,255}));
  connect(pumGsHpCon.port_b, senTGsHpConOut.port_a) annotation (Line(points={{-180,
          42},{-194,42},{-194,40},{-206,40},{-206,72}}, color={0,127,255}));
  connect(pumGsHpCon.port_a, tan.ports[3]) annotation (Line(points={{-160,42},{-146,
          42},{-146,-28},{-11.5,-28},{-11.5,0}},       color={0,127,255}));
  connect(senTGsHpConIn.port_b, tan.ports[4]) annotation (Line(points={{-134,72},
          {-122,72},{-122,-22},{-10.5,-22},{-10.5,0}},       color={0,127,255}));
  connect(tan.ports[5], buildings.port_a) annotation (Line(points={{-9.5,0},{-6,
          0},{-6,-16},{54,-16},{54,0},{56,0}},
                                            color={0,127,255}));
  connect(buildings.port_b, tan.ports[6]) annotation (Line(points={{44,0},{44,-12},
          {-8.5,-12},{-8.5,0}},         color={0,127,255}));
  connect(pasCoo.PasCoo, gain.u)
    annotation (Line(points={{-70,10},{-66,10}}, color={0,0,127}));
  connect(gain.y, pumHexCooEva.m_flow_in) annotation (Line(points={{-43,10},{-50,
          10},{-50,54},{-80,54}}, color={0,0,127}));
  connect(bou.ports[1], pumBor.port_a) annotation (Line(points={{-194,188},{-182,
          188},{-182,170}}, color={0,127,255}));
  connect(bou1.ports[1], tan.ports[8]) annotation (Line(points={{-56,-66},{-6.5,
          -66},{-6.5,0}},     color={0,127,255}));
  connect(ExprCooPer.y, pasCoo.activate)
    annotation (Line(points={{-99,30},{-94,30},{-94,16}}, color={0,0,127}));
  connect(pasCoo.TSupply, ExprTSup.y) annotation (Line(points={{-94,4},{-98,4},{
          -98,-2},{-96,-2},{-96,-4},{-94,-4},{-94,-10},{-99,-10}}, color={0,0,127}));
  connect(pasCoo.TBor, ExprTBor.y)
    annotation (Line(points={{-94,10},{-99,10}}, color={0,0,127}));
  connect(ExprTSup.y, rbcHps.TTan) annotation (Line(points={{-99,-10},{-90,-10},
          {-90,-38},{-316,-38},{-316,86},{-302,86}}, color={0,0,127}));
  connect(senTBorIn.port_b, borefield.port_a)
    annotation (Line(points={{-136,170},{-120,170}}, color={0,127,255}));
  connect(borefield.port_b, senTBorOut.port_a)
    annotation (Line(points={{-100,170},{-88,170}}, color={0,127,255}));
  connect(booleanExpression.y, HeaPumPumps.u)
    annotation (Line(points={{-277,-70},{-260,-70}}, color={255,0,255}));
  connect(HeaPumPumps.y, pumGsHpCon.stage) annotation (Line(points={{-237,-70},{
          -206,-70},{-206,-66},{-170,-66},{-170,54}}, color={255,127,0}));
  connect(junHexCooRet.port_2, junGsHpSup.port_1) annotation (Line(points={{-88,
          140},{-88,118},{-116,118},{-116,140},{-154,140}}, color={0,127,255}));
  connect(ExprTamb.y, rbcHps.TAmb) annotation (Line(points={{-321,102},{-310,102},
          {-310,94},{-302,94}}, color={0,0,127}));
  connect(rbcHps.GsHp, GsHp.mod) annotation (Line(points={{-278,90},{-268,90},{-268,
          88},{-258,88},{-258,64},{-154,64},{-154,82},{-159,82}}, color={0,0,127}));
  connect(ExprPgshp.y, ExprEnergyUseGsHp.u)
    annotation (Line(points={{131,70},{138,70}}, color={0,0,127}));
  connect(ExprQgshp.y, ExprHeatGsHp.u)
    annotation (Line(points={{131,30},{138,30}}, color={0,0,127}));
  connect(ExprPBui.y, ExprEnergyUseBui.u)
    annotation (Line(points={{131,-2},{138,-2}}, color={0,0,127}));
  connect(ExprPOfftake.y, ExprTotalOfftake_kWh.u)
    annotation (Line(points={{195,28},{202,28}}, color={0,0,127}));
  connect(ExprPInj.y, ExprTotalInjection_kWh.u)
    annotation (Line(points={{195,-6},{202,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MixedUse;
