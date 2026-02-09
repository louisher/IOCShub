within IOCSmod.Simulation.Controls;
model RbcPvt
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       TBor
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       Irr
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{14,-28},{34,-8}})));
  Modelica.Blocks.Logical.Hysteresis          hysteresis1(
                                                       uLow=10 + 273.15,
      uHigh=16 + 273.15)
    annotation (Placement(transformation(extent={{-64,-8},{-44,12}})));
  Modelica.Blocks.Logical.Hysteresis          hysteresis(     uLow=100, uHigh=
        200)
    annotation (Placement(transformation(extent={{-66,-60},{-46,-40}})));
  Modelica.Blocks.Logical.Not            notTBor
    annotation (Placement(transformation(extent={{-32,-8},{-12,12}})));
  Modelica_StateGraph2.Step statePvtOff(
    initialStep=true,
    nOut=1,
    nIn=1) annotation (Placement(transformation(extent={{-64,74},{-56,66}})));
  Modelica_StateGraph2.Step statePvtOn(
    initialStep=false,
    use_activePort=true,
    nIn=1,
    nOut=1) annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=180,
        origin={-20,70})));
  Modelica_StateGraph2.Transition transStcOn(
    use_conditionPort=false,
    condition=Tpvt >= TBor + 8,
    delayedTransition=false,
    waitTime=120) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-40,80})));
  Modelica_StateGraph2.Transition transStcOff(
    use_conditionPort=false,
    condition=Tpvt < TBor + 4,
    delayedTransition=true,
    waitTime=300) annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={-40,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Tpvt
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realFalse=1/1000)
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Blocks.Interfaces.RealOutput yPvt "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(hysteresis1.y, notTBor.u)
    annotation (Line(points={{-43,2},{-34,2}}, color={255,0,255}));
  connect(notTBor.y,and1. u1) annotation (Line(points={{-11,2},{6,2},{6,-18},{
          12,-18}}, color={255,0,255}));
  connect(TBor, hysteresis1.u) annotation (Line(points={{-120,40},{-76,40},{-76,
          2},{-66,2}}, color={0,0,127}));
  connect(Irr, hysteresis.u) annotation (Line(points={{-120,-40},{-76,-40},{-76,
          -50},{-68,-50}}, color={0,0,127}));
  connect(hysteresis.y, and1.u2) annotation (Line(points={{-45,-50},{6,-50},{6,
          -26},{12,-26}},    color={255,0,255}));
  connect(transStcOff.outPort,statePvtOff. inPort[1])
    annotation (Line(points={{-45,60},{-60,60},{-60,66}},   color={0,0,0}));
  connect(statePvtOff.outPort[1],transStcOn. inPort)
    annotation (Line(points={{-60,74.6},{-60,80},{-44,80}},   color={0,0,0}));
  connect(transStcOn.outPort,statePvtOn. inPort[1])
    annotation (Line(points={{-35,80},{-20,80},{-20,74}},color={0,0,0}));
  connect(statePvtOn.outPort[1],transStcOff. inPort)
    annotation (Line(points={{-20,65.4},{-20,60},{-36,60}},color={0,0,0}));
  connect(and1.y, and2.u2)
    annotation (Line(points={{35,-18},{38,-18},{38,-8}}, color={255,0,255}));
  connect(statePvtOn.activePort, and2.u1) annotation (Line(points={{-15.28,70},
          {32,70},{32,0},{38,0}}, color={255,0,255}));
  connect(and2.y, booleanToReal.u)
    annotation (Line(points={{61,0},{70,0}}, color={255,0,255}));
  connect(booleanToReal.y, yPvt)
    annotation (Line(points={{93,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RbcPvt;
