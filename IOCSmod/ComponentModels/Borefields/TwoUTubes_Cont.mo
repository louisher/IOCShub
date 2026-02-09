within IOCSmod.ComponentModels.Borefields;
model TwoUTubes_Cont "Double U-tube borefield model with a continuous ground model"
  extends
    IOCSmod.ComponentModels.Borefields.BaseClasses.PartialBorefield_ContRecord(
      redeclare
      IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.TwoUTube borHol)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  annotation (Documentation(revisions="<html>
<ul>
<li>
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
<ul>
</html>"));
end TwoUTubes_Cont;
