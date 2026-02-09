within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data;
record KappaTemplate
  "Template for external aggregation data records for the cell weighting factors for load aggregation"
  extends Modelica.Icons.Record;
  parameter Real[:] kappa
  "Weight factor for each load aggregation cell";

  annotation (
    defaultComponentName="kappa",
    defaultComponentPrefixes="parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end KappaTemplate;
