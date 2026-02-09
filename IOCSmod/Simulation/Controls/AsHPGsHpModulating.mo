within IOCSmod.Simulation.Controls;
model AsHPGsHpModulating

  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       TTan
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAsHp
    "Connector of Real output signal" annotation (Placement(transformation(
          extent={{100,20},{140,60}}), iconTransformation(extent={{100,20},{140,
            60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yGsHp
    "Connector of Real output signal" annotation (Placement(transformation(
          extent={{100,-60},{140,-20}}), iconTransformation(extent={{100,-20},{
            140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       TAmb
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Logical.Hysteresis          hysteresis(
                                                  uLow=8 + 273.15, uHigh=
        12 + 273.15)
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Logical.Not            not1
    annotation (Placement(transformation(extent={{2,-14},{22,6}})));
  IDEAS.Controls.Continuous.LimPID     conPI(
    k=1,
    Ti=100,
    yMax=1,
    yMin=0,
    reverseActing=true)
    annotation (Placement(transformation(extent={{-46,-50},{-26,-30}})));
  SignalSplitter                                   signalSplitter
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  IDEAS.Controls.SetPoints.Table heatingCurve(table=[273.15 - 10,273.15 + 45;
        273.15 + 5,273.15 + 40; 273.15 + 20,273.15 + 25])
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(TAmb, hysteresis.u)
    annotation (Line(points={{-120,40},{-62,40}}, color={0,0,127}));
  connect(hysteresis.y, not1.u) annotation (Line(points={{-39,40},{-10,40},{-10,
          -4},{0,-4}}, color={255,0,255}));
  connect(TTan, conPI.u_m) annotation (Line(points={{-120,-40},{-62,-40},{-62,-62},
          {-36,-62},{-36,-52}}, color={0,0,127}));
  connect(conPI.y, signalSplitter.u)
    annotation (Line(points={{-25,-40},{-12,-40}}, color={0,0,127}));
  connect(signalSplitter.y1, switch1.u1) annotation (Line(points={{11,-36},{30,
          -36},{30,48},{58,48}},    color={0,0,127}));
  connect(switch1.y, yAsHp)
    annotation (Line(points={{81,40},{120,40}}, color={0,0,127}));
  connect(switch3.y, yGsHp)
    annotation (Line(points={{81,-40},{120,-40}}, color={0,0,127}));
  connect(hysteresis.y, switch1.u2)
    annotation (Line(points={{-39,40},{58,40}}, color={255,0,255}));
  connect(not1.y,switch3. u2)
    annotation (Line(points={{23,-4},{46,-4},{46,-40},{58,-40}},
                                                 color={255,0,255}));
  connect(signalSplitter.y1,switch3. u1) annotation (Line(points={{11,-36},{52,
          -36},{52,-32},{58,-32}},          color={0,0,127}));
  connect(signalSplitter.y2,switch3. u3) annotation (Line(points={{11,-44},{52,
          -44},{52,-48},{58,-48}},  color={0,0,127}));
  connect(signalSplitter.y2, switch1.u3) annotation (Line(points={{11,-44},{38,
          -44},{38,32},{58,32}},                    color={0,0,127}));
  connect(heatingCurve.y, conPI.u_s) annotation (Line(points={{-59,-10},{-52,
          -10},{-52,-40},{-48,-40}}, color={0,0,127}));
  connect(heatingCurve.u, TAmb) annotation (Line(points={{-82,-10},{-88,-10},{
          -88,40},{-120,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AsHPGsHpModulating;
