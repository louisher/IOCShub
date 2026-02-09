within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data;
record GroundResponseDataTemplate
  "Template for ground response data records (kappa, rCel)"
  extends Modelica.Icons.Record;

  parameter IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.RCelTemplate rCel "Record wit rCel (cell widths) values";
  parameter IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.KappaTemplate kappa "Record with kappa values";
protected
    parameter Integer i = size(rCel.rCel, 1) "Number of aggregation cells";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GroundResponseDataTemplate;
