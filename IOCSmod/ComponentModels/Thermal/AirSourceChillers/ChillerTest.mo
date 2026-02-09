within IOCSmod.ComponentModels.Thermal.AirSourceChillers;
model ChillerTest

  IDEAS.Buildings.Components.RectangularZoneTemplate zone(
    redeclare package Medium = IDEAS.Media.Specialized.DryAir,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure
      interzonalAirFlow,
    redeclare IDEAS.Buildings.Components.Occupants.Input occNum,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    hasWinA=true,
    hasWinB=true,
    hasWinC=true,
    hasWinD=true,
    l=5,
    w=10,
    h=3,
    A_winA=5,
    A_winB=5,
    A_winC=5,
    A_winD=5,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall conTypA,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall conTypB,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall conTypC,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall conTypD,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightRoof conTypCei,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.HeavyFloor
      conTypFlo,
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Ar2020 glazingA,
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Ar2020 glazingB,
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Ar2020 glazingC,
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Ar2020 glazingD,
    hasEmb=true)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe floHea(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=chi.m1_flow_nominal,
    dp_nominal=1000,
    A_floor=50) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-62,-10})));
  Chiller_AirWater chi(
    TAir_nominal=293.15,
    TEvaOut_nominal=288.15,
    m1_flow_nominal=chi.Q_flow_nominal/4180/5,
    dp_nominalEva(displayUnit="Pa") = 1,
    dp_nominalCon(displayUnit="Pa") = 1,
    Q_flow_nominal=2000)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-10})));
  UnitTests.Confidential.FlowControlled_m_flow pum(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=chi.m1_flow_nominal,
    inputType=UnitTests.Confidential.BaseClasses.InputType.Constant,
    dp_nominal=1000)
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Sources.RealExpression ExprTamb(y=sim.Te) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={72,-14})));
     IDEAS.Fluid.Sensors.TemperatureTwoPort senTFloHeaIn(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea.m_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-40,-40})));
     IDEAS.Fluid.Sensors.TemperatureTwoPort senTFloHeaOut(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=floHea.m_flow_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-40,20})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
  Modelica.Blocks.Sources.RealExpression ExprOcc(y=15) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-114,22})));
equation
  connect(floHea.heatPortEmb, zone.gainEmb)
    annotation (Line(points={{-72,-10},{-80,-9}}, color={191,0,0}));
  connect(pum.port_b, chi.port_a) annotation (Line(points={{0,20},{20,20},{20,-4},
          {30,-4}}, color={0,127,255}));
  connect(ExprTamb.y, chi.Tair) annotation (Line(points={{61,-14},{56,-14},{56,-13},
          {50,-13}}, color={0,0,127}));
  connect(senTFloHeaIn.port_b, floHea.port_a) annotation (Line(points={{-46,-40},
          {-62,-40},{-62,-20}}, color={0,127,255}));
  connect(floHea.port_b, senTFloHeaOut.port_a)
    annotation (Line(points={{-62,0},{-62,20},{-46,20}}, color={0,127,255}));
  connect(senTFloHeaOut.port_b, pum.port_a)
    annotation (Line(points={{-34,20},{-20,20}}, color={0,127,255}));
  connect(senTFloHeaIn.port_a, chi.port_b) annotation (Line(points={{-34,-40},{-8,
          -40},{-8,-38},{20,-38},{20,-16},{30,-16}}, color={0,127,255}));
  connect(bou.ports[1], floHea.port_b) annotation (Line(points={{-72,40},{-62,
          40},{-62,0}},               color={0,127,255}));
  connect(ExprOcc.y, zone.yOcc) annotation (Line(points={{-103,22},{-92,22},{-92,
          24},{-78,24},{-78,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerTest;
