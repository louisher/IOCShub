within IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem;
model HeatingSystemRbc
  "Building heating system model controlled by RBC"
  extends
    IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem.HeatingSystem(pumpBhp(
        inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous));

  DeSchipjes.Simulation.HeatDemand.HeatingSystem.Controls.RbcHexReference rbcHex(
      m_flow_nom_prim=m_flow_nom_prim, onOff(ymin=0.01), valvePrimSupPI(yMin=0.01)) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={92,160})));
  DeSchipjes.Simulation.HeatDemand.HeatingSystem.Controls.RbcGenReference rbcGen
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-118,210})));
  DeSchipjes.Simulation.HeatDemand.HeatingSystem.Controls.RbcBhpReference rbcBhp(
      m_flow_nom_bhp_con=m_flow_nom_bhp_con)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-8,160})));
  DeSchipjes.Simulation.HeatDemand.HeatingSystem.Controls.RbcShReference rbcSh
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-158,160})));
  Modelica.Blocks.Interfaces.BooleanOutput heatDemand annotation (Placement(
        transformation(extent={{182,100},{202,120}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,110})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=dp_nom_sec)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={130,130})));
  Modelica.Blocks.MathBoolean.Or or1(nu=3) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={172,160})));
  Modelica.Blocks.Sources.BooleanExpression conBhpExpression(y=rbcBhp.conBhp)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-138,210})));
  Modelica.Blocks.Sources.RealExpression TTankDhwTopExpression(y=tankDhw.T)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={32,210})));
  Modelica.Blocks.Sources.RealExpression TTankDhwBotExpression(y=tankDhw.T)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={12,210})));
  Modelica.Blocks.Sources.RealExpression TBhpEvaInExpression1(y=TBhpEvaIn.T)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-48,210})));
  Modelica.Blocks.Sources.RealExpression TFhInExpression(y=TFhIn.T) annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-182,210})));
  Modelica.Blocks.Sources.RealExpression TheatingCurveShExpression(y=rbcHex.heatingCurveSh.y)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-168,210})));
  Modelica.Blocks.Sources.RealExpression TSecSupExpression(y=TSecSup.T)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-152,210})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1(realTrue=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,96})));
  Modelica.Blocks.Sources.RealExpression TSetHeaExpr(y=21 + 273.15) annotation (
     Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-120,182})));
  Modelica.Blocks.Continuous.Integrator DiscmfCoo(k=1/3600)
    annotation (Placement(transformation(extent={{-304,172},{-284,192}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=max(0, TSensor[1] -
        TSetCooExpr.y))
    annotation (Placement(transformation(extent={{-342,172},{-322,192}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea(k=1/3600)
    annotation (Placement(transformation(extent={{-304,138},{-284,158}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=max(0, TSetHeaExpr.y
         - TSensor[1]))
    annotation (Placement(transformation(extent={{-344,138},{-324,158}})));
  Modelica.Blocks.Sources.RealExpression Discmf(y=DiscmfCoo.y + DiscmfHea.y)
    annotation (Placement(transformation(extent={{-304,104},{-284,124}})));
  Modelica.Blocks.Sources.RealExpression TSetCooExpr(y=if ((time < 90*24*3600)
         or (time > 273*24*3600)) then (23 + 273.15) else (26 + 273.15))
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-120,166})));
  Modelica.Blocks.Continuous.Integrator EBhp_kWh(k=1/3600000)
    annotation (Placement(transformation(extent={{-302,62},{-282,82}})));
  Modelica.Blocks.Sources.RealExpression realExprPbhp(y=bhp.PEl)
    annotation (Placement(transformation(extent={{-342,62},{-322,82}})));
  Modelica.Blocks.Sources.RealExpression exprValBhp(y=1)
    annotation (Placement(transformation(extent={{-34,80},{-54,100}})));
equation
  connect(rbcBhp.mPumpBhpHp, pumpBhp.m_flow_in) annotation (Line(points={{-4,149},
          {-4,124},{20,124},{20,82}}, color={0,0,127}));
  connect(rbcSh.conFh, valveFh.y) annotation (Line(points={{-160,149},{-160,72},
          {-100,72},{-100,62}}, color={0,0,127}));
  connect(pumpSec.dp_in, booleanToReal.y) annotation (Line(points={{-10,-82},{-10,
          -110},{130,-110},{130,119}},   color={0,0,127}));
  connect(or1.y, booleanToReal.u) annotation (Line(points={{172,153.1},{172,148},
          {130,148},{130,142}},color={255,0,255}));
  connect(or1.y,heatDemand)  annotation (Line(points={{172,153.1},{172,110},{192,
          110}},               color={255,0,255}));
  connect(or1.u[1], rbcSh.fhOn) annotation (Line(points={{174.8,166},{174.8,240},
          {-200,240},{-200,140},{-164,140},{-164,149}}, color={255,0,255}));
  connect(rbcSh.radOn, or1.u[2]) annotation (Line(points={{-156,149},{-156,130},
          {-210,130},{-210,252},{172,252},{172,166}},                   color={
          255,0,255}));
  connect(rbcSh.fhOn, rbcHex.fhOn) annotation (Line(points={{-164,149},{-164,140},
          {-200,140},{-200,240},{88,240},{88,172}},      color={255,0,255}));
  connect(rbcSh.radOn,rbcHex.radOn)  annotation (Line(points={{-156,149},{-156,130},
          {-210,130},{-210,252},{84,252},{84,172}},               color={255,0,
          255}));
  connect(rbcHex.heatDemand, booleanToReal.u) annotation (Line(points={{100,172},
          {100,178},{130,178},{130,142}},color={255,0,255}));
  connect(TBhpEvaInExpression1.y, rbcBhp.TBhpIn) annotation (Line(points={{-48,199},
          {-48,184},{-16,184},{-16,172}},      color={0,0,127}));
  connect(TTankDhwBotExpression.y, rbcBhp.TTankDhwBot) annotation (Line(points={{12,199},
          {12,190},{-4,190},{-4,172}},           color={0,0,127}));
  connect(rbcSh.summerOn, rbcGen.summerOn) annotation (Line(points={{-149,172},{
          -149,190},{-118,190},{-118,199}},            color={255,0,255}));
  connect(rbcSh.conRad, valveRad.y) annotation (Line(points={{-152,149},{-152,130},
          {-100,130},{-100,-18}}, color={0,0,127}));
  connect(rbcBhp.conBhp, rbcHex.bhpOn) annotation (Line(points={{-8,149},{-8,140},
          {66,140},{66,182},{92,182},{92,172}},      color={255,0,255}));
  connect(or1.u[3], rbcHex.bhpOn) annotation (Line(points={{169.2,166},{169.2,182},
          {92,182},{92,172}}, color={255,0,255}));
  connect(TFhInExpression.y, rbcSh.TFhIn) annotation (Line(points={{-182,199},{-182,
          184},{-167,184},{-167,172}},      color={0,0,127}));
  connect(conBhpExpression.y, rbcSh.bhpOn) annotation (Line(points={{-138,199},{
          -138,194},{-158,194},{-158,172}},  color={255,0,255}));
  connect(TheatingCurveShExpression.y, rbcSh.THeatingCurve) annotation (Line(
        points={{-168,199},{-168,172},{-164,172}},            color={0,0,127}));
  connect(TSecSupExpression.y, rbcSh.TSecSup) annotation (Line(points={{-152,199},
          {-164,199},{-164,172},{-161,172}},      color={0,0,127}));
  connect(TSensor[1], rbcSh.TSensor) annotation (Line(points={{-204,-60},{-180,-60},
          {-180,178},{-158,178},{-158,172},{-155,172}},      color={0,0,127}));
  connect(TSecSupExpression.y, rbcHex.TSecSup) annotation (Line(points={{-152,199},
          {-152,192},{96,192},{96,172}},      color={0,0,127}));
  connect(rbcBhp.TTankDhwTop, TTankDhwTopExpression.y) annotation (Line(points={{
          1.77636e-15,172},{1.77636e-15,184},{32,184},{32,199}},
                                                 color={0,0,127}));
  connect(TTankDhwOut.port_b, TBhpConIn.port_a)
    annotation (Line(points={{25,40},{-3,40},{-3,40}},   color={0,127,255}));
  connect(rbcHex.conValvePrimSup, valvePrimSup.y) annotation (Line(points={{92,149},
          {92,30},{110,30},{110,-10},{100,-10},{100,-18}},      color={0,0,127}));
  connect(rbcBhp.conBhp, booleanToReal1.u) annotation (Line(points={{-8,149},{-8,
          130},{-20,130},{-20,108}}, color={255,0,255}));
  connect(booleanToReal1.y, bhp.mod)
    annotation (Line(points={{-20,85},{-20,71}}, color={0,0,127}));
  connect(TSetHeaExpr.y, rbcSh.TSet) annotation (Line(points={{-131,182},{-152,
          182},{-152,172}}, color={0,0,127}));
  connect(realExpression.y, DiscmfCoo.u)
    annotation (Line(points={{-321,182},{-306,182}}, color={0,0,127}));
  connect(realExpression2.y, DiscmfHea.u)
    annotation (Line(points={{-323,148},{-306,148}}, color={0,0,127}));
  connect(realExprPbhp.y, EBhp_kWh.u)
    annotation (Line(points={{-321,72},{-304,72}}, color={0,0,127}));
  connect(exprValBhp.y, valveBhp.y)
    annotation (Line(points={{-55,90},{-60,90},{-60,82}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-200,-100},{200,100}}),
                      graphics={         Rectangle(
          extent={{-188,231},{192,109}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
                                   Icon(coordinateSystem(extent={{-200,-100},{200,
            100}})),
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_fixedstepsize=15,
      __Dymola_Algorithm="Euler"));
end HeatingSystemRbc;
