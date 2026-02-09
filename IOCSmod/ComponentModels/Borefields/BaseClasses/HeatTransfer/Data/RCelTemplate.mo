within IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.Data;
record RCelTemplate
  "Template for external aggregation data records for the cell widths for load aggregation"
  extends Modelica.Icons.Record;
  parameter Real[:] rCel
  "Cell widths for load aggregation";

  annotation (
    defaultComponentName="rCel",
    defaultComponentPrefixes="parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end RCelTemplate;
