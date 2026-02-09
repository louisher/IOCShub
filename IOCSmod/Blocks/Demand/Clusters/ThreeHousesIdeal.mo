within IOCSmod.Blocks.Demand.Clusters;
model ThreeHousesIdeal
  extends IOCSmod.Blocks.Demand.Clusters.BaseClasses.ThreeHousesBase(hasEl=false, hasHyd=false,
  redeclare IOCSmod.Demand.BuildingModels.TwoZoneIdeal House1,
  redeclare IOCSmod.Demand.BuildingModels.TwoZoneIdeal House2,
  redeclare IOCSmod.Demand.BuildingModels.TwoZoneIdeal House3);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));


end ThreeHousesIdeal;
