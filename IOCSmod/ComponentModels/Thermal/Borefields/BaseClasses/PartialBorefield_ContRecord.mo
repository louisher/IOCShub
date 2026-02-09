within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses;
model PartialBorefield_ContRecord
  extends
    IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.PartialBorefield_Cont(
      redeclare replaceable
      IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponseContRecord
      groTemRes(groTemResDat=groTemResDat));

  parameter HeatTransfer.Data.GroundResponseDataTemplate groTemResDat
    "Ground response parameters";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<li>
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
</html>"));
end PartialBorefield_ContRecord;
