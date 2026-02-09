within IOCSmod.Blocks.Demand.SingleBuildings;
model OneHouseIdeal
    extends IOCSmod.Blocks.Demand.SingleBuildings.BaseClasses.OneHouseBase(
    hasEl=false,
    hasHyd=false,
    redeclare IOCSmod.Demand.BuildingModels.TwoZoneIdeal House1);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OneHouseIdeal;
