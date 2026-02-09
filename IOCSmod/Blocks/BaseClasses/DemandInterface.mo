within IOCSmod.Blocks.BaseClasses;
partial model DemandInterface "Interface for demand blocks"
  extends IOCSmod.Blocks.BaseClasses.BlockInterface;
  annotation (defaultComponentName="dem", Icon(graphics={Text(
          extent={{-152,100},{148,140}},
          textColor={238,46,47},
          textString="%name"),
          Rectangle(lineColor = {238, 46, 47}, fillColor = {238, 46, 47},
            fillPattern = FillPattern.Solid,lineThickness = 1, extent = {{-20, -88}, {20, -92}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end DemandInterface;
