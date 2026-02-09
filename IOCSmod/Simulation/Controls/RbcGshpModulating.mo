within IOCSmod.Simulation.Controls;
model RbcGshpModulating
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       TTan
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput
                                        GsHp "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  IDEAS.Controls.Continuous.LimPID conPID(k=1, Ti=100,
    yMax=1,
    yMin=0,
    reverseActing=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput
                                       TAmb
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  IDEAS.Controls.SetPoints.Table heatingCurve(table=[273.15 - 10,273.15 + 45;
        273.15 + 5,273.15 + 40; 273.15 + 20,273.15 + 25])
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(TTan, conPID.u_m)
    annotation (Line(points={{-120,-40},{0,-40},{0,-12}},   color={0,0,127}));
  connect(conPID.y, GsHp) annotation (Line(points={{11,0},{120,0}},
                 color={0,0,127}));
  connect(TAmb, heatingCurve.u)
    annotation (Line(points={{-120,40},{-82,40}}, color={0,0,127}));
  connect(heatingCurve.y, conPID.u_s) annotation (Line(points={{-59,40},{-40,40},
          {-40,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RbcGshpModulating;
