within IOCSmod.Blocks.BaseClasses;
partial model EnergyHubInterface "Interface for energy hub blocks"
  extends IOCSmod.Blocks.BaseClasses.BlockInterface;

  annotation (defaultComponentName="sup", Icon(graphics={Text(
          extent={{-152,100},{148,140}},
          textColor={0,140,72},
          textString="%name"),
          Rectangle(
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
