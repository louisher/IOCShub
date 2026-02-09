within IOCSmod.Demand.BuildingModels;
model DeSchipjesOneZone
  import DeSchipjes;

  package Medium = IDEAS.Media.Water "Medium in the component";

  parameter Boolean addDummyEquation=true
    "=true, to balance equations in dymola";
  parameter Integer nHouses=12 "Number of houses connected to the thermal network";
  parameter Real scaler=nHouses/12;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_bypass=600/3600*scaler;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_pipe=5.862/3.6*scaler;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_house=0.486/3.6;

  parameter Modelica.Units.SI.ThermalConductivity kIns=0.027;
  outer IDEAS.BoundaryConditions.SimInfoManager sim(
    lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
        //"Uccle_RMI_Predictions.mos",
  DeSchipjes.Optimisation.HeatDemand.Building nr158(building_name="Peterselie6",
    occupantID=20,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-170,60},{-190,80}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr156(building_name="Peterselie5",
    occupantID=19,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-120,60},{-140,80}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr154(building_name="Peterselie4",
    occupantID=17,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-60,60},{-80,80}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr152(building_name="Peterselie3",
    occupantID=16,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{0,60},{-20,80}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr150(building_name="Peterselie2",
    occupantID=15,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{70,110},{50,130}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr136(
    building_name="Peterselie1",
    occupantID=2,
    redeclare
      DeSchipjes.Simulation.HeatDemand.BuildingEnvelope.OneZone.PeterselieReverseHouse
      buildingEnvelope,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr138(
    building_name="Haarakker1",
    occupantID=3,
    redeclare
      DeSchipjes.Simulation.HeatDemand.BuildingEnvelope.OneZone.HaarakkerHouse
      buildingEnvelope,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr140(
    building_name="Haarakker2",
    occupantID=6,
    redeclare
      DeSchipjes.Simulation.HeatDemand.BuildingEnvelope.OneZone.HaarakkerHouse
      buildingEnvelope,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr142(
    building_name="Haarakker3",
    occupantID=7,
    redeclare
      DeSchipjes.Simulation.HeatDemand.BuildingEnvelope.OneZone.HaarakkerHouse
      buildingEnvelope,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr144(
    building_name="Haarakker4",
    occupantID=8,
    redeclare
      DeSchipjes.Simulation.HeatDemand.BuildingEnvelope.OneZone.HaarakkerHouse
      buildingEnvelope,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr146(
    building_name="Haarakker5",
    occupantID=10,
    redeclare
      DeSchipjes.Simulation.HeatDemand.BuildingEnvelope.OneZone.HaarakkerHouse
      buildingEnvelope,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  DeSchipjes.Optimisation.HeatDemand.Building nr148(
    building_name="Haarakker6",
    occupantID=11,
    redeclare
      DeSchipjes.Simulation.HeatDemand.BuildingEnvelope.OneZone.HaarakkerHouse
      buildingEnvelope,
    addDummyEquation=addDummyEquation)
    annotation (Placement(transformation(extent={{120,110},{100,130}})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipeProduction136B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=7,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-130,-50})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe136138B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-50})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe138140B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6.5,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-50})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe140142B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6.5,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-50})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe142144B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6.5,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={110,-50})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe144146B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6.5,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={170,-50})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe146148A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=27.85e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0431,
    length=7,
    m_flow_nominal=m_flow_nom_pipe - 6*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={140,10})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe150152A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=30.80e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0372,
    length=6.5,
    m_flow_nominal=m_flow_nom_pipe - 8*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={20,10})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe152154A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=30.80e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0372,
    length=6,
    m_flow_nominal=m_flow_nom_pipe - 9*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,10})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe154156A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=25.15e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0285,
    length=9.5,
    m_flow_nominal=m_flow_nom_pipe - 10*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-100,10})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe156158(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=34,
    m_flow_nominal=m_flow_nom_pipe - 11*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-160,10})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe146148B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=25.15e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0285,
    length=6.5,
    m_flow_nominal=2*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,40})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe146148C(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=2.5,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={110,90})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe148150A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=3,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,90})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe150152B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6.5,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-10,40})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe152154B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6.5,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,40})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe154156B(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.6e-3,
    tIns=28.55e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0217,
    length=6,
    m_flow_nominal=m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-130,40})));

  Modelica.Blocks.Sources.RealExpression QlossDistr(y=pipeProduction136A.Q_loss +
        pipeProduction136B.Q_loss + pipe136138A.Q_loss + pipe136138B.Q_loss +
        pipe138140A.Q_loss + pipe138140B.Q_loss + pipe140142A.Q_loss +
        pipe140142B.Q_loss + pipe142144A.Q_loss + pipe142144B.Q_loss +
        pipe144146A.Q_loss + pipe144146B.Q_loss + pipe146148A.Q_loss +
        pipe146148B.Q_loss + pipe146148C.Q_loss + pipe148150A.Q_loss +
        pipe150152A.Q_loss + pipe150152B.Q_loss + pipe152154A.Q_loss +
        pipe152154B.Q_loss + pipe154156A.Q_loss + pipe154156B.Q_loss +
        pipe156158.Q_loss)
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipeProduction136A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.9e-3,
    tIns=28.95e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0703,
    length=8,
    m_flow_nominal=m_flow_nom_pipe,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-160,-80})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe136138A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.9e-3,
    tIns=28.95e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0703,
    length=5,
    m_flow_nominal=m_flow_nom_pipe - m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-100,-80})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe138140A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.9e-3,
    tIns=29.35e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0545,
    length=9.5,
    m_flow_nominal=m_flow_nom_pipe - 2*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-40,-80})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe140142A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.9e-3,
    tIns=29.35e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0545,
    length=6,
    m_flow_nominal=m_flow_nom_pipe - 3*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={20,-80})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe142144A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.9e-3,
    tIns=29.35e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0545,
    length=9.5,
    m_flow_nominal=m_flow_nom_pipe - 4*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={80,-80})));
  DistrictHeating.HeatDistribution.Pipes.SinglePipesFV pipe144146A(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    tWall=2.9e-3,
    tIns=29.35e-3,
    kIns=kIns,
    allowFlowReversal=false,
    dh=0.0545,
    length=6,
    m_flow_nominal=m_flow_nom_pipe - 5*m_flow_nom_house,
    from_dp=true,
    nSeg=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={140,-80})));
  IDEAS.Fluid.FixedResistances.Junction junSup136(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe,-(m_flow_nom_house - m_flow_nom_pipe),-
        m_flow_nom_pipe},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-136,-74})));
  IDEAS.Fluid.FixedResistances.Junction junRet136(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - m_flow_nom_house,-m_flow_nom_pipe,
        m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-124,-86})));
  IDEAS.Fluid.FixedResistances.Junction junSup144(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 4*m_flow_nom_house,-(m_flow_nom_pipe - 5*
        m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={104,-74})));
  IDEAS.Fluid.FixedResistances.Junction junSup142(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 3*m_flow_nom_house,-(m_flow_nom_pipe - 4*
        m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={44,-74})));
  IDEAS.Fluid.FixedResistances.Junction junSup140(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 2*m_flow_nom_house,-(m_flow_nom_pipe - 3*
        m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-16,-74})));
  IDEAS.Fluid.FixedResistances.Junction junSup138(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - m_flow_nom_house,-(m_flow_nom_pipe - 2*
        m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-76,-74})));
  IDEAS.Fluid.FixedResistances.Junction junRet138(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 2*m_flow_nom_house,-(m_flow_nom_pipe -
        m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-64,-86})));
  IDEAS.Fluid.FixedResistances.Junction junRet140(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 3*m_flow_nom_house,-(m_flow_nom_pipe - 2*
        m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-4,-86})));
  IDEAS.Fluid.FixedResistances.Junction junRet142(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 4*m_flow_nom_house,-(m_flow_nom_pipe - 3*
        m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={56,-86})));
  IDEAS.Fluid.FixedResistances.Junction junRet144(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 5*m_flow_nom_house,-(m_flow_nom_pipe - 4*
        m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={116,-86})));
  IDEAS.Fluid.FixedResistances.Junction junSup146(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 5*m_flow_nom_house,-(m_flow_nom_pipe - 6*
        m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={164,-74})));
  IDEAS.Fluid.FixedResistances.Junction junRet146(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 6*m_flow_nom_house,-(m_flow_nom_pipe - 5*
        m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={176,-86})));
  IDEAS.Fluid.FixedResistances.Junction junSup156(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 10*m_flow_nom_house,-(m_flow_nom_pipe -
        11*m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-124,16})));
  IDEAS.Fluid.FixedResistances.Junction junSup154(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 9*m_flow_nom_house,-(m_flow_nom_pipe - 10
        *m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-64,16})));
  IDEAS.Fluid.FixedResistances.Junction junSup152(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 8*m_flow_nom_house,-(m_flow_nom_pipe - 9*
        m_flow_nom_house),-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-4,16})));
  IDEAS.Fluid.FixedResistances.Junction junSup148(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={m_flow_nom_pipe - 6*m_flow_nom_house,-(m_flow_nom_pipe - 8*
        m_flow_nom_house),-2*m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={66,16})));
  IDEAS.Fluid.FixedResistances.Junction junSup150(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={2*m_flow_nom_house,-m_flow_nom_house,-m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={66,60})));
  IDEAS.Fluid.FixedResistances.Junction junRet148(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 8*m_flow_nom_house,-(m_flow_nom_pipe - 6*
        m_flow_nom_house),2*m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={54,4})));
  IDEAS.Fluid.FixedResistances.Junction junRet152(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 9*m_flow_nom_house,-(m_flow_nom_pipe - 8*
        m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-16,4})));
  IDEAS.Fluid.FixedResistances.Junction junRet154(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 10*m_flow_nom_house,-(m_flow_nom_pipe - 9
        *m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-76,4})));
  IDEAS.Fluid.FixedResistances.Junction junRet156(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_pipe - 11*m_flow_nom_house,-(m_flow_nom_pipe -
        10*m_flow_nom_house),m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-136,4})));
  IDEAS.Fluid.FixedResistances.Junction junRet150(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={m_flow_nom_house,-2*m_flow_nom_house,m_flow_nom_house},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={54,70})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium=Medium)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium=Medium)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{50,-150},{70,-130}})));
  UnitTests.Circuits.CircuitCollector collector(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nom_pipe)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-191,-78})));
  Modelica.Blocks.Sources.RealExpression Pbhp(y=nr136.heatingSystem.bhp.PEl +
        nr138.heatingSystem.bhp.PEl + nr140.heatingSystem.bhp.PEl + nr142.heatingSystem.bhp.PEl
         + nr144.heatingSystem.bhp.PEl + nr146.heatingSystem.bhp.PEl + nr148.heatingSystem.bhp.PEl
         + nr150.heatingSystem.bhp.PEl + nr152.heatingSystem.bhp.PEl + nr154.heatingSystem.bhp.PEl
         + nr156.heatingSystem.bhp.PEl + nr158.heatingSystem.bhp.PEl)
    annotation (Placement(transformation(extent={{-138,122},{-118,142}})));
  Modelica.Blocks.Sources.CombiTimeTable P_appliances_profile(
    tableOnFile=true,
    tableName="data",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath("modelica://IOCSmod/Resources/OccupancyProfiles/Appliance_power_demand_StijnS_14houses.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Math.Sum Pnet(nin=3, k={12/14,1,1})
    annotation (Placement(visible = true, transformation(origin={-70,100},    extent = {{-10, -10}, {10, 10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput P
    annotation(Placement(transformation(extent={{-40,90},{-20,110}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,78})));
  Modelica.Blocks.Sources.RealExpression Ppumps(y=nr136.heatingSystem.pumpSec.P
         + nr136.heatingSystem.pumpBhp.P + nr138.heatingSystem.pumpSec.P +
        nr138.heatingSystem.pumpBhp.P + nr140.heatingSystem.pumpSec.P + nr140.heatingSystem.pumpBhp.P
         + nr142.heatingSystem.pumpSec.P + nr142.heatingSystem.pumpBhp.P +
        nr144.heatingSystem.pumpSec.P + nr144.heatingSystem.pumpBhp.P + nr146.heatingSystem.pumpSec.P
         + nr146.heatingSystem.pumpBhp.P + nr148.heatingSystem.pumpSec.P +
        nr148.heatingSystem.pumpBhp.P + nr150.heatingSystem.pumpSec.P + nr150.heatingSystem.pumpBhp.P
         + nr152.heatingSystem.pumpSec.P + nr152.heatingSystem.pumpBhp.P +
        nr154.heatingSystem.pumpSec.P + nr154.heatingSystem.pumpBhp.P + nr156.heatingSystem.pumpSec.P
         + nr156.heatingSystem.pumpBhp.P + nr158.heatingSystem.pumpSec.P +
        nr158.heatingSystem.pumpBhp.P)
    annotation (Placement(transformation(extent={{-138,106},{-118,126}})));
equation

  connect(nr136.port_b, pipeProduction136B.port_a2) annotation (Line(points={{-128,
          -30},{-124,-30},{-124,-40}}, color={0,127,255}));
  connect(pipe136138B.port_b1, nr138.port_a) annotation (Line(points={{-76,-40},
          {-76,-30},{-72,-30}},   color={0,127,255}));
  connect(nr138.port_b, pipe136138B.port_a2) annotation (Line(points={{-68,-30},
          {-64,-30},{-64,-40}},   color={0,127,255}));
  connect(pipe138140B.port_b1, nr140.port_a) annotation (Line(points={{-16,-40},
          {-16,-30},{-12,-30}},   color={0,127,255}));
  connect(nr140.port_b, pipe138140B.port_a2) annotation (Line(points={{-8,-30},
          {-4,-30},{-4,-40}},     color={0,127,255}));
  connect(pipe142144B.port_b1, nr144.port_a) annotation (Line(points={{104,-40},
          {104,-30},{108,-30}}, color={0,127,255}));
  connect(nr144.port_b, pipe142144B.port_a2) annotation (Line(points={{112,-30},
          {116,-30},{116,-40}}, color={0,127,255}));
  connect(pipe140142B.port_b1, nr142.port_a) annotation (Line(points={{44,-40},
          {44,-30},{48,-30}},     color={0,127,255}));
  connect(nr142.port_b, pipe140142B.port_a2) annotation (Line(points={{52,-30},
          {56,-30},{56,-40}},   color={0,127,255}));
  connect(pipe144146B.port_b1, nr146.port_a) annotation (Line(points={{164,-40},
          {164,-30},{168,-30}}, color={0,127,255}));
  connect(nr146.port_b, pipe144146B.port_a2) annotation (Line(points={{172,-30},
          {176,-30},{176,-40}}, color={0,127,255}));
  connect(pipe148150A.port_b1, nr150.port_a)
    annotation (Line(points={{66,100},{66,110},{62,110}}, color={0,127,255}));
  connect(nr150.port_b, pipe148150A.port_a2)
    annotation (Line(points={{58,110},{54,110},{54,100}}, color={0,127,255}));
  connect(nr148.port_a, pipe146148C.port_b1)
    annotation (Line(points={{112,110},{116,110},{116,100}},
                                                          color={0,127,255}));
  connect(nr148.port_b, pipe146148C.port_a2)
    annotation (Line(points={{108,110},{104,110},{104,100}},
                                                          color={0,127,255}));
  connect(pipe150152B.port_b1, nr152.port_a) annotation (Line(points={{-4,50},{
          -4,60},{-8,60}},      color={0,127,255}));
  connect(nr152.port_b, pipe150152B.port_a2) annotation (Line(points={{-12,60},
          {-16,60},{-16,50}},   color={0,127,255}));
  connect(pipe152154B.port_b1, nr154.port_a) annotation (Line(points={{-64,50},
          {-64,60},{-68,60}},   color={0,127,255}));
  connect(nr154.port_b, pipe152154B.port_a2) annotation (Line(points={{-72,60},
          {-76,60},{-76,50}},   color={0,127,255}));
  connect(pipe154156B.port_b1, nr156.port_a) annotation (Line(points={{-124,50},
          {-124,60},{-128,60}}, color={0,127,255}));
  connect(pipe154156B.port_a2, nr156.port_b) annotation (Line(points={{-136,50},
          {-136,60},{-132,60}}, color={0,127,255}));
  connect(pipe156158.port_b1, nr158.port_a) annotation (Line(points={{-170,16},
          {-178,16},{-178,60}},         color={0,127,255}));
  connect(pipe156158.port_a2, nr158.port_b) annotation (Line(points={{-170,4},{
          -182,4},{-182,60}},   color={0,127,255}));
  connect(junRet136.port_2, pipeProduction136A.port_a2)
    annotation (Line(points={{-129,-86},{-150,-86}}, color={0,127,255}));
  connect(junRet136.port_1, pipe136138A.port_b2)
    annotation (Line(points={{-119,-86},{-110,-86}}, color={0,127,255}));
  connect(junRet138.port_1, pipe138140A.port_b2)
    annotation (Line(points={{-59,-86},{-50,-86}}, color={0,127,255}));
  connect(junRet138.port_2, pipe136138A.port_a2)
    annotation (Line(points={{-69,-86},{-90,-86}}, color={0,127,255}));
  connect(junRet140.port_1, pipe140142A.port_b2)
    annotation (Line(points={{1,-86},{10,-86}}, color={0,127,255}));
  connect(pipe138140A.port_a2, junRet140.port_2)
    annotation (Line(points={{-30,-86},{-9,-86}}, color={0,127,255}));
  connect(junRet142.port_1, pipe142144A.port_b2)
    annotation (Line(points={{61,-86},{70,-86}}, color={0,127,255}));
  connect(junRet142.port_2, pipe140142A.port_a2)
    annotation (Line(points={{51,-86},{30,-86}}, color={0,127,255}));
  connect(junRet144.port_1, pipe144146A.port_b2)
    annotation (Line(points={{121,-86},{130,-86}}, color={0,127,255}));
  connect(junRet144.port_2, pipe142144A.port_a2)
    annotation (Line(points={{111,-86},{90,-86}}, color={0,127,255}));
  connect(pipeProduction136A.port_b1, junSup136.port_1)
    annotation (Line(points={{-150,-74},{-141,-74}}, color={0,127,255}));
  connect(junSup136.port_2, pipe136138A.port_a1)
    annotation (Line(points={{-131,-74},{-110,-74}}, color={0,127,255}));
  connect(pipe136138A.port_b1, junSup138.port_1)
    annotation (Line(points={{-90,-74},{-81,-74}}, color={0,127,255}));
  connect(junSup138.port_2, pipe138140A.port_a1)
    annotation (Line(points={{-71,-74},{-50,-74}}, color={0,127,255}));
  connect(pipe138140A.port_b1, junSup140.port_1)
    annotation (Line(points={{-30,-74},{-21,-74}}, color={0,127,255}));
  connect(junSup140.port_2, pipe140142A.port_a1)
    annotation (Line(points={{-11,-74},{10,-74}}, color={0,127,255}));
  connect(pipe140142A.port_b1, junSup142.port_1)
    annotation (Line(points={{30,-74},{39,-74}}, color={0,127,255}));
  connect(junSup142.port_2, pipe142144A.port_a1)
    annotation (Line(points={{49,-74},{70,-74}}, color={0,127,255}));
  connect(pipe142144A.port_b1, junSup144.port_1)
    annotation (Line(points={{90,-74},{99,-74}}, color={0,127,255}));
  connect(junSup144.port_2, pipe144146A.port_a1)
    annotation (Line(points={{109,-74},{130,-74}}, color={0,127,255}));
  connect(junSup136.port_3, pipeProduction136B.port_a1)
    annotation (Line(points={{-136,-69},{-136,-60}}, color={0,127,255}));
  connect(pipeProduction136B.port_b2, junRet136.port_3)
    annotation (Line(points={{-124,-60},{-124,-81}}, color={0,127,255}));
  connect(pipe136138B.port_a1, junSup138.port_3)
    annotation (Line(points={{-76,-60},{-76,-69}}, color={0,127,255}));
  connect(pipe136138B.port_b2, junRet138.port_3)
    annotation (Line(points={{-64,-60},{-64,-81}}, color={0,127,255}));
  connect(pipe138140B.port_a1, junSup140.port_3)
    annotation (Line(points={{-16,-60},{-16,-69}}, color={0,127,255}));
  connect(pipe138140B.port_b2, junRet140.port_3) annotation (Line(points={{-4,
          -60},{-4,-70.5},{-4,-70.5},{-4,-81}}, color={0,127,255}));
  connect(junSup142.port_3, pipe140142B.port_a1)
    annotation (Line(points={{44,-69},{44,-60}}, color={0,127,255}));
  connect(pipe140142B.port_b2, junRet142.port_3)
    annotation (Line(points={{56,-60},{56,-81}}, color={0,127,255}));
  connect(junSup144.port_3, pipe142144B.port_a1)
    annotation (Line(points={{104,-69},{104,-60}}, color={0,127,255}));
  connect(pipe142144B.port_b2, junRet144.port_3)
    annotation (Line(points={{116,-60},{116,-81}}, color={0,127,255}));
  connect(pipe144146A.port_b1, junSup146.port_1)
    annotation (Line(points={{150,-74},{159,-74}}, color={0,127,255}));
  connect(junSup146.port_3, pipe144146B.port_a1)
    annotation (Line(points={{164,-69},{164,-60}}, color={0,127,255}));
  connect(pipe144146A.port_a2, junRet146.port_2)
    annotation (Line(points={{150,-86},{171,-86}}, color={0,127,255}));
  connect(junRet146.port_3, pipe144146B.port_b2)
    annotation (Line(points={{176,-81},{176,-60}}, color={0,127,255}));
  connect(junSup156.port_1, pipe154156A.port_b1)
    annotation (Line(points={{-119,16},{-110,16}}, color={0,127,255}));
  connect(junSup156.port_2, pipe156158.port_a1)
    annotation (Line(points={{-129,16},{-150,16}}, color={0,127,255}));
  connect(pipe154156A.port_a1, junSup154.port_2)
    annotation (Line(points={{-90,16},{-69,16}}, color={0,127,255}));
  connect(junSup154.port_1, pipe152154A.port_b1)
    annotation (Line(points={{-59,16},{-50,16}}, color={0,127,255}));
  connect(pipe152154A.port_a1, junSup152.port_2)
    annotation (Line(points={{-30,16},{-9,16}}, color={0,127,255}));
  connect(junSup156.port_3, pipe154156B.port_a1)
    annotation (Line(points={{-124,21},{-124,30}}, color={0,127,255}));
  connect(junSup154.port_3, pipe152154B.port_a1)
    annotation (Line(points={{-64,21},{-64,30}}, color={0,127,255}));
  connect(pipe150152B.port_a1, junSup152.port_3) annotation (Line(points={{-4,
          30},{-4,25.5},{-4,25.5},{-4,21}}, color={0,127,255}));
  connect(junSup152.port_1, pipe150152A.port_b1)
    annotation (Line(points={{1,16},{10,16}}, color={0,127,255}));
  connect(junSup146.port_2, pipe146148A.port_a1) annotation (Line(points={{169,
          -74},{194,-74},{194,16},{150,16}}, color={0,127,255}));
  connect(junRet146.port_1, pipe146148A.port_b2) annotation (Line(points={{181,
          -86},{186,-86},{186,4},{150,4}}, color={0,127,255}));
  connect(junSup148.port_1, pipe146148A.port_b1)
    annotation (Line(points={{71,16},{130,16}}, color={0,127,255}));
  connect(junSup148.port_2, pipe150152A.port_a1)
    annotation (Line(points={{61,16},{30,16}}, color={0,127,255}));
  connect(junSup148.port_3, pipe146148B.port_a1)
    annotation (Line(points={{66,21},{66,30}}, color={0,127,255}));
  connect(pipe146148B.port_b1, junSup150.port_1)
    annotation (Line(points={{66,50},{66,55}}, color={0,127,255}));
  connect(junSup150.port_3, pipe146148C.port_a1)
    annotation (Line(points={{71,60},{116,60},{116,80}}, color={0,127,255}));
  connect(junSup150.port_2, pipe148150A.port_a1)
    annotation (Line(points={{66,65},{66,80}}, color={0,127,255}));
  connect(junRet148.port_2, pipe146148A.port_a2)
    annotation (Line(points={{59,4},{130,4}}, color={0,127,255}));
  connect(pipe146148B.port_b2, junRet148.port_3)
    annotation (Line(points={{54,30},{54,9}}, color={0,127,255}));
  connect(pipe150152A.port_b2, junRet148.port_1) annotation (Line(points={{30,4},
          {39.5,4},{39.5,4},{49,4}}, color={0,127,255}));
  connect(pipe152154A.port_b2, junRet152.port_1) annotation (Line(points={{-30,
          4},{-25.5,4},{-25.5,4},{-21,4}}, color={0,127,255}));
  connect(junRet152.port_2, pipe150152A.port_a2) annotation (Line(points={{-11,
          4},{-0.5,4},{-0.5,4},{10,4}}, color={0,127,255}));
  connect(pipe150152B.port_b2, junRet152.port_3)
    annotation (Line(points={{-16,30},{-16,9}}, color={0,127,255}));
  connect(pipe154156A.port_b2, junRet154.port_1)
    annotation (Line(points={{-90,4},{-81,4}}, color={0,127,255}));
  connect(junRet154.port_3, pipe152154B.port_b2)
    annotation (Line(points={{-76,9},{-76,30}}, color={0,127,255}));
  connect(junRet154.port_2, pipe152154A.port_a2) annotation (Line(points={{-71,
          4},{-60.5,4},{-60.5,4},{-50,4}}, color={0,127,255}));
  connect(junRet156.port_2, pipe154156A.port_a2) annotation (Line(points={{-131,
          4},{-120.5,4},{-120.5,4},{-110,4}}, color={0,127,255}));
  connect(junRet156.port_3, pipe154156B.port_b2)
    annotation (Line(points={{-136,9},{-136,30}}, color={0,127,255}));
  connect(junRet156.port_1, pipe156158.port_b2)
    annotation (Line(points={{-141,4},{-150,4}}, color={0,127,255}));
  connect(junRet150.port_2, pipe146148B.port_a2)
    annotation (Line(points={{54,65},{54,50}}, color={0,127,255}));
  connect(junRet150.port_1, pipe148150A.port_b2)
    annotation (Line(points={{54,75},{54,80}}, color={0,127,255}));
  connect(junRet150.port_3, pipe146148C.port_b2)
    annotation (Line(points={{59,70},{104,70},{104,80}}, color={0,127,255}));
  connect(pipeProduction136B.port_b1, nr136.port_a) annotation (Line(points={{
          -136,-40},{-136,-30},{-132,-30}}, color={0,127,255}));
  connect(collector.port_b2, pipeProduction136A.port_a1) annotation (Line(
        points={{-185,-68},{-184,-68},{-184,-74},{-170,-74}}, color={0,127,255}));
  connect(collector.port_a2, pipeProduction136A.port_b2) annotation (Line(
        points={{-185,-88},{-178,-88},{-178,-86},{-170,-86}}, color={0,127,255}));
  connect(collector.port_a1, port_a1) annotation (Line(points={{-197,-68},{-220,
          -68},{-220,-120},{-60,-120},{-60,-140}}, color={0,127,255}));
  connect(collector.port_b1, port_b1) annotation (Line(points={{-197,-88},{-204,
          -88},{-204,-104},{20,-104},{20,-140},{60,-140}}, color={0,127,255}));
  connect(Pnet.y, P)
    annotation (Line(points={{-59,100},{-30,100}}, color={0,0,127}));
  connect(P_appliances_profile.y[1], Pnet.u[1]) annotation (Line(points={{-119,90},
          {-100,90},{-100,98.6667},{-82,98.6667}},     color={0,0,127}));
  connect(Ppumps.y, Pnet.u[2]) annotation (Line(points={{-117,116},{-104,116},{
          -104,100},{-82,100}}, color={0,0,127}));
  connect(Pbhp.y, Pnet.u[3]) annotation (Line(points={{-117,132},{-94,132},{-94,
          101.333},{-82,101.333}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{-56,-26},{-56,-92},{-12,-92},{-12,-46},{10,-46},{10,-92},{56,
              -92},{56,-26},{0,14},{-56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-56,-26},{-66,-34},{-72,-26},{0,26},{72,-26},{68,-34},{56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-44,-46},{-26,-46},{-26,-64},{-44,-64},{-44,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{24,-46},{42,-46},{42,-64},{24,-64},{24,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-10,-14},{8,-14},{8,-32},{-10,-32},{-10,-14}},
          color={244,125,35},
          thickness=0.5),
        Polygon(
          points={{6,24},{64,-18},{64,-16},{6,26},{6,24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,32},{76,32},{84,30},{86,26},{86,22},{86,18},{80,18},{80,22},
              {80,24},{76,26},{56,26},{56,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,32},{72,32},{72,40},{76,38},{76,42},{66,42},{66,38},{70,40},
              {70,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,16},{82,12},{82,10},{84,8},{86,10},{86,12},{84,16}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-40,20}},
          textColor={0,0,0},
          textStyle={TextStyle.Italic},
          textString="12"),
        Polygon(
          points={{84,-40},{90,-40},{84,-54},{92,-54},{78,-80},{84,-58},{76,-58},
              {84,-40}},
          lineColor={0,0,0},
          fillColor={244,221,46},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{220,140}})));
end DeSchipjesOneZone;
