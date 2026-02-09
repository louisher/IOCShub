within IOCSmod.Blocks.EnergyHub;
model Test_ASHP_Opt
  extends BaseClasses.EnergyHubInterface;

  /* GSHP parameters */
  parameter Modelica.Units.SI.Temperature TBorMin=3+273.15
    "Minimum allowable borefield temperature (to be used in objective)" annotation(Dialog(tab="GSHP", group="Borefield"));

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
        mBorFie_flow_nominal=GsHp.m_flow_bor_nominal,
        dp_nominal(displayUnit="Pa") = 1,
        hBor=100,
        cooBor=[0,0; 0,3; 3,0; 3,3],
        mBor_flow_nominal=GsHp.borFieDat.conDat.mBorFie_flow_nominal/
            GsHp.borFieDat.conDat.nBor,
        nBor=4,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043)) "Borefield data" annotation(Dialog(tab="GSHP", group="Borefield"));
  parameter ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.GroundResponseDataTemplate groTemResDat "Ground response parameters" annotation(Dialog(tab="GSHP", group="Borefield"));

  parameter Modelica.Units.SI.TemperatureDifference dT_max=5 "Maximum temperature difference across condenser" annotation(Dialog(tab="GSHP", group="Heat pump"));
  parameter Real copDef_gshp=5.00625 "Default COP" annotation(Dialog(tab="GSHP", group="Heat pump"));
  parameter Real coeffEva_gshp[2]={-280.15, 0.1103557} annotation(Dialog(tab="GSHP", group="Heat pump"));
  parameter Real coeffCon_gshp[2]={-313.15,-0.1037086} annotation(Dialog(tab="GSHP", group="Heat pump"));

  /* ASHP parameters */
  parameter Real copDef_ashp=4.055 "Default COP"  annotation(Dialog(tab="ASHP"));
  parameter Real coeffEva_ashp=0.1095853 "Linearisation coefficient of air temperature in COP calculation"  annotation(Dialog(tab="ASHP"));
  parameter Real coeffCon_ashp=-0.0895519 "Linearisation coefficient of leaving condensor temperature in COP calculation"  annotation(Dialog(tab="ASHP"));
  parameter Modelica.Units.SI.Temperature TAir_nominal=280.15 "Nominal air temperature for COP calculation" annotation(Dialog(tab="ASHP"));
  parameter Modelica.Units.SI.Temperature TConOut_nominal=313.15 "Nominal condensor leaving temperature for COP calculation" annotation(Dialog(tab="ASHP"));

  /* Tank parameters */
  parameter Modelica.Units.SI.MassFlowRate m_flow_tank_nominal=AsHp.m_flow_ashp_nominal + GsHp.m_flow_gshp_nominal "Nominal mass flow rate" annotation(Dialog(tab="Tank"));

  /* PV parameters */
  parameter Modelica.Units.SI.Irradiance G_STC_PV=1000 "Irradiance at Standard Conditions (usualy 1000 W/m2)" annotation (Dialog(tab="PV", group="Characteristics of the photovoltaic panel"));
  parameter Modelica.Units.SI.Power P_STC_PV=370 "Power of one photovoltaic panel at Standard Conditions, usualy equal to power at Maximum Power Point (MPP)" annotation (Dialog(tab="PV", group="Characteristics of the photovoltaic panel"));
  parameter Modelica.Units.SI.Area Apanel_PV=1.93 "Area of the single panel" annotation (Dialog(tab="PV", group="Characteristics of the photovoltaic panel"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient gamma_PV=-0.0037 "Temperature coefficient of the photovoltaic panel(s)" annotation (Dialog(tab="PV", group="Characteristics of the photovoltaic panel"));
  parameter Modelica.Units.SI.Efficiency P_loss_factor_PV=0.14 "Loss factor of the photovoltaic panel(s)" annotation (Dialog(tab="PV",group="Characteristics of the photovoltaic panel"));
  parameter Modelica.Units.SI.Efficiency module_efficiency_PV=0.3 "Module efficiency of the photovoltaic installation" annotation (Dialog(tab="PV", group="Characteristics of the photovoltaic panel"));
  parameter Modelica.Units.SI.Angle til_PV=0.785 "Surface tilt of the photovoltaic installation (0°=horizontal, 90°=vertical)" annotation (Dialog(tab="PV", group="Characteristics of the photovoltaic installation"));
  parameter Modelica.Units.SI.Angle azi_PV=0 "Surface azimuth (0°=south, 90°=west, 180°=north, 270°=east)" annotation (Dialog(tab="PV", group="Characteristics of the photovoltaic installation"));
  parameter Modelica.Units.SI.Efficiency eta_nom_inverter_PV=0.96 "Nominal inverter efficiency" annotation (Dialog(tab="PV", group="Characteristics of the PV DC-AC inverter"));
  parameter Modelica.Units.SI.Power P_ac0_PV=0.7*pv.n*pv.P_STC "Inverter rated AC power" annotation (Dialog(tab="PV", group="Characteristics of the PV DC-AC inverter"));

  /* Battery parameters */
  parameter Boolean hasBat=false "Set to true if the energy hub has a battery before the power connection"
    annotation (Evaluate=true, Dialog(tab="Battery"));
  parameter Real P_max_bat_kW=5 "Maximal charging/discharging power of battery in kW" annotation(Dialog(tab="Battery", group="Battery settings", enable=hasBat));
  parameter Modelica.Units.SI.Efficiency effCha=0.85 "Charging efficiency (between 0 and 1)" annotation(Dialog(tab="Battery", group="Battery settings", enable=hasBat));
  parameter Modelica.Units.SI.Efficiency effDisCha=0.85 "Discharging efficiency (between 0 and 1)" annotation(Dialog(tab="Battery", group="Battery settings", enable=hasBat));
  parameter Real SoC_min=0.1 "Minimal state of charge (between 0 and 1)" annotation(Dialog(tab="Battery", group="Optimisation settings", enable=hasBat));
  parameter Real SoC_max=0.9 "Maximal state of charge (between 0 and 1)" annotation(Dialog(tab="Battery", group="Optimisation settings", enable=hasBat));

  /* STC parameters */
  parameter Modelica.Units.SI.Area TotArea_STC=0.01 "Total area of panels in the simulation" annotation (Dialog(tab="STC", group="General"));
  parameter Boolean hasReg_STC=true "Boolean to remove regeneration ports" annotation (Dialog(tab="STC", group="General"));
  parameter Boolean hasHea_STC=true "Boolean to remove direct heating ports" annotation (Dialog(tab="STC", group="General"));
  parameter Boolean optSel_STC=false "Boolean to select wheter or not the choice between regeneration and heating has to be optimized" annotation (Dialog(tab="STC", group="General"));
  parameter Real selDefault_STC=0 "Default mode of STC connection: 1=regeneration, 0=direct heating" annotation (Dialog(tab="STC", group="General"));
  parameter Modelica.Units.SI.PressureDifference dp_ValStc_nominal=1000 "Nominal pressure drop of fully open valves in stc block" annotation (Dialog(tab="STC", group="General"));
  replaceable parameter IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F per_STC
    constrainedby Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic
    "Performance data" annotation (
    Dialog(tab="STC", group="Panel"),
    Placement(transformation(extent={{110,82},{130,102}})),
    choicesAllMatching=true);
  parameter Integer nSeg_STC=3 "Number of segments used to discretize the collector model" annotation (Dialog(tab="STC", group="Panel"));
  parameter Modelica.Units.SI.Angle azi_STC=0 "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing" annotation (Dialog(tab="STC", group="Panel"));
  parameter Modelica.Units.SI.Angle til_STC=2*Modelica.Constants.pi*(45/360) "Surface tilt (0 for horizontally mounted collector)" annotation (Dialog(tab="STC", group="Panel"));
  parameter Real rho_STC=0.2 "Ground reflectance" annotation (Dialog(tab="STC", group="Panel"));
  parameter Buildings.Fluid.SolarCollectors.Types.SystemConfiguration sysConfig_STC=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series "Selection of system configuration" annotation (Dialog(tab="STC", group="Panel"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal_STC=-10 "Ambient temperature minus fluid temperature at nominal conditions" annotation (Dialog(tab="STC", group="Panel"));
  parameter Modelica.Units.SI.TemperatureDifference dTMax_STC=20 "Maximum temperature difference across solar collector" annotation (Dialog(tab="STC", group="Panel"));

  /* PVT parameters */
  parameter Modelica.Units.SI.Area TotArea_PVT=0.01 "Total area of panels in the simulation" annotation (Dialog(tab="PVT", group="General"));
  parameter Boolean optSel_PVT=false "Boolean to select wheter or not the choice between regeneration and heating has to be optimized" annotation (Dialog(tab="PVT", group="General"));
  parameter Boolean hasReg_PVT=true "Boolean to remove regeneration ports" annotation (Dialog(tab="PVT", group="General"));
  parameter Boolean hasHea_PVT=true "Boolean to remove direct heating ports" annotation (Dialog(tab="PVT", group="General"));
  parameter Real selDefault_PVT=1 "Default mode of PVT connection: 1=regeneration, 0=direct heating" annotation (Dialog(tab="PVT", group="General"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_pvt_nominal=per_PVT.mperA_flow_nominal*TotArea_PVT "Nominal mass flow rate in stc panels" annotation (Dialog(tab="PVT", group="General"));
  parameter Modelica.Units.SI.PressureDifference dp_pvt_nominal=per_PVT.dp_nominal "Nominal pressure raise of stc pump" annotation (Dialog(tab="PVT", group="General"));
  parameter Modelica.Units.SI.PressureDifference dp_ValPvt_nominal=1000 "Nominal pressure drop of fully open valves in stc block" annotation (Dialog(tab="PVT", group="General"));

  parameter Integer nSeg_PVT=3 "Number of segments used to discretize the collector model" annotation (Dialog(tab="PVT", group="General"));
  parameter Modelica.Units.SI.Angle azi_PVT=0 "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing" annotation (Dialog(tab="PVT", group="General"));
  parameter Modelica.Units.SI.Angle til_PVT=2*Modelica.Constants.pi*(45/360) "Surface tilt (0 for horizontally mounted collector)" annotation (Dialog(tab="PVT", group="General"));
  parameter Real rho_PVT=0.2 "Ground reflectance" annotation (Dialog(tab="PVT", group="General"));
  parameter Buildings.Fluid.SolarCollectors.Types.SystemConfiguration sysConfig_PVT=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series "Selection of system configuration" annotation (Dialog(tab="PVT"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal_PVT=-10 "Ambient temperature minus fluid temperature at nominal conditions" annotation (Dialog(tab="PVT", group="Thermal"));
  parameter Modelica.Units.SI.TemperatureDifference dTMax_PVT=20 "Maximum temperature difference across solar collector" annotation (Dialog(tab="PVT", group="Thermal"));
  replaceable parameter IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.PVT_DualSun_Spring425_ShingleBlack per_PVT constrainedby
    Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic                                                                                               "Performance data"
    annotation (Dialog(tab="PVT", group="Thermal"), Placement(transformation(extent={{110,82},{130,102}})), choicesAllMatching=true);
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer U_pvt=35 "Heat coefficient used in cell temperature calculation" annotation (Dialog(tab="PVT", group="General"));

  parameter Modelica.Units.SI.Irradiance G_STC_PVT=1000 "Irradiance at Standard Conditions (usualy 1000 W/m2)" annotation (Dialog(tab="PVT", group="Electrical"));
  parameter Modelica.Units.SI.Power P_STC_PVT=370 "Power of one pPVT panel at Standard Conditions, usualy equal to power at Maximum Power Point (MPP)" annotation (Dialog(tab="PVT", group="Electrical"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient gamma_PVT=-0.0037 "Temperature coefficient of the photovoltaic panel(s)" annotation (Dialog(tab="PVT", group="Electrical"));
  parameter Modelica.Units.SI.Efficiency P_loss_factor_PVT=0.14 "Loss factor of the photovoltaic panel(s)" annotation (Dialog(tab="PVT", group="Electrical"));
  parameter Modelica.Units.SI.Efficiency module_efficiency_PVT=0.3 "Module efficiency of the photovoltaic installation" annotation (Dialog(tab="PVT", group="Electrical"));
  parameter Modelica.Units.SI.Efficiency eta_nom_inverter_PVT=0.96 "Nominal inverter efficiency" annotation (Dialog(tab="PVT", group="Electrical"));
  parameter Modelica.Units.SI.Power P_ac0_PVT=0.7*(pvt.panels.ATot_internal/pvt.panels.per.A)*pvt.panels.P_STC "Inverter rated AC power" annotation (Dialog(tab="PVT", group="Electrical"));


  ComponentModels.Thermal.SizeOpt.GsHpOpt GsHp(
    addDummyEquation=addDummyEquation,
    redeclare replaceable package Medium = Medium,
    hasReg=true,
    TBorMin=TBorMin,
    borFieDat=borFieDat,
    groTemResDat=groTemResDat,
    dT_max=dT_max,
    copDef=copDef_gshp,
    coeffEva=coeffEva_gshp,
    coeffCon=coeffCon_gshp)
    annotation (Placement(transformation(extent={{-40,20},{-60,40}})));
  ComponentModels.Thermal.SizeOpt.AsHpOpt
                               AsHp(addDummyEquation=addDummyEquation, redeclare
      replaceable package Medium =                                                                          Medium,
    copDef=copDef_ashp,
    TAir_nominal=TAir_nominal,
    TConOut_nominal=TConOut_nominal,
    coeffEva=coeffEva_ashp,
    coeffCon=coeffCon_ashp)
    annotation (Placement(transformation(extent={{-40,-20},{-60,0}})));
  ComponentModels.Thermal.SizeOpt.SimpleTankOpt
                                     tan(addDummyEquation=addDummyEquation,
    m_flow_nominal=m_flow_tank_nominal,
      nPorts=10,redeclare replaceable package Medium=Medium) annotation (Placement(transformation(extent={{22,0},{42,20}})));



  Modelica.Blocks.Math.Sum Pnet(nin=4)
    annotation (Placement(visible = true, transformation(origin={-50,90},     extent={{10,-10},
            {-10,10}},                                                                                         rotation=0)));
   Modelica.Units.SI.HeatFlowRate QEnergyHub;

  ComponentModels.Electrical.SizeOpt.LinearBatteryOpt
                                           bat(
    P_max=P_max_bat,
    effCha=effCha,
    effDisCha=effDisCha,
    u_min=u_min,
    u_max=u_max,
    SoC_min=SoC_min,
    SoC_max=SoC_max)
    "Positive Pdem equals input and negative is demand, so heat pump powers should be negative and PV input should be positive"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,90})));

  ComponentModels.Electrical.SizeOpt.PVPanelDC_AreaOpt pv(
    G_STC=G_STC_PV,
    P_STC=P_STC_PV,
    Apanel=Apanel_PV,
    gamma=gamma_PV,
    P_loss_factor=P_loss_factor_PV,
    module_efficiency=module_efficiency_PV,
    til=til_PV,
    azi=azi_PV,
    eta_nom_inverter=eta_nom_inverter_PV,
    P_ac0=P_ac0_PV)
    annotation (Placement(transformation(extent={{2,78},{22,98}})));

  ComponentModels.Thermal.SizeOpt.StcOpt
                              stc(
    addDummyEquation=addDummyEquation,
    redeclare package Medium = Medium,
    optSel=optSel_STC,
    hasReg=hasReg_STC,
    hasHea=hasHea_STC,
    selDefault=selDefault_STC,
    dp_Val_nominal(displayUnit="Pa") = dp_ValStc_nominal,
    nSeg=nSeg_STC,
    azi=azi_STC,
    til=til_STC,
    rho=rho_STC,
    totalArea=TotArea_STC,
    sysConfig=sysConfig_STC,
    dT_nominal=dT_nominal_STC,
    dTMax=dTMax_STC,
    per=per_STC)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,66})));


  ComponentModels.Thermal.Pvt pvt(
    addDummyEquation=addDummyEquation,
    redeclare package Medium = Medium,
    optSel=optSel_PVT,
    hasReg=hasReg_PVT,
    hasHea=hasHea_PVT,
    selDefault=selDefault_PVT,
    dp_Val_nominal=dp_ValPvt_nominal,
    nSeg=nSeg_PVT,
    azi=azi_PVT,
    til=til_PVT,
    rho=rho_PVT,
    totalArea=TotArea_PVT,
    sysConfig=sysConfig_PVT,
    dT_nominal=dT_nominal_PVT,
    dTMax=dTMax_PVT,
    per=per_PVT,
    G_STC=G_STC_PVT,
    P_STC=P_STC_PVT,
    gamma=gamma_PVT,
    P_loss_factor=P_loss_factor_PVT,
    module_efficiency=module_efficiency_PVT,
    eta_nom_inverter=eta_nom_inverter_PVT,
    P_ac0=P_ac0_PVT,
    U_pvt=U_pvt)
    annotation (Placement(transformation(extent={{-8,32},{-28,52}})));

protected
  parameter Modelica.Units.SI.Power P_max_bat=P_max_bat_kW*1000 "Maximal charging/discharging power of battery" annotation(Dialog(tab="Battery", group="Battery settings", enable=hasBat));
  parameter Real u_min=if hasBat then -1 else 0 "Discharging" annotation(Dialog(tab="Battery", group="Optimisation settings", enable=hasBat));
  parameter Real u_max=if hasBat then 1 else 0 "Charging" annotation(Dialog(tab="Battery", group="Optimisation settings", enable=hasBat));

equation
  QEnergyHub = port_a.m_flow*(inStream(port_a.h_outflow) - port_b.h_outflow);
  connect(GsHp.port_a, tan.ports[1]) annotation (Line(points={{-56,20},{-56,8},{
          8,8},{8,-6},{28.4,-6},{28.4,0}},
                                       color={0,127,255}));
  connect(tan.ports[2], GsHp.port_b) annotation (Line(points={{29.2,0},{29.2,-6},
          {8,-6},{8,8},{-44,8},{-44,20}},
                                       color={0,127,255}));
  connect(AsHp.port_a, tan.ports[3]) annotation (Line(points={{-56,-20},{-56,-32},
          {30,-32},{30,0}}, color={0,127,255}));
  connect(AsHp.port_b, tan.ports[4]) annotation (Line(points={{-44,-20},{-44,-32},
          {30.8,-32},{30.8,0}},
                            color={0,127,255}));
  connect(tan.ports[5], port_a) annotation (Line(points={{31.6,0},{31.6,-60},{60,
          -60},{60,-100}},
                      color={0,127,255}));
  connect(tan.ports[6], port_b) annotation (Line(points={{32.4,0},{28,0},{28,-60},
          {-60,-60},{-60,-100}},      color={0,127,255}));
  connect(Pnet.y, bat.PDem)
    annotation (Line(points={{-61,90},{-68,90}}, color={0,0,127}));
  connect(bat.PGrid, P)
    annotation (Line(points={{-90,90},{-110,90}}, color={0,0,127}));
  connect(GsHp.P, Pnet.u[1]) annotation (Line(points={{-61,24.6},{-80,24.6},{-80,
          76},{-32,76},{-32,88.5},{-38,88.5}},       color={0,0,127}));
  connect(AsHp.P, Pnet.u[2]) annotation (Line(points={{-61,-15.4},{-80,-15.4},{-80,
          76},{-32,76},{-32,89.5},{-38,89.5}},
                                           color={0,0,127}));
  connect(pv.P, Pnet.u[3]) annotation (Line(points={{1,88},{1,90.5},{-38,90.5}},
        color={0,0,127}));
  connect(stc.port_aReg, GsHp.port_bReg) annotation (Line(points={{1.77636e-15,66},
          {-64,66},{-64,35},{-60,35}}, color={0,127,255}));
  connect(GsHp.port_aReg, stc.port_bReg) annotation (Line(points={{-40,35},{-36,
          35},{-36,58},{0,58}}, color={0,127,255}));
  connect(stc.port_b, tan.ports[7]) annotation (Line(points={{16,56},{16,-6},{28,
          -6},{28,0},{33.2,0}}, color={0,127,255}));
  connect(stc.port_a, tan.ports[8]) annotation (Line(points={{4,56},{4,8},{8,8},
          {8,-6},{28,-6},{28,0},{34,0}},   color={0,127,255}));
  connect(pvt.port_aReg, GsHp.port_bReg) annotation (Line(points={{-28,42},{-32,
          42},{-32,54},{-64,54},{-64,35},{-60,35}}, color={0,127,255}));
  connect(pvt.port_bReg, GsHp.port_aReg)
    annotation (Line(points={{-28,34},{-40,34},{-40,35}}, color={0,127,255}));
  connect(pvt.P, Pnet.u[4]) annotation (Line(points={{-29,36.6},{-32,36.6},{-32,
          12},{-80,12},{-80,76},{-32,76},{-32,91.5},{-38,91.5}}, color={0,0,127}));
  connect(pvt.port_b, tan.ports[9]) annotation (Line(points={{-12,32},{-12,-14},
          {34.8,-14},{34.8,0}}, color={0,127,255}));
  connect(pvt.port_a, tan.ports[10]) annotation (Line(points={{-24,32},{-24,-14},
          {35.6,-14},{35.6,0}}, color={0,127,255}));
                                                                                                                                                   annotation (Dialog(tab="STC", group="Panel"),
              defaultComponentName="enerHub", Icon(graphics={Text(
          extent={{-74,82},{76,-60}},
          textColor={0,140,72},
          textString="EH")}));
end Test_ASHP_Opt;
