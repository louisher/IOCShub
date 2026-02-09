within IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt;
model EN12975
  extends
    IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.BaseClasses.PartialSolarCollector(
    redeclare Buildings.Fluid.SolarCollectors.Data.GenericEN12975 per);

    outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-102,100},{-82,120}})));

  // Parameters
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Ambient temperature minus fluid temperature at nominal conditions"
      annotation (Dialog(group="Temperature parameters TACO"));
   parameter Modelica.Units.SI.TemperatureDifference dTMax(min=1) = 20
    "Maximum temperature difference across solar collector"
  annotation (Dialog(group="Temperature parameters TACO"));

   IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.BaseClasses.EN12975SolarGain solGai(
    redeclare package Medium = Medium,
    final nSeg=nSeg,
    final incAngDat=per.incAngDat,
    final incAngModDat=per.incAngModDat,
    final iamDiff=per.IAMDiff,
    final eta0=per.eta0,
    final use_shaCoe_in=use_shaCoe_in,
    final shaCoe=shaCoe,
    final A_c=ATot_internal)
    "Identifies heat gained from the sun using the EN12975 standard calculations"
     annotation (Placement(transformation(extent={{-20,40},{0,60}})));
   IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.BaseClasses.EN12975HeatLoss heaLos(
    redeclare package Medium = Medium,
    final nSeg=nSeg,
    final a1=per.a1,
    final a2=per.a2,
    final A_c=ATot_internal,
    dT_nominal=dT_nominal)
    "Calculates the heat lost to the surroundings using the EN12975 standard calculations"
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Modelica.Blocks.Sources.RealExpression QMax(y=abs(port_a.m_flow)*4184*dTMax)
    "Maximum thermal power"
    annotation (Placement(transformation(extent={{20,70},{0,90}})));

  Modelica.Units.SI.HeatFlowRate QTot "Total amount of heat added by the solar Collectors";


equation
  // Make sure the model is only used with the EN ratings data, and hence a1 > 0
  assert(per.a1 > 0,
    "In " + getInstanceName() + ": The heat loss coefficient from the EN 12975 ratings data must be strictly positive. Obtained a1 = " + String(per.a1));
  QTot = sum(QGai.Q_flow) + sum(QLos.Q_flow);
  connect(shaCoe_internal, solGai.shaCoe_in);

  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-99.95,80.05},{-90,80.05},{-90,26},{-22,26}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solGai.incAng)    annotation (Line(
      points={{-59,46},{-50,46},{-50,48},{-22,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.H, solGai.HSkyDifTil) annotation (Line(
      points={{-59,80},{-30,80},{-30,58},{-22,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solGai.HDirTil) annotation (Line(
      points={{-59,50},{-50,50},{-50,52},{-22,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe_in, solGai.shaCoe_in) annotation (Line(
      points={{-120,40},{-40,40},{-40,45},{-22,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.TFlu, temSen.T) annotation (Line(
      points={{-22,14},{-30,14},{-30,-20},{-11,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos_flow, QLos.Q_flow) annotation (Line(
      points={{1,20},{50,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solGai.QSol_flow, QGai.Q_flow) annotation (Line(
      points={{1,50},{50,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, solGai.TFlu) annotation (Line(
      points={{-11,-20},{-30,-20},{-30,42},{-22,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sim.weaDatBus, weaBus) annotation (Line(
      points={{-82.1,110},{-76,110},{-76,126},{-114,126},{-114,80},{-100,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(QMax.y, solGai.QMax)
    annotation (Line(points={{-1,80},{-10,80},{-10,62}}, color={0,0,127}));
  annotation (defaultComponentName="solCol", Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
      graphics={
        Rectangle(
          extent={{-84,100},{84,-100}},
          lineColor={27,0,55},
          fillColor={26,0,55},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-76,0},{-76,-90},{66,-90},{66,-60},{-64,-60},{-64,
              -30},{66,-30},{66,0},{-64,0},{-64,28},{66,28},{66,60},{-64,60},{
              -64,86},{78,86},{78,0},{98,0},{100,0}},
          color={0,128,255},
          thickness=1,
          smooth=Smooth.None),
        Ellipse(
          extent={{-24,26},{28,-26}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-6,-6},{8,8}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-24,30},
          rotation=90),
        Line(
          points={{-50,0},{-30,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-36,-40},{-20,-24}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={2,-40},
          rotation=90),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={30,-30},
          rotation=90),
        Line(
          points={{32,0},{52,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={28,32},
          rotation=180),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={0,40},
          rotation=90)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EN12975;
