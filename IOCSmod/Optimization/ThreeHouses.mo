within IOCSmod.Optimization;
model ThreeHouses
  extends IOCSmod.Optimization.Interface;
  Blocks.Demand.Clusters.ThreeHouses buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
                                                                     output Real QPvtHex = enerHub.pvt.hex.Q2_flow;
  Blocks.EnergyHub.GeneralHub enerHub(
    addDummyEquation=addDummyEquation,
    borFieDat(conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBor_flow_nominal=enerHub.GsHp.borFieDat.conDat.mBorFie_flow_nominal/
            enerHub.GsHp.borFieDat.conDat.nBor,
        dp_nominal(displayUnit="Pa"),
        hBor=60.1,
        nBor=12,
        cooBor=[0,0; 0,6; 0,12; 0,18; 6,0; 6,6; 6,12; 6,18; 12,0; 12,6; 12,12;
            12,18])),
    optSel_STC=false,
    selDefault_STC=0,
    m_flow_stc_nominal=enerHub.per_STC.mperA_flow_nominal*enerHub.TotArea_STC,
    dp_stc_nominal(displayUnit="Pa") = enerHub.per_STC.dp_nominal,
    redeclare
      IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.FP_ViessmannVitosol200FMSH2F
      per_STC,
    nSeg_STC=3,
    azi_STC=0,
    til_STC=0.78539816339745,
    rho_STC=0.2,
    sysConfig_STC=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    dT_nominal_STC=-10,
    dTMax_STC=30,
    TotArea_PVT=0.01,
    optSel_PVT=false,
    selDefault_PVT=0,
    m_flow_pvt_nominal=enerHub.per_PVT.mperA_flow_nominal*enerHub.TotArea_PVT,
    dp_pvt_nominal=enerHub.per_PVT.dp_nominal,
    azi_PVT=0,
    til_PVT=0.78539816339745,
    rho_PVT=0.2,
    sysConfig_PVT=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    dT_nominal_PVT=-10,
    dTMax_PVT=30,
    redeclare
      IOCSmod.ComponentModels.Thermal.SolarCollectors.Data.PVT_DualSun_Spring425_ShingleBlack
      per_PVT,
    P_STC_PVT=425,
    gamma_PVT=-0.0034,
    module_efficiency_PVT=0.204)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,18})));


equation
  connect(enerHub.port_a, buildings.port_a) annotation (Line(points={{-24,0},{-24,
          -20},{56,-20},{56,0}}, color={0,127,255}));
  connect(buildings.port_b, enerHub.port_b) annotation (Line(points={{44,0},{44,
          -40},{-36,-40},{-36,0}}, color={0,127,255}));
  connect(bou.ports[1], enerHub.port_a) annotation (Line(points={{8,8},{8,-14},{
          -24,-14},{-24,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThreeHouses;
