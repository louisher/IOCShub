within IOCSmod.ComponentModels.Thermal;
model GsHp "Model of a GSHP with optimizable borefield model and passive cooling heat exchanger in series with condensor:
  The COP parameters of the heat pump are determined using the calibration script in IOCS/Datasheets/TacoCalibration.py and are based on the Viessmann VitoCal300G_BWS_A21 of 2024"
  extends IOCSmod.ComponentModels.BaseClasses.ElecThermInterface;

    // Parameters
    parameter Boolean hasReg=true "Boolean to create external ports for regeneration";

    parameter Modelica.Units.SI.HeatFlowRate Qnom_GsHp annotation(Dialog(group="Heat Flows"));

    parameter Modelica.Units.SI.MassFlowRate m_flow_gshp_nominal= Qnom_GsHp/4180/GsHp.dT_max
      "Nominal mass flow gshp condensor" annotation(Dialog(group="Mass Flows"));
    parameter Modelica.Units.SI.MassFlowRate m_flow_bor_nominal= if borFieDat.conDat.hBor > 1 then 0.2*borFieDat.conDat.nBor else 0
      "Nominal mass flow borefield loop" annotation(Dialog(group="Mass Flows"));
    parameter Modelica.Units.SI.MassFlowRate m_flow_hex_coo_nominal= m_flow_bor_nominal
      "Nomtinal mass flow of the cooling side of the cooling heat exchanger" annotation(Dialog(group="Mass Flows"));
    parameter Modelica.Units.SI.Temperature TBorMin "Minimum allowable borefield temperature (to be used in objective)";

    parameter IDEAS.Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat(
      filDat(
        kFil=2,
        cFil=840,
        dFil(displayUnit="kg/m3") = 1818),
      soiDat(
        kSoi=1.9,
        cSoi=900,
        dSoi=1400),
      conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        Rb(unit="(m.K)/W"),
        mBorFie_flow_nominal=m_flow_bor_nominal,
        dp_nominal(displayUnit="Pa") = 1,
        hBor=100,
        cooBor=[0,0; 0,3; 3,0; 3,3],
        mBor_flow_nominal=borefield.borFieDat.conDat.mBorFie_flow_nominal/
            borefield.borFieDat.conDat.nBor,
        nBor=4,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043)) "Borefield data" annotation(Dialog(group="Borefield"));

    parameter Borefields.BaseClasses.HeatTransfer.Data.GroundResponseDataTemplate groTemResDat(kappa(kappa(each fixed=false)), rCel(rCel(each fixed=false))) "Ground response parameters" annotation(Dialog(group="Borefield"));

    parameter Modelica.Units.SI.TemperatureDifference dT_max=5
      "Maximum temperature difference across condenser" annotation(Dialog(group="Heat pump"));
    parameter Real copDef=5.00625 "Default COP" annotation(Dialog(group="Heat pump"));
    parameter Real coeffEva[2]={-280.15, 0.1103557} annotation(Dialog(group="Heat pump"));
    parameter Real coeffCon[2]={-313.15,-0.1037086} annotation(Dialog(group="Heat pump"));

   Modelica.Fluid.Interfaces.FluidPort_a port_aReg(redeclare package Medium=Medium) if hasReg "Hydronic inlet port for borefield regeneration"
        annotation (Placement(transformation(extent={{-110,40},{-90,60}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bReg(redeclare package Medium=Medium) if hasReg "Hydronic outlet port for borefield regeneration"
        annotation (Placement(transformation(extent={{90,40},{110,60}})));

    UnitTests.Confidential.FlowControlled_m_flow pumHexCooEva(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_hex_coo_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Optimize,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=hexCoo.dp2_nominal,
    addDummyEquation=addDummyEquation)
                                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={30,-38})));
  UnitTests.Components.FlowControlled_dp       pumBor(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_bor_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=borFieDat.conDat.dp_nominal)
                                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,90})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-90,12})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBorIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-30,90})));
  UnitTests.Confidential.FlowControlled_m_flow pumGsHpCon(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=GsHp.m2_flow_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=GsHp.dp_nominalCon) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,-38})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_gshp_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-30,-8})));
  UnitTests.Confidential.HeatPump_WaterWater GsHp(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
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
    mod_start=0,
    addDummyEquation=addDummyEquation,
    con(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, from_dp=false),
    eva(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, from_dp=false))
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,2})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpEvaIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-30,12})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTGsHpConOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_gshp_nominal,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-90,-8})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTBorOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={30,90})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooConIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={80,12})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooEvaOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_hex_coo_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={20,-8})));
    IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hexCoo(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_bor_nominal,
    m2_flow_nominal=m_flow_hex_coo_nominal,
    dp1_nominal=5000,
    dp2_nominal=5000)  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,2})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooEvaIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_hex_coo_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={80,-8})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTHexCooConOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_bor_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={20,12})));
    Borefields.TwoUTubes_Cont borefield(
    tLoaAgg=3600,
    nSeg=1,
    borFieDat=borFieDat,
    allowFlowReversal=false,
    redeclare package Medium = Medium,
    z0=0,
    dT_dz=0,
    groTemResDat=groTemResDat)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,90})));

    Modelica.Blocks.Sources.RealExpression exprPelGsHp(y=GsHp.PEl)
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Modelica.Blocks.Continuous.Integrator EGsHp_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Modelica.Blocks.Sources.RealExpression exprPelPumCoo(y=pumHexCooEva.P)
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Modelica.Blocks.Continuous.Integrator EpumCoo_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  IDEAS.Fluid.FixedResistances.Junction junSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={pumGsHpCon.m_flow_nominal + pumHexCooEva.m_flow_nominal,
        pumGsHpCon.m_flow_nominal,pumHexCooEva.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={60,-70})));
  IDEAS.Fluid.FixedResistances.Junction junRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={pumGsHpCon.m_flow_nominal + pumHexCooEva.m_flow_nominal,
        pumHexCooEva.m_flow_nominal,pumGsHpCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-60,-76})));


  UnitTests.Components.FlowControlled_dp pumHexCooCon(
    redeclare package Medium = Medium,
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
        origin={68,36})));
  IDEAS.Fluid.FixedResistances.Junction junHexCooSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={50,60})));

  IDEAS.Fluid.FixedResistances.Junction junHexCooRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={30,60})));

  IDEAS.Fluid.FixedResistances.Junction junRegSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,m_flow_bor_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={0,60})));
  IDEAS.Fluid.FixedResistances.Junction junRegRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,m_flow_bor_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-20,60})));
  IDEAS.Fluid.FixedResistances.Junction junGsHpRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-68,60})));

  IDEAS.Fluid.FixedResistances.Junction junGsHpSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    m_flow_nominal={m_flow_bor_nominal,m_flow_bor_nominal,pumHexCooCon.m_flow_nominal},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-48,60})));

  UnitTests.Components.FlowControlled_dp pumGsHpEva(
    redeclare package Medium = Medium,
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
        origin={-28,36})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-102,98},{-82,118}})));
  IDEAS.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=m_flow_bor_nominal,
    dp_nominal=100000) if not hasReg
    annotation (Placement(transformation(extent={{-14,44},{-6,56}})));

      Modelica.Units.SI.HeatFlowRate QBorefield;
