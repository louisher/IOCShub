within IOCSmod.Simulation.Controls;
model PasCoo

  parameter Modelica.Units.SI.Temperature TSetPasCoo = 18 +273.15;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       TBor
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput
                                           PasCoo annotation (Placement(
        transformation(extent={{100,-20},{140,20}}),  iconTransformation(extent=
           {{100,-20},{140,20}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       TSupply
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  IDEAS.Controls.Continuous.LimPID conPID(
    k=1,                                  Ti=300, reverseActing=false)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       activate
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Math.BooleanToReal    booleanToReal
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Modelica.Blocks.Logical.Hysteresis          hysteresis(
                                                       uLow=14 + 273.15,
      uHigh=16 + 273.15)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Logical.Not            not1
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Constant                  const(k=TSetPasCoo)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(product1.y, PasCoo)
    annotation (Line(points={{81,0},{120,0}}, color={0,0,127}));
  connect(TSupply, conPID.u_m) annotation (Line(points={{-120,-60},{-10,-60},{
          -10,-42}},                     color={0,0,127}));
  connect(activate, product2.u1) annotation (Line(points={{-120,60},{24,60},{24,
          56},{28,56}}, color={0,0,127}));
  connect(booleanToReal.y, product2.u2) annotation (Line(points={{11,30},{24,30},
          {24,44},{28,44}}, color={0,0,127}));
  connect(product2.y, product1.u1) annotation (Line(points={{51,50},{68,50},{68,
          14},{58,14},{58,6}}, color={0,0,127}));
  connect(conPID.y, product1.u2) annotation (Line(points={{1,-30},{50,-30},{50,
          -6},{58,-6}}, color={0,0,127}));
  connect(hysteresis.y, not1.u)
    annotation (Line(points={{-59,0},{-52,0}}, color={255,0,255}));
  connect(not1.y, booleanToReal.u) annotation (Line(points={{-29,0},{-18,0},{
          -18,22},{-20,22},{-20,30},{-12,30}}, color={255,0,255}));
  connect(TBor, hysteresis.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(const.y, conPID.u_s)
    annotation (Line(points={{-39,-30},{-22,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PasCoo;
