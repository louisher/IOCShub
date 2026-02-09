within IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem.BaseClasses;
partial model HeatingSystemSh
  "Partial optimisation model of the building space heating system"
  import Buildings;
  extends
    DeSchipjes.Simulation.HeatDemand.HeatingSystem.BaseClasses.PartialHeatingSystem;

  parameter Boolean addDummyEquation=false
    "=true, to balance equations in dymola";

  DistrictHeating.HeatDemand.SpaceHeating.EmbeddedPipeUpdated
                                                       floorHeating(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nom_sh_fh,
    computeFlowResistance=false,
    from_dp=true,
    A_floor=22,
    redeclare DeSchipjes.Components.Data.FH_DeSchipjes
                                            RadSlaCha)
    annotation (Placement(transformation(extent={{-130,40},{-150,60}})));
  IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2
                                       rad(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nEle=1,
    fraRad=0.1,
    Q_flow_nominal=770,
    T_a_nominal=303.15,
    T_b_nominal=rad.T_a_nominal - rad.Q_flow_nominal/4184/0.073,
    TAir_nominal=295.15,
    n=1.31,
    VWat=5.8E-6*abs(3103),
    mDry=0.0263*abs(3103),
    from_dp=true)
    annotation (Placement(transformation(extent={{-130,-40},{-150,-20}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU
                                      hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=0.2153,
    m2_flow_nominal=0.2154,
    from_dp1=true,
    dp1_nominal=0,
    from_dp2=true,
    dp2_nominal=0,
    configuration=IDEAS.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=9000,
    T_a1_nominal=323.15,
    T_a2_nominal=308.15)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-40})));
  IDEAS.Fluid.Sources.Boundary_pT bouSec(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-10})));

  IDEAS.Fluid.Actuators.Valves.TwoWayLinear valveFh(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_sh_fh,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=kvsValveFh,
    dpFixed_nominal=dp_nom_sec - (valveFh.m_flow_nominal*3.6/valveFh.Kv)^2*10^5)
    annotation (Placement(transformation(extent={{-90,40},{-110,60}})));
  IDEAS.Fluid.Actuators.Valves.TwoWayLinear valvePrimSup(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_prim,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=kvsValvePrimSup,
    dpFixed_nominal=dp_nom_prim - (valvePrimSup.m_flow_nominal*3.6/valvePrimSup.Kv)
        ^2*10^5)
    annotation (Placement(transformation(extent={{110,-40},{90,-20}})));
  IDEAS.Fluid.Movers.FlowControlled_dp         pumpSec(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nom_sec,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nom_sec)
    annotation (Placement(transformation(extent={{-20,-60},{0,-80}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSecSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_sec,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{35,-35},{25,-25}})));
  IDEAS.Fluid.Actuators.Valves.TwoWayLinear        valveRad(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_sh_rad,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=kvsValveRad,
    dpFixed_nominal=dp_nom_sec - (valveRad.m_flow_nominal*3.6/valveRad.Kv)^2*10
        ^5)
    annotation (Placement(transformation(extent={{-90,-40},{-110,-20}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TFhIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_sh_fh,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-115,45},{-125,55}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSecRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_sec,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{25,-75},{35,-65}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TPrimSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_prim,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=270,
        origin={120,-70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TPrimRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_prim,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={160,-70})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TFhOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_sh_fh,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-155,45},{-165,55}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TRadOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_sh_rad,
    tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-155,-35},{-165,-25}})));
equation

  connect(valvePrimSup.port_b, hex.port_a1)
    annotation (Line(points={{90,-30},{76,-30}},  color={0,127,255}));
  connect(TSecSup.port_a, hex.port_b2)
    annotation (Line(points={{35,-30},{64,-30}}, color={0,127,255}));
  connect(bouSec.ports[1], hex.port_b2)
    annotation (Line(points={{60,-20},{60,-30},{64,-30}}, color={0,127,255}));
  connect(rad.port_a, valveRad.port_b)
    annotation (Line(points={{-130,-30},{-110,-30}}, color={0,127,255}));
  connect(valveRad.port_a, TSecSup.port_b)
    annotation (Line(points={{-90,-30},{25,-30}}, color={0,127,255}));
  connect(valveFh.port_a, TSecSup.port_b) annotation (Line(points={{-90,50},{-80,
          50},{-80,-30},{25,-30}}, color={0,127,255}));
  connect(valveFh.port_b, TFhIn.port_a)
    annotation (Line(points={{-110,50},{-115,50}}, color={0,127,255}));
  connect(floorHeating.port_a, TFhIn.port_b)
    annotation (Line(points={{-130,50},{-125,50}}, color={0,127,255}));
  connect(pumpSec.port_b, TSecRet.port_a)
    annotation (Line(points={{0,-70},{25,-70}}, color={0,127,255}));
  connect(TSecRet.port_b, hex.port_a2)
    annotation (Line(points={{35,-70},{64,-70},{64,-50}}, color={0,127,255}));
  connect(rad.heatPortCon, heatPortCon[1]) annotation (Line(points={{-138,-22.8},
          {-138,20},{-200,20}}, color={191,0,0}));
  connect(rad.heatPortRad, heatPortRad[1]) annotation (Line(points={{-142,-22.8},
          {-142,-20},{-200,-20}}, color={191,0,0}));
  connect(valvePrimSup.port_a, TPrimSup.port_b) annotation (Line(points={{110,
          -30},{120,-30},{120,-64}}, color={0,127,255}));
  connect(TPrimSup.port_a, port_a)
    annotation (Line(points={{120,-76},{120,-100}}, color={0,127,255}));
  connect(hex.port_b1, TPrimRet.port_a) annotation (Line(points={{76,-50},{160,
          -50},{160,-64}}, color={0,127,255}));
  connect(TPrimRet.port_b, port_b)
    annotation (Line(points={{160,-76},{160,-100}}, color={0,127,255}));
  connect(TFhOut.port_a, floorHeating.port_b)
    annotation (Line(points={{-155,50},{-150,50}}, color={0,127,255}));
  connect(TRadOut.port_a, rad.port_b)
    annotation (Line(points={{-155,-30},{-150,-30}}, color={0,127,255}));
  connect(TFhOut.port_b, pumpSec.port_a) annotation (Line(points={{-165,50},{
          -170,50},{-170,-70},{-20,-70}}, color={0,127,255}));
  connect(TRadOut.port_b, pumpSec.port_a) annotation (Line(points={{-165,-30},{
          -170,-30},{-170,-70},{-20,-70}}, color={0,127,255}));
  connect(floorHeating.heatPortEmb, heatPortEmb)
    annotation (Line(points={{-140,60},{-200,60}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}})), Icon(coordinateSystem(extent={{-200,-100},
            {200,100}})),
    experiment(
      StopTime=36000,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end HeatingSystemSh;
