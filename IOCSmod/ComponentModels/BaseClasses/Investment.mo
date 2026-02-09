within IOCSmod.ComponentModels.BaseClasses;
model Investment
  parameter Real inv_cost(fixed=false, start=0) "Relative investment cost per unit of Size";
  parameter Real interest_rate(fixed=false, start=0);
  parameter Integer lifetime(fixed=false, start=0) "Lifetime in years";
  parameter Integer observation_time(fixed=false, start=0) "Observation time in years";


  Modelica.Blocks.Interfaces.RealOutput annInvCost "Value of Real output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Sources.RealExpression ExprAnnInvCost(y=IOCSmod.ComponentModels.BaseClasses.AnnInvCost(inv_cost, interest_rate, lifetime, observation_time))
    "Annualized investment cost per unit of Size" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));

equation
  connect(ExprAnnInvCost.y, annInvCost)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="inv", Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-100,100},{100,0}},
          textColor={0,0,0},
          textString="€"), Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1),
        Text(
          extent={{-72,-16},{76,-82}},
          textColor={0,0,0},
          textString="Inv")}),Diagram(coordinateSystem(preserveAspectRatio=false)));
end Investment;
