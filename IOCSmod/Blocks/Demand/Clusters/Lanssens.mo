within IOCSmod.Blocks.Demand.Clusters;
model Lanssens
  extends IOCSmod.Blocks.BaseClasses.DemandInterface
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  IOCSmod.Demand.BuildingModels.Lanssens Houses(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{8,14},{-12,34}})));
equation
  connect(Houses.port_b, port_b) annotation (Line(points={{-4,14},{-4,-40},{-60,
          -40},{-60,-100}}, color={0,127,255}));
  connect(Houses.P, P) annotation (Line(points={{-13,18.6},{-58,18.6},{-58,90},{
          -110,90}}, color={0,0,127}));
  connect(Houses.port_a, port_a) annotation (Line(points={{0,14},{0,-40},{60,
          -40},{60,-100}},
                      color={0,127,255}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-20,60},{20,20}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,-16},{-44,-56}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-84,-16},{-64,4},{-44,-16},{-64,-16},{-84,-16}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,60},{0,80},{20,60},{0,60},{-20,60}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,-18},{76,-58}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-18},{56,2},{76,-18},{56,-18},{36,-18}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end Lanssens;
