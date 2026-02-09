within IOCSmod.Demand.BaseClasses;
partial model EnergyHubInterface "Interface for energy hub blocks"
  extends IOCSmod.Demand.BaseClasses.BlockInterface;


  annotation (Icon(graphics={Rectangle(
          extent={{-2,-60},{2,-100}},
          lineColor={0,140,72},
          lineThickness=1,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{-20,-78},{20,-82}},
          lineColor={0,140,72},
          lineThickness=1,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EnergyHubInterface;
