within IOCSmod.Simulation.Controls;
block SignalSplitter
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y1
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput y2
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Math.Gain                            gain(
                                                           k=2)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Nonlinear.Limiter        limiter(
                                               uMax=1, uMin=0)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Math.Add                  add(k2=-1)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Constant                  const(
                                                        k=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Nonlinear.Limiter        limiter1(
                                                uMax=1, uMin=0)
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
equation
  connect(u, gain.u)
    annotation (Line(points={{-120,0},{-62,0}}, color={0,0,127}));
  connect(gain.y, add.u1) annotation (Line(points={{-39,0},{-30,0},{-30,-24},{
          -22,-24}}, color={0,0,127}));
  connect(const.y, add.u2) annotation (Line(points={{-39,-50},{-30,-50},{-30,
          -36},{-22,-36}}, color={0,0,127}));
  connect(gain.y, limiter.u) annotation (Line(points={{-39,0},{28,0},{28,40},{
          38,40}}, color={0,0,127}));
  connect(limiter.y, y1)
    annotation (Line(points={{61,40},{110,40}}, color={0,0,127}));
  connect(add.y, limiter1.u) annotation (Line(points={{1,-30},{30,-30},{30,-40},
          {38,-40}}, color={0,0,127}));
  connect(limiter1.y, y2)
    annotation (Line(points={{61,-40},{110,-40}}, color={0,0,127}));
end SignalSplitter;