equation
  QBorefield = borefield.port_a.m_flow*(inStream(borefield.port_a.h_outflow) - borefield.port_b.h_outflow);
  connect(borefield.port_b, senTBorOut.port_a)
    annotation (Line(points={{10,90},{24,90}}, color={0,127,255}));
  connect(exprPelGsHp.y,EGsHp_kWh. u)
    annotation (Line(points={{131,90},{138,90}},     color={0,0,127}));
  connect(exprPelPumCoo.y,EpumCoo_kWh. u)
    annotation (Line(points={{131,60},{138,60}},       color={0,0,127}));
  connect(port_a, junSup.port_1)
    annotation (Line(points={{60,-100},{60,-80}}, color={0,127,255}));
  connect(junRet.port_1, port_b)
    annotation (Line(points={{-60,-86},{-60,-100}}, color={0,127,255}));
  connect(pumBor.port_b, senTBorIn.port_a)
    annotation (Line(points={{-50,90},{-36,90}}, color={0,127,255}));
  connect(senTBorIn.port_b, borefield.port_a)
    annotation (Line(points={{-24,90},{-10,90}}, color={0,127,255}));
  connect(senTHexCooConIn.port_b, hexCoo.port_a1)
    annotation (Line(points={{74,12},{60,12},{60,8}},  color={0,127,255}));
  connect(hexCoo.port_b1, senTHexCooConOut.port_a)
    annotation (Line(points={{40,8},{40,12},{26,12}},  color={0,127,255}));
  connect(senTGsHpEvaIn.port_b, GsHp.port_a1)
    annotation (Line(points={{-36,12},{-50,12},{-50,8}},  color={0,127,255}));
  connect(GsHp.port_b1, senTGsHpEvaOut.port_a) annotation (Line(points={{-70,8},
          {-76,8},{-76,12},{-84,12}},  color={0,127,255}));
  connect(GsHp.port_a2, senTGsHpConOut.port_b) annotation (Line(points={{-70,-4},
          {-76,-4},{-76,-8},{-84,-8}}, color={0,127,255}));
  connect(pumGsHpCon.port_b, senTGsHpConOut.port_a) annotation (Line(points={{-70,
          -38},{-100,-38},{-100,-8},{-96,-8}}, color={0,127,255}));
  connect(GsHp.port_b2, senTGsHpConIn.port_a)
    annotation (Line(points={{-50,-4},{-50,-8},{-36,-8}}, color={0,127,255}));
  connect(pumHexCooEva.port_b, senTHexCooEvaOut.port_a) annotation (Line(points={{20,-38},
          {8,-38},{8,-8},{14,-8}},          color={0,127,255}));
  connect(senTHexCooEvaOut.port_b, hexCoo.port_a2)
    annotation (Line(points={{26,-8},{40,-8},{40,-4}}, color={0,127,255}));
  connect(hexCoo.port_b2, senTHexCooEvaIn.port_a)
    annotation (Line(points={{60,-4},{60,-8},{74,-8}}, color={0,127,255}));
  connect(pumHexCooEva.port_a, junSup.port_2)
    annotation (Line(points={{40,-38},{60,-38},{60,-60}}, color={0,127,255}));
  connect(pumGsHpCon.port_a, junSup.port_3) annotation (Line(points={{-50,-38},{
          0,-38},{0,-70},{50,-70}}, color={0,127,255}));
  connect(senTGsHpConIn.port_b, junRet.port_3) annotation (Line(points={{-24,-8},
          {-20,-8},{-20,-76},{-50,-76}}, color={0,127,255}));
  connect(junRet.port_2, senTHexCooEvaIn.port_b) annotation (Line(points={{-60,-66},
          {-60,-56},{86,-56},{86,-8}}, color={0,127,255}));
  connect(GsHp.PEl, P) annotation (Line(points={{-71,2},{-114,2},{-114,90},{-110,
          90}}, color={0,0,127}));
  connect(pumHexCooCon.port_b, senTHexCooConIn.port_a) annotation (Line(points={
          {78,36},{92,36},{92,12},{86,12}}, color={0,127,255}));
  connect(junHexCooSup.port_3, pumHexCooCon.port_a)
    annotation (Line(points={{50,54},{50,36},{58,36}}, color={0,127,255}));
  connect(senTHexCooConOut.port_b, junHexCooRet.port_3) annotation (Line(points=
         {{14,12},{8,12},{8,30},{30,30},{30,54}}, color={0,127,255}));
  connect(junHexCooSup.port_2, junHexCooRet.port_1)
    annotation (Line(points={{44,60},{36,60}}, color={0,127,255}));
  connect(junRegSup.port_2, junRegRet.port_1)
    annotation (Line(points={{-6,60},{-14,60}}, color={0,127,255}));
  connect(junRegSup.port_1, junHexCooRet.port_2)
    annotation (Line(points={{6,60},{24,60}}, color={0,127,255}));
  connect(junRegRet.port_2, junGsHpSup.port_1)
    annotation (Line(points={{-26,60},{-42,60}}, color={0,127,255}));
  connect(pumGsHpEva.port_b, senTGsHpEvaIn.port_a) annotation (Line(points={{-18,
          36},{-14,36},{-14,12},{-24,12}}, color={0,127,255}));
  connect(senTGsHpEvaOut.port_b, junGsHpRet.port_3) annotation (Line(points={{-96,
          12},{-96,36},{-68,36},{-68,54}}, color={0,127,255}));
  connect(junGsHpSup.port_3, pumGsHpEva.port_a)
    annotation (Line(points={{-48,54},{-48,36},{-38,36}}, color={0,127,255}));
  connect(junGsHpRet.port_1, junGsHpSup.port_2)
    annotation (Line(points={{-62,60},{-54,60}}, color={0,127,255}));
  connect(junGsHpRet.port_2, pumBor.port_a) annotation (Line(points={{-74,60},{-80,
          60},{-80,90},{-70,90}}, color={0,127,255}));
  if hasReg then
    connect(junRegSup.port_3, port_bReg)
      annotation (Line(points={{0,54},{0,50},{100,50}}, color={0,127,255}));
    connect(junRegRet.port_3, port_aReg)
      annotation (Line(points={{-20,54},{-20,50},{-100,50}}, color={0,127,255}));
  else
    connect(res.port_b, junRegSup.port_3)
      annotation (Line(points={{-6,50},{0,50},{0,54}}, color={0,127,255}));
    connect(res.port_a, junRegRet.port_3)
      annotation (Line(points={{-14,50},{-20,50},{-20,54}}, color={0,127,255}));
  end if;

  connect(senTBorOut.port_b, junHexCooSup.port_1) annotation (Line(points={{36,90},
          {74,90},{74,60},{56,60}}, color={0,127,255}));
  connect(bou.ports[1], pumBor.port_a) annotation (Line(points={{-82,108},{-76,108},
          {-76,110},{-74,110},{-74,90},{-70,90}}, color={0,127,255}));

  annotation (defaultComponentName="GsHp", Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-74,35},{74,-35}},
          textColor={238,46,47},
          textString="GSHP"), Text(
          extent={{-152,100},{148,140}},
          textColor={0,0,0},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GsHp;
