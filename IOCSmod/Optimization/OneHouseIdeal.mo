within IOCSmod.Optimization;
model OneHouseIdeal
  extends IOCSmod.Optimization.Interface;
  Blocks.Demand.SingleBuildings.OneHouseIdeal buildings(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OneHouseIdeal;
