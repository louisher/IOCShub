within IOCSmod.Demand.BuildingModels;
model TwoZoneIdeal
  extends TwoZoneBase;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHeaZone1
    "Heat flow in emb heat node of zone 1"
    annotation (Placement(transformation(extent={{14,30},{-6,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHeaZone2
    "Heat flow in emb heat node of zone 2"
    annotation (Placement(transformation(extent={{14,10},{-6,30}})));
  Modelica.Blocks.Interfaces.RealInput uHea1(
    quantity="free",
    min=0,
    max=Q_flow_nominal,
    nominal=Q_flow_nominal,
    start=0) "Control input of ideal cooler" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,40})));
  Modelica.Blocks.Interfaces.RealInput uHea2(
    quantity="free",
    min=0,
    max=Q_flow_nominal,
    nominal=Q_flow_nominal,
    start=0) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,0})));
  Modelica.Blocks.Sources.RealExpression ExprQHea_flow1(y=uHea1)
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,40})));
  Modelica.Blocks.Sources.RealExpression ExprQHea_flow2(y=uHea2)
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,20})));
  Modelica.Blocks.Interfaces.RealInput uCoo1(
    quantity="free",
    min=0,
    max=Q_flow_nominal,
    nominal=Q_flow_nominal,
    start=0) "Control input of ideal cooler" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,-40})));
  Modelica.Blocks.Interfaces.RealInput uCoo2(
    quantity="free",
    min=0,
    max=Q_flow_nominal,
    nominal=Q_flow_nominal,
    start=0) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,-80})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QCooZone1
    "Heat flow in emb heat node of zone 1"
    annotation (Placement(transformation(extent={{12,-10},{-8,10}})));
  Modelica.Blocks.Sources.RealExpression ExprQCoo_flow1(y=-uCoo1)
            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={38,0})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QCooZone2
    "Heat flow in emb heat node of zone 1"
    annotation (Placement(transformation(extent={{12,-30},{-8,-10}})));
  Modelica.Blocks.Sources.RealExpression ExprQCoo_flow2(y=-uCoo2)
            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={38,-20})));
  Modelica.Blocks.Sources.RealExpression DummyBhp(y=0) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,78})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=298.15)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
equation
  connect(ExprQHea_flow1.y, QHeaZone1.Q_flow)
    annotation (Line(points={{29,40},{14,40}}, color={0,0,127}));
  connect(ExprQHea_flow2.y, QHeaZone2.Q_flow)
    annotation (Line(points={{29,20},{14,20}}, color={0,0,127}));
  connect(ExprQCoo_flow1.y, QCooZone1.Q_flow)
    annotation (Line(points={{27,0},{12,0}}, color={0,0,127}));
  connect(ExprQCoo_flow2.y, QCooZone2.Q_flow)
    annotation (Line(points={{27,-20},{12,-20}}, color={0,0,127}));
  connect(DummyBhp.y, Pnet.u[3]) annotation (Line(points={{81,78},{112,78},{112,
          80},{121.333,80},{121.333,72}},
                                  color={0,0,127}));
  connect(QHeaZone1.port, bui.heatPortEmb[1]) annotation (Line(points={{-6,40},{
          -20,40},{-20,66},{-26,66}}, color={191,0,0}));
  connect(QCooZone1.port, bui.heatPortEmb[1]) annotation (Line(points={{-8,0},{-20,
          0},{-20,66},{-26,66}}, color={191,0,0}));
  connect(QHeaZone2.port, bui.heatPortEmb[2]) annotation (Line(points={{-6,20},{
          -20,20},{-20,66},{-26,66}}, color={191,0,0}));
  connect(QCooZone2.port, bui.heatPortEmb[2]) annotation (Line(points={{-8,-20},
          {-20,-20},{-20,66},{-26,66}}, color={191,0,0}));
  connect(fixedTemperature.port, applianceHeatGains.heatPortCon[1]) annotation (
     Line(points={{10,70},{10,86},{20,86},{20,72}}, color={191,0,0}));
  connect(fixedTemperature.port, applianceHeatGains.heatPortCon[2])
    annotation (Line(points={{10,70},{20,70},{20,72}}, color={191,0,0}));
  connect(fixedTemperature.port, applianceHeatGains.heatPortRad[1])
    annotation (Line(points={{10,70},{20,70},{20,68}}, color={191,0,0}));
  connect(fixedTemperature.port, applianceHeatGains.heatPortRad[2])
    annotation (Line(points={{10,70},{20,70},{20,68}}, color={191,0,0}));
end TwoZoneIdeal;
