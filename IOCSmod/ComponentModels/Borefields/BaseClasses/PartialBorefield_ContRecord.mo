within IOCSmod.ComponentModels.Borefields.BaseClasses;
model PartialBorefield_ContRecord
  extends IOCSmod.ComponentModels.Borefields.BaseClasses.PartialBorefield_Cont(
      redeclare
      IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponseContRecord
      groTemRes(rCel=rCel, kappa=kappa));
     parameter
    IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.Data.RCelTemplate
    rCel annotation (choicesAllMatching=true);
     parameter
    IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.Data.KappaTemplate
    kappa annotation (choicesAllMatching=true);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<li>
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
</html>"));
end PartialBorefield_ContRecord;
